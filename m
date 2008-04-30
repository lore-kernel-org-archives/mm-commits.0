From: akpm@linux-foundation.org
Subject: - block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:40 -0700
Message-ID: <200804300550.m3U5oeKJ030143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759200AbYD3FvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block/blk-barrier.c:blk_ordered_cur_seq() mustn't be inline
has been removed from the -mm tree.  Its filename was
     block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/blk-barrier.c:blk_ordered_cur_seq() mustn't be inline
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with UML and gcc 4.3:

/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c: In function `blk_do_ordered':
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:57: sorry, unimplemented: inlining failed in call to `blk_ordered_cur_seq': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:252: sorry, unimplemented: called from here
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:57: sorry, unimplemented: inlining failed in call to `blk_ordered_cur_seq': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:253: sorry, unimplemented: called from here

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-barrier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-barrier.c~block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline block/blk-barrier.c
--- a/block/blk-barrier.c~block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline
+++ a/block/blk-barrier.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL(blk_queue_ordered);
 /*
  * Cache flushing for ordered writes handling
  */
-inline unsigned blk_ordered_cur_seq(struct request_queue *q)
+unsigned blk_ordered_cur_seq(struct request_queue *q)
 {
 	if (!q->ordseq)
 		return 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

