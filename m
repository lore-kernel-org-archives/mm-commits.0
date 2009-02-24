From: akpm@linux-foundation.org
Subject: + ia64-beyond-iosapic_intr_infos-arraysize.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:29:51 -0800
Message-ID: <200902242029.n1OKTpti008677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758011AbZBXU35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:29:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, tony.luck@intel.com


The patch titled
     ia64: fix access beyond iosapic_intr_info's array size
has been added to the -mm tree.  Its filename is
     ia64-beyond-iosapic_intr_infos-arraysize.patch

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
Subject: ia64: fix access beyond iosapic_intr_info's array size
From: Roel Kluin <roel.kluin@gmail.com>

vi arch/ia64/kernel/iosapic.c +142
static struct iosapic_intr_info {
	...
} iosapic_intr_info[NR_IRQS];

So this goes beyond its array size.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/iosapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/iosapic.c~ia64-beyond-iosapic_intr_infos-arraysize arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~ia64-beyond-iosapic_intr_infos-arraysize
+++ a/arch/ia64/kernel/iosapic.c
@@ -507,7 +507,7 @@ static int iosapic_find_sharable_irq(uns
 	if (trigger == IOSAPIC_EDGE)
 		return -EINVAL;
 
-	for (i = 0; i <= NR_IRQS; i++) {
+	for (i = 0; i < NR_IRQS; i++) {
 		info = &iosapic_intr_info[i];
 		if (info->trigger == trigger && info->polarity == pol &&
 		    (info->dmode == IOSAPIC_FIXED ||
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
ia64-beyond-iosapic_intr_infos-arraysize.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
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
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

