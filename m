From: akpm@linux-foundation.org
Subject: + autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch added to -mm tree
Date: Wed, 30 Apr 2008 13:34:25 -0700
Message-ID: <200804302034.m3UKYQOs001588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738AbYD3Ue3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 16:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, harvey.harrison@gmail.com


The patch titled
     autofs4: fix sparse warning in waitq.c:autofs4_expire_indirect()
has been added to the -mm tree.  Its filename is
     autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix sparse warning in waitq.c:autofs4_expire_indirect()
From: Ian Kent <raven@themaw.net>

Re-order some code in expire.c:autofs4_expire_indirect() to avoid compile
warning, reported by Harvey Harrison:

 CHECK   fs/autofs4/expire.c
fs/autofs4/expire.c:383:2: warning: context imbalance in
'autofs4_expire_indirect' - unexpected unlock

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN fs/autofs4/expire.c~autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect
+++ a/fs/autofs4/expire.c
@@ -333,7 +333,7 @@ static struct dentry *autofs4_expire_ind
 			/* Can we expire this guy */
 			if (autofs4_can_expire(dentry, timeout, do_now)) {
 				expired = dentry;
-				break;
+				goto found;
 			}
 			goto next;
 		}
@@ -352,7 +352,7 @@ static struct dentry *autofs4_expire_ind
 				inf->flags |= AUTOFS_INF_EXPIRING;
 				spin_unlock(&sbi->fs_lock);
 				expired = dentry;
-				break;
+				goto found;
 			}
 			spin_unlock(&sbi->fs_lock);
 		/*
@@ -363,7 +363,7 @@ static struct dentry *autofs4_expire_ind
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
 			if (expired) {
 				dput(dentry);
-				break;
+				goto found;
 			}
 		}
 next:
@@ -371,18 +371,16 @@ next:
 		spin_lock(&dcache_lock);
 		next = next->next;
 	}
-
-	if (expired) {
-		DPRINTK("returning %p %.*s",
-			expired, (int)expired->d_name.len, expired->d_name.name);
-		spin_lock(&dcache_lock);
-		list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-		spin_unlock(&dcache_lock);
-		return expired;
-	}
 	spin_unlock(&dcache_lock);
