From: akpm@linux-foundation.org
Subject: + arm-fix-memset-size-error.patch added to -mm tree
Date: Mon, 05 Nov 2007 17:11:57 -0800
Message-ID: <200711060111.lA61Bvq6029287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755923AbXKFBMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 20:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, rmk@arm.linux.org.uk


The patch titled
     ARM: fix memset size error
has been added to the -mm tree.  Its filename is
     arm-fix-memset-size-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

time-fix-inconsistent-function-names-in-comments.patch
git-drm.patch
arm-fix-memset-size-error.patch
ia64-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
