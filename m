From: akpm@linux-foundation.org
Subject: [obsolete] bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:08:05 -0800
Message-ID: <201003102008.o2AK86PS000997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab0CJUI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:08:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adobriyan@gmail.com, akpm@linux-foundation.org, davem@davemloft.net, dedekind@infradead.org, dwalker@codeaurora.org, dwmw2@infradead.org, rmk@arm.linux.org.uk


The patch titled
     bitops: rename for_each_bit() to for_each_set_bit(): arm
has been removed from the -mm tree.  Its filename was
     bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: rename for_each_bit() to for_each_set_bit(): arm
From: Akinobu Mita <akinobu.mita@gmail.com>

Rename for_each_bit to for_each_set_bit in the kernel source tree.  To
permit for_each_clear_bit(), should that ever be added.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-msm/pm.c  |    2 +-
 arch/arm/mach-msm/pm2.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-msm/pm.c~bitops-rename-for_each_bit-to-for_each_set_bit-arm arch/arm/mach-msm/pm.c
--- a/arch/arm/mach-msm/pm.c~bitops-rename-for_each_bit-to-for_each_set_bit-arm
+++ a/arch/arm/mach-msm/pm.c
@@ -764,7 +764,7 @@ static int msm_pm_read_proc(
 
 	if (!off) {
 		SNPRINTF(p, count, "Clocks against last TCXO shutdown:\n");
-		for_each_bit(i, msm_pm_clocks_no_tcxo_shutdown, NR_CLKS) {
+		for_each_set_bit(i, msm_pm_clocks_no_tcxo_shutdown, NR_CLKS) {
 			clk_name[0] = '\0';
 			msm_clock_get_name(i, clk_name, sizeof(clk_name));
 			SNPRINTF(p, count, "  %s (id=%d)\n", clk_name, i);
diff -puN arch/arm/mach-msm/pm2.c~bitops-rename-for_each_bit-to-for_each_set_bit-arm arch/arm/mach-msm/pm2.c
--- a/arch/arm/mach-msm/pm2.c~bitops-rename-for_each_bit-to-for_each_set_bit-arm
+++ a/arch/arm/mach-msm/pm2.c
@@ -698,7 +698,7 @@ static int msm_pm_read_proc
 
 	if (!off) {
 		SNPRINTF(p, count, "Clocks against last TCXO shutdown:\n");
-		for_each_bit(i, msm_pm_clocks_no_tcxo_shutdown, NR_CLKS) {
+		for_each_set_bit(i, msm_pm_clocks_no_tcxo_shutdown, NR_CLKS) {
 			clk_name[0] = '\0';
 			msm_clock_get_name(i, clk_name, sizeof(clk_name));
 			SNPRINTF(p, count, "  %s (id=%d)\n", clk_name, i);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

sgi-gru-use-for_each_set_bit.patch
linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
bitops-remove-temporary-for_each_bit.patch

