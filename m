From: akpm@linux-foundation.org
Subject: [merged] loop-dont-increment-p-offset-with-size_t-einval.patch removed from -mm tree
Date: Mon, 09 Mar 2009 11:27:40 -0700
Message-ID: <200903091827.n29IReJB024850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbZCIS2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 14:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     loop: don't increment p->offset with (size_t) -EINVAL
has been removed from the -mm tree.  Its filename was
     loop-dont-increment-p-offset-with-size_t-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: loop: don't increment p->offset with (size_t) -EINVAL
From: Roel Kluin <roel.kluin@gmail.com>

Upon a 'transfer error block' size is set to -EINVAL, but this becomes
positive since size is unsigned: p->offset still gets incremented.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/loop.c~loop-dont-increment-p-offset-with-size_t-einval drivers/block/loop.c
--- a/drivers/block/loop.c~loop-dont-increment-p-offset-with-size_t-einval
+++ a/drivers/block/loop.c
@@ -392,8 +392,7 @@ lo_splice_actor(struct pipe_inode_info *
 	struct loop_device *lo = p->lo;
 	struct page *page = buf->page;
 	sector_t IV;
-	size_t size;
-	int ret;
+	int size, ret;
 
 	ret = buf->ops->confirm(pipe, buf);
 	if (unlikely(ret))
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
cfg80211-test-before-subtraction-on-unsigned.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch
rio-addition-has-higher-precedence-than.patch

