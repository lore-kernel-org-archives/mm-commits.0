From: akpm@linux-foundation.org
Subject: [merged] ia64-beyond-iosapic_intr_infos-arraysize.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:27 -0800
Message-ID: <200902261930.n1QJURdh014420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbZBZTab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:30:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix access beyond iosapic_intr_info's array size
has been removed from the -mm tree.  Its filename was
     ia64-beyond-iosapic_intr_infos-arraysize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

