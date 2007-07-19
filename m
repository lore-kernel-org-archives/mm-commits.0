From: akpm@linux-foundation.org
Subject: - i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:46 -0700
Message-ID: <200707192009.l6JK9kLc020608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760871AbXGSUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     i386: fix section mismatch warning in intel_cacheinfo
has been removed from the -mm tree.  Its filename was
     i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix section mismatch warning in intel_cacheinfo
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3818): Section mismatch: reference to .exit.text:cache_remove_dev (between 'cacheinfo_cpu_callback' and 'cache_sysfs_init')

It points out that a function marked __cpuexit is calling a function marked
__cpuinit => oops.

The call happens only in an error-condition which may explain why we have
not seen it before.

The offending function was not used anywhere else - so marked it __cpuexit.

Note: This warning triggers only with a local copy of modpost
      but that version will soon be pushed out.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~i386-fix-section-mismatch-warning-in-intel_cacheinfo arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~i386-fix-section-mismatch-warning-in-intel_cacheinfo
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -746,7 +746,7 @@ static int __cpuinit cache_add_dev(struc
 	return retval;
 }
 
-static void __cpuexit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
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
