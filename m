From: akpm@linux-foundation.org
Subject: + pata-rb532-cf-platform_get_irq-failure-ignored.patch added to -mm tree
Date: Tue, 03 Mar 2009 13:08:48 -0800
Message-ID: <200903032108.n23L8m9S003785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbZCCVJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 16:09:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     pata-rb532-cf: platform_get_irq() failure ignored
has been added to the -mm tree.  Its filename is
     pata-rb532-cf-platform_get_irq-failure-ignored.patch

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
Subject: pata-rb532-cf: platform_get_irq() failure ignored
From: Roel Kluin <roel.kluin@gmail.com>

platform_get_irq() can return -ENXIO, but since 'irq' is an unsigned int,
it does not show when the IRQ resource wasn't found.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_rb532_cf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_rb532_cf.c~pata-rb532-cf-platform_get_irq-failure-ignored drivers/ata/pata_rb532_cf.c
--- a/drivers/ata/pata_rb532_cf.c~pata-rb532-cf-platform_get_irq-failure-ignored
+++ a/drivers/ata/pata_rb532_cf.c
@@ -117,11 +117,12 @@ static __devinit int rb532_pata_driver_p
 		return -EINVAL;
 	}
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
 		return -ENOENT;
 	}
+	irq = ret;
 
 	gpio = irq_to_gpio(irq);
 	if (gpio < 0) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
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
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch

