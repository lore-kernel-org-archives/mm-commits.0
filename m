From: akpm@linux-foundation.org
Subject: + loop-dont-increment-p-offset-with-size_t-einval.patch added to -mm tree
Date: Wed, 04 Mar 2009 14:26:50 -0800
Message-ID: <200903042226.n24MQoMr010136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbZCDW13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 17:27:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jens.axboe@oracle.com


The patch titled
     loop: don't increment p->offset with (size_t) -EINVAL
has been added to the -mm tree.  Its filename is
     loop-dont-increment-p-offset-with-size_t-einval.patch

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
watchdog-fsl_get_sys_freq-failure-not-noticed.patch
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
aoe-error-printed-1-too-early.patch
loop-dont-increment-p-offset-with-size_t-einval.patch

