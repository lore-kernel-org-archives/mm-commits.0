From: akpm@linux-foundation.org
Subject: + fuse-fix-sparse-warnings.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:26:43 -0700
Message-ID: <200804280226.m3S2Qhtd003434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764994AbYD1C1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix sparse warnings
has been added to the -mm tree.  Its filename is
     fuse-fix-sparse-warnings.patch

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
Subject: fuse: fix sparse warnings
From: Miklos Szeredi <mszeredi@suse.cz>

fs/fuse/dev.c:306:2: warning: context imbalance in 'wait_answer_interruptible' - unexpected unlock
fs/fuse/dev.c:361:2: warning: context imbalance in 'request_wait_answer' - unexpected unlock
fs/fuse/dev.c:1002:4: warning: context imbalance in 'end_io_requests' - unexpected unlock

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fuse/dev.c~fuse-fix-sparse-warnings fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-fix-sparse-warnings
+++ a/fs/fuse/dev.c
@@ -299,6 +299,7 @@ static void request_end(struct fuse_conn
 
 static void wait_answer_interruptible(struct fuse_conn *fc,
 				      struct fuse_req *req)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	if (signal_pending(current))
 		return;
@@ -315,8 +316,8 @@ static void queue_interrupt(struct fuse_
 	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
 }
 
-/* Called with fc->lock held.  Releases, and then reacquires it. */
 static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	if (!fc->no_interrupt) {
 		/* Any signal may interrupt this */
@@ -987,6 +988,7 @@ static void end_requests(struct fuse_con
  * locked).
  */
 static void end_io_requests(struct fuse_conn *fc)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	while (!list_empty(&fc->io)) {
 		struct fuse_req *req =
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-nfsd.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
ecryptfs-add-missing-lock-around-notify_change.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

