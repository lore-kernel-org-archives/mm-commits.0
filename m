From: akpm@linux-foundation.org
Subject: - autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:08 -0700
Message-ID: <200805021943.m42Jh8KF011262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357AbYEBTnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix sparse warning in waitq.c:autofs4_expire_indirect()
has been removed from the -mm tree.  Its filename was
     autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>
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
