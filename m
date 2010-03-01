From: akpm@linux-foundation.org
Subject: + bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch added to -mm tree
Date: Mon, 01 Mar 2010 15:46:51 -0800
Message-ID: <201003012346.o21Nkp7d006938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab0CAXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 18:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adobriyan@gmail.com, akpm@linux-foundation.org, davem@davemloft.net, dedekind@infradead.org, dwmw2@infradead.org, rmk@arm.linux.org.uk, sfr@canb.auug.org.au


The patch titled
     bitops: rename for_each_bit() to for_each_set_bit(): arm
has been added to the -mm tree.  Its filename is
     bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch

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

origin.patch
infiniband-use-for_each_set_bit.patch
linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
bitmap-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch

