From: akpm@linux-foundation.org
Subject: [merged] aoe-error-printed-1-too-early.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:39 -0800
Message-ID: <200903061928.n26JSd3q022793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbZCFTaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     aoe: error printed 1 too early
has been removed from the -mm tree.  Its filename was
     aoe-error-printed-1-too-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: error printed 1 too early
From: Roel Kluin <roel.kluin@gmail.com>

With while (i-- > 0); i reaches -1 after the loop, so the test below is
printed one too early: 0 still means success.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-error-printed-1-too-early drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-error-printed-1-too-early
+++ a/drivers/block/aoe/aoedev.c
@@ -173,7 +173,7 @@ skbfree(struct sk_buff *skb)
 		return;
 	while (atomic_read(&skb_shinfo(skb)->dataref) != 1 && i-- > 0)
 		msleep(Sms);
-	if (i <= 0) {
+	if (i < 0) {
 		printk(KERN_ERR
 			"aoe: %s holds ref: %s\n",
 			skb->dev ? skb->dev->name : "netif",
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
loop-dont-increment-p-offset-with-size_t-einval.patch

