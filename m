From: akpm@linux-foundation.org
Subject: [merged] cris-fix-some-build-warnings-in-pinmuxc.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:11 -0700
Message-ID: <201107260753.p6Q7rEXt003213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab1GZHxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: fix some build warnings in pinmux.c
has been removed from the -mm tree.  Its filename was
     cris-fix-some-build-warnings-in-pinmuxc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: fix some build warnings in pinmux.c
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix some harmless warnings such as

src/arch/cris/arch-v32/mach-a3/pinmux.c:273: warning: ISO C90 forbids mixed declarations and code:

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/mach-a3/pinmux.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/cris/arch-v32/mach-a3/pinmux.c~cris-fix-some-build-warnings-in-pinmuxc arch/cris/arch-v32/mach-a3/pinmux.c
--- a/arch/cris/arch-v32/mach-a3/pinmux.c~cris-fix-some-build-warnings-in-pinmuxc
+++ a/arch/cris/arch-v32/mach-a3/pinmux.c
@@ -85,6 +85,8 @@ crisv32_pinmux_alloc_fixed(enum fixed_fu
 	int ret = -EINVAL;
 	char saved[sizeof pins];
 	unsigned long flags;
+	reg_pinmux_rw_hwprot hwprot;
+	reg_clkgen_rw_clk_ctrl clk_ctrl;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
 
@@ -93,9 +95,8 @@ crisv32_pinmux_alloc_fixed(enum fixed_fu
 
 	crisv32_pinmux_init(); /* must be done before we read rw_hwprot */
 
-	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
-	reg_clkgen_rw_clk_ctrl clk_ctrl = REG_RD(clkgen, regi_clkgen,
-		rw_clk_ctrl);
+	hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
 
 	switch (function) {
 	case pinmux_eth:
@@ -262,6 +263,7 @@ crisv32_pinmux_dealloc_fixed(enum fixed_
 	int ret = -EINVAL;
 	char saved[sizeof pins];
 	unsigned long flags;
+	reg_pinmux_rw_hwprot hwprot;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
 
@@ -270,7 +272,7 @@ crisv32_pinmux_dealloc_fixed(enum fixed_
 
 	crisv32_pinmux_init(); /* must be done before we read rw_hwprot */
 
-	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+	hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
 
 	switch (function) {
 	case pinmux_eth:
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
gcov-disable-constructors-for-uml.patch
include-linux-dma-mappingh-remove-dma_xxbit_mask-macros.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

