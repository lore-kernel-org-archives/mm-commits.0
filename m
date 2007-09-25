From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line.patch removed from -mm tree
Date: Tue, 25 Sep 2007 12:31:10 -0700
Message-ID: <200709251931.l8PJVBlV000887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXIYTbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Fix CONFIG_NOHIGHMEM for extended crashkernel command line
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line.patch

This patch was dropped because it was folded into use-extended-crashkernel-command-line-on-i386.patch

------------------------------------------------------
Subject: Fix CONFIG_NOHIGHMEM for extended crashkernel command line
From: Bernhard Walle <bwalle@suse.de>

This patch fixes a build error with CONFIG_KEXEC=y and CONFIG_NOHIGHMEM=y.

linux-2.6-mm$ LANG=C make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      arch/i386/kernel/setup.o
arch/i386/kernel/setup.c: In function 'reserve_crashkernel':
arch/i386/kernel/setup.c:391: error: 'highend_pfn' undeclared (first use in this function)
arch/i386/kernel/setup.c:391: error: (Each undeclared identifier is reported only once
arch/i386/kernel/setup.c:391: error: for each function it appears in.)
arch/i386/kernel/setup.c:391: error: 'highstart_pfn' undeclared (first use in this function)
make[1]: *** [arch/i386/kernel/setup.o] Error 1
make: *** [arch/i386/kernel] Error 2

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/setup.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/setup.c~use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line
+++ a/arch/i386/kernel/setup.c
@@ -381,6 +381,20 @@ extern unsigned long __init setup_memory
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
+
+#ifdef CONFIG_HIGHMEM
+static inline unsigned long long get_total_mem(void)
+{
+	return (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
+}
+#else
+static inline unsigned long long get_total_mem(void)
+{
+	return max_low_pfn << PAGE_SHIFT;
+}
+#endif
+
+
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
@@ -388,7 +402,7 @@ static void __init reserve_crashkernel(v
 	unsigned long long 	crash_size, crash_base;
 	int			ret;
 
-	free_mem = (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
+	free_mem = get_total_mem();
 
 	ret = parse_crashkernel(boot_command_line, free_mem,
 			&crash_size, &crash_base);
_

Patches currently in -mm which might be from bwalle@suse.de are

ipsc-update-version-information.patch
add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line-fix.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
