From: akpm@linux-foundation.org
Subject: - x86_64-fix-section-mismatch-warning-in-hpetc.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:48 -0700
Message-ID: <200707230935.l6N9Zm98016518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758573AbXGWJpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix section mismatch warning in hpet.c
has been removed from the -mm tree.  Its filename was
     x86_64-fix-section-mismatch-warning-in-hpetc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix section mismatch warning in hpet.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.text+0x945e): Section mismatch: reference to .init.text:__set_fixmap (between 'hpet_arch_init' and 'hpet_mask_rtc_irq_bit')
WARNING: vmlinux.o(.text+0x9474): Section mismatch: reference to .init.text:__set_fixmap (between 'hpet_arch_init' and 'hpet_mask_rtc_irq_bit')

hpet_arch_init is only used from __init context so mark it __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/hpet.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/hpet.c~x86_64-fix-section-mismatch-warning-in-hpetc arch/x86_64/kernel/hpet.c
--- a/arch/x86_64/kernel/hpet.c~x86_64-fix-section-mismatch-warning-in-hpetc
+++ a/arch/x86_64/kernel/hpet.c
@@ -133,7 +133,7 @@ struct clocksource clocksource_hpet = {
 	.vread		= vread_hpet,
 };
 
-int hpet_arch_init(void)
+int __init hpet_arch_init(void)
 {
 	unsigned int id;
 	u64 tmp;
_

Patches currently in -mm which might be from sam@ravnborg.org are

powerpc-vdso-install-unstripped-copies-on-disk.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
