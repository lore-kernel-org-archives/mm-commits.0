From: akpm@linux-foundation.org
Subject: + autofs4-fix-incorrect-return-from-rootc-try_to_fill_dentry.patch added to -mm tree
Date: Wed, 30 Apr 2008 13:34:31 -0700
Message-ID: <200804302034.m3UKYWcq001602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760545AbYD3Uey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 16:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, raven@themaw.net


The patch titled
     autofs4: fix incorrect return from root.c:try_to_fill_dentry()
has been added to the -mm tree.  Its filename is
     autofs4-fix-incorrect-return-from-rootc-try_to_fill_dentry.patch

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
Subject: autofs4: fix incorrect return from root.c:try_to_fill_dentry()
From: Jeff Moyer <jmoyer@redhat.com>

Jeff Moyer has identified a case where the autofs4 function
root.c:try_to_fill_dentry() can return -EBUSY when it should return 0.

Jeff's description of the way this happens is:

"automount starts an expire for directory d.  after the callout to the daemon,
but before the rmdir, another process tries to walk into the same directory. 
It puts itself onto the waitq, pending the expiration.

When the expire finishes, the second process is woken up.  In
try_to_fill_dentry, it does this check:

                status = d_invalidate(dentry);
                if (status != -EBUSY)
                        return -EAGAIN;

And status is EBUSY.  The dentry still has a non-zero d_inode, and the
flags do not contain LOOKUP_CONTINUE or LOOKUP_DIRECTORY

So, we fall through and return -EBUSY to the caller."

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-incorrect-return-from-rootc-try_to_fill_dentry fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-incorrect-return-from-rootc-try_to_fill_dentry
+++ a/fs/autofs4/root.c
@@ -243,7 +243,7 @@ static int try_to_fill_dentry(struct den
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct dentry *new;
-	int status = 0;
+	int status;
 
 	/* Block on any pending expiry here; invalidate the dentry
            when expiration is done to trigger mount request with a new
@@ -340,7 +340,7 @@ static int try_to_fill_dentry(struct den
 		}
 	}
 
-	return status;
+	return 0;
 }
 
 /* For autofs direct mounts the follow link triggers the mount */
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch
autofs4-fix-execution-order-race-in-mount-request-code.patch
autofs4-fix-incorrect-return-from-rootc-try_to_fill_dentry.patch

