From: akpm@linux-foundation.org
Subject: + autofs4-remove-hashed-check-in-validate_wait.patch added to -mm tree
Date: Mon, 08 Jun 2009 15:23:44 -0700
Message-ID: <200906082223.n58MNj9d024738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbZFHWXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 18:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: remove hashed check in validate_wait()
has been added to the -mm tree.  Its filename is
     autofs4-remove-hashed-check-in-validate_wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: remove hashed check in validate_wait()
From: Ian Kent <raven@themaw.net>

The recent ->lookup() deadlock correction required the directory inode
mutex to be dropped while waiting for expire completion.  We were
concerned about side effects from this change and one has been identified.

I saw several error messages.

They cause autofs to become quite confused and don't really point to the
actual problem.

Things like:

handle_packet_missing_direct:1376: can't find map entry for (43,1827932)

which is usually totally fatal (although in this case it wouldn't be
except that I treat is as such because it normally is).

do_mount_direct: direct trigger not valid or already mounted
/test/nested/g3c/s1/ss1

which is recoverable, however if this problem is at play it can cause
autofs to become quite confused as to the dependencies in the mount tree
because mount triggers end up mounted multiple times.  It's hard to
accurately check for this over mounting case and automount shouldn't need
to if the kernel module is doing its job.

There was one other message, similar in consequence of this last one but I
can't locate a log example just now.



When checking if a mount has already completed prior to adding a new mount
request to the wait queue we check if the dentry is hashed and, if so, if
it is a mount point.  But, if a mount successfully completed while we
slept on the wait queue mutex the dentry must exist for the mount to have
completed so the test is not really needed.

Mounts can also be done on top of a global root dentry, so for the above
case, where a mount request completes and the wait queue entry has already
been removed, the hashed test returning false can cause an incorrect
callback to the daemon.  Also, d_mountpoint() is not sufficient to check
if a mount has completed for the multi-mount case when we don't have a
real mount at the base of the tree.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-remove-hashed-check-in-validate_wait fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-remove-hashed-check-in-validate_wait
+++ a/fs/autofs4/waitq.c
@@ -297,20 +297,14 @@ static int validate_request(struct autof
 	 */
 	if (notify == NFY_MOUNT) {
 		/*
-		 * If the dentry isn't hashed just go ahead and try the
-		 * mount again with a new wait (not much else we can do).
-		*/
-		if (!d_unhashed(dentry)) {
-			/*
-			 * But if the dentry is hashed, that means that we
-			 * got here through the revalidate path.  Thus, we
-			 * need to check if the dentry has been mounted
-			 * while we waited on the wq_mutex. If it has,
-			 * simply return success.
-			 */
-			if (d_mountpoint(dentry))
-				return 0;
-		}
+		 * If the dentry was successfully mounted while we slept
+		 * on the wait queue mutex we can return success. If it
+		 * isn't mounted (doesn't have submounts for the case of
+		 * a multi-mount with no mount at it's base) we can
+		 * continue on and create a new request.
+		 */
+		if (have_submounts(dentry))
+			return 0;
 	}
 
 	return 1;
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-remove-hashed-check-in-validate_wait.patch

