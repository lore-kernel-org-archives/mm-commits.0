From: akpm@linux-foundation.org
Subject: - arm-fix-memset-size-error.patch removed from -mm tree
Date: Sat, 01 Dec 2007 03:57:01 -0800
Message-ID: <200712011157.lB1Bv1se021506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396AbXLAL5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 1 Dec 2007 06:57:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ARM: fix memset size error
has been removed from the -mm tree.  Its filename was
     arm-fix-memset-size-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM: fix memset size error
From: Li Zefan <lizf@cn.fujitsu.com>

The size passing to memset is wrong.  And here we can replace kmalloc with
kzalloc.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/uengine.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/arm/common/uengine.c~arm-fix-memset-size-error arch/arm/common/uengine.c
--- a/arch/arm/common/uengine.c~arm-fix-memset-size-error
+++ a/arch/arm/common/uengine.c
@@ -374,8 +374,8 @@ static int set_initial_registers(int uen
 	u8 *ucode;
 	int i;
 
-	gpr_a = kmalloc(128 * sizeof(u32), GFP_KERNEL);
-	gpr_b = kmalloc(128 * sizeof(u32), GFP_KERNEL);
+	gpr_a = kzalloc(128 * sizeof(u32), GFP_KERNEL);
+	gpr_b = kzalloc(128 * sizeof(u32), GFP_KERNEL);
 	ucode = kmalloc(513 * 5, GFP_KERNEL);
 	if (gpr_a == NULL || gpr_b == NULL || ucode == NULL) {
 		kfree(ucode);
@@ -388,8 +388,6 @@ static int set_initial_registers(int uen
 	if (c->uengine_parameters & IXP2000_UENGINE_4_CONTEXTS)
 		per_ctx_regs = 32;
 
-	memset(gpr_a, 0, sizeof(gpr_a));
-	memset(gpr_b, 0, sizeof(gpr_b));
 	for (i = 0; i < 256; i++) {
 		struct ixp2000_reg_value *r = c->initial_reg_values + i;
 		u32 *bank;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
