From: akpm@linux-foundation.org
Subject: + aoe-error-printed-1-too-early.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:03:27 -0800
Message-ID: <200902262203.n1QM3RHo026880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbZBZWEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:04:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ecashin@coraid.com


The patch titled
     aoe: error printed 1 too early
has been added to the -mm tree.  Its filename is
     aoe-error-printed-1-too-early.patch

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

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch

