From: akpm@linux-foundation.org
Subject: - x86-fix-section-mismatch-warnings-in-mtrr.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:47 -0700
Message-ID: <200707192008.l6JK8lNI020486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760733AbXGSUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     x86: fix section mismatch warnings in mtrr
has been removed from the -mm tree.  Its filename was
     x86-fix-section-mismatch-warnings-in-mtrr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: fix section mismatch warnings in mtrr
From: Sam Ravnborg <sam@ravnborg.org>

Following section mismatch warnings were reported by Andrey Borzenkov:

WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967a) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967f) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x9684) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770) and 'generic_get_mtrr'

It was tracked down to a few functions missing __init tag.
Compile tested only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~x86-fix-section-mismatch-warnings-in-mtrr arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~x86-fix-section-mismatch-warnings-in-mtrr
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -79,7 +79,7 @@ static void print_fixed(unsigned base, u
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void get_mtrr_state(void)
+void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
diff -puN arch/i386/kernel/cpu/mtrr/main.c~x86-fix-section-mismatch-warnings-in-mtrr arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~x86-fix-section-mismatch-warnings-in-mtrr
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -648,7 +648,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-__init void mtrr_bp_init(void)
+void __init mtrr_bp_init(void)
 {
 	init_ifs();
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
