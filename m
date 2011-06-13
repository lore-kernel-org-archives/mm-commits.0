From: akpm@linux-foundation.org
Subject: + cris-fix-some-build-warnings-in-pinmuxc.patch added to -mm tree
Date: Mon, 13 Jun 2011 16:42:08 -0700
Message-ID: <201106132342.p5DNg89C029378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab1FMXmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 19:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: fix some build warnings in pinmux.c
has been added to the -mm tree.  Its filename is
     cris-fix-some-build-warnings-in-pinmuxc.patch

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

linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
cris-fix-some-build-warnings-in-pinmuxc.patch
kexec-remove-kmsg_dump_kexec.patch

