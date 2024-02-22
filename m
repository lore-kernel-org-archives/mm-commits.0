Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A29C8813
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560144; cv=none; b=rjIT3aF425lp+hXyVMTGJVX3TDiEyLqSRo2Yqzoezj2AVlO21oHudr/6ZUPVsnbZ/hGPtlBaC0cWXYZwRj6YyAHCV2IATJidTtO8YgFRgrFDU4yZkm0HeGM8NXjL+EK/6iRwK/85DXwBfVBK8eH4z83COaJILtGpTlHgznbJBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560144; c=relaxed/simple;
	bh=qfjdoAE0NgTf7lbfhDou5lVqW0C5l1UpMQuRkY2RTj0=;
	h=Date:To:From:Subject:Message-Id; b=TMbVl0PinbpnLGQkXJuWyUBoc8JrgfFXkcgZLnu2iUMebkMA4hSw4/uNCjLVro65utiNlUwi++ybDdwe/2yd2IxDSiLgdBTvh/7tSYRgBIV5udG7FwfR4zrkJSwnq6pN33jtd6XwR/WAQxrJc+xOb0zEBeZQ5Pplsqk7ZwAXLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v8K0mk1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v8K0mk1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BC5C43399;
	Thu, 22 Feb 2024 00:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560144;
	bh=qfjdoAE0NgTf7lbfhDou5lVqW0C5l1UpMQuRkY2RTj0=;
	h=Date:To:From:Subject:From;
	b=v8K0mk1VMnlDpRr+wzHaJmDQP6fX0rYrRQAW8gQ9Mrv3Xp4Quz3PJR+hUOq5LjrHX
	 HOW/cuSfxQKzta9gevy8NRAGMa9lgsGYgL8HmPhb90TF9TDLQjBsAF5ILyaqYHT/xc
	 2BS4ZFmhbUn3U4Gb41dTHZZFEmiTa5W6JuU3gj8E=
Date: Wed, 21 Feb 2024 16:02:23 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx.patch removed from -mm tree
Message-Id: <20240222000223.D8BC5C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm: ptdump: rename CONFIG_DEBUG_WX to CONFIG_ARM_DEBUG_WX
has been removed from the -mm tree.  Its filename was
     arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: arm: ptdump: rename CONFIG_DEBUG_WX to CONFIG_ARM_DEBUG_WX
Date: Tue, 30 Jan 2024 11:34:32 +0100

Patch series "mm: ptdump: Refactor CONFIG_DEBUG_WX and check_wx_pages
debugfs attribute", v2.

This series refactors CONFIG_DEBUG_WX for the 5 architectures implementing
CONFIG_GENERIC_PTDUMP

First rename stuff in ARM which uses similar names while not implementing
CONFIG_GENERIC_PTDUMP.

Then define a generic version of debug_checkwx() that calls
ptdump_check_wx() when CONFIG_DEBUG_WX is set.  Call it immediately after
calling mark_rodata_ro() instead of calling it at the end of every
mark_rodata_ro().

Then implement a debugfs attribute that can be used to trigger a W^X test
at anytime and regardless of CONFIG_DEBUG_WX


This patch (of 5):

CONFIG_DEBUG_WX is a core option defined in mm/Kconfig.debug

To avoid any future conflict, rename ARM version into CONFIG_ARM_DEBUG_WX.

Link: https://lore.kernel.org/lkml/20200422152656.GF676@willie-the-truck/T/#m802eaf33efd6f8d575939d157301b35ac0d4a64f
Link: https://github.com/KSPP/linux/issues/35
Link: https://lkml.kernel.org/r/cover.1706610398.git.christophe.leroy@csgroup.eu
Link: https://lkml.kernel.org/r/fa297aa90caeb61eee2b70c6c5897a2ab58a9562.1706610398.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Phong Tran <tranmanphong@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Price <steven.price@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig.debug               |    2 +-
 arch/arm/configs/aspeed_g4_defconfig |    2 +-
 arch/arm/configs/aspeed_g5_defconfig |    2 +-
 arch/arm/include/asm/ptdump.h        |    6 +++---
 arch/arm/mm/init.c                   |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm/configs/aspeed_g4_defconfig~arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx
+++ a/arch/arm/configs/aspeed_g4_defconfig
@@ -252,7 +252,7 @@ CONFIG_DEBUG_INFO_REDUCED=y
 CONFIG_GDB_SCRIPTS=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
-CONFIG_DEBUG_WX=y
+CONFIG_ARM_DEBUG_WX=y
 CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_PANIC_TIMEOUT=-1
--- a/arch/arm/configs/aspeed_g5_defconfig~arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx
+++ a/arch/arm/configs/aspeed_g5_defconfig
@@ -302,7 +302,7 @@ CONFIG_DEBUG_INFO_REDUCED=y
 CONFIG_GDB_SCRIPTS=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
-CONFIG_DEBUG_WX=y
+CONFIG_ARM_DEBUG_WX=y
 CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_PANIC_TIMEOUT=-1
--- a/arch/arm/include/asm/ptdump.h~arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx
+++ a/arch/arm/include/asm/ptdump.h
@@ -32,10 +32,10 @@ void ptdump_check_wx(void);
 
 #endif /* CONFIG_ARM_PTDUMP_CORE */
 
-#ifdef CONFIG_DEBUG_WX
-#define debug_checkwx() ptdump_check_wx()
+#ifdef CONFIG_ARM_DEBUG_WX
+#define arm_debug_checkwx() ptdump_check_wx()
 #else
-#define debug_checkwx() do { } while (0)
+#define arm_debug_checkwx() do { } while (0)
 #endif
 
 #endif /* __ASM_PTDUMP_H */
--- a/arch/arm/Kconfig.debug~arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx
+++ a/arch/arm/Kconfig.debug
@@ -17,7 +17,7 @@ config ARM_PTDUMP_DEBUGFS
 	  kernel.
 	  If in doubt, say "N"
 
-config DEBUG_WX
+config ARM_DEBUG_WX
 	bool "Warn on W+X mappings at boot"
 	depends on MMU
 	select ARM_PTDUMP_CORE
--- a/arch/arm/mm/init.c~arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx
+++ a/arch/arm/mm/init.c
@@ -458,7 +458,7 @@ static int __mark_rodata_ro(void *unused
 void mark_rodata_ro(void)
 {
 	stop_machine(__mark_rodata_ro, NULL, NULL);
-	debug_checkwx();
+	arm_debug_checkwx();
 }
 
 #else
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


