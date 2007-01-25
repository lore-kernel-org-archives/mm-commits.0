From: akpm@osdl.org
Subject: + dynamic-kernel-command-line-ia64.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:08:53 -0800
Message-ID: <200701250508.l0P58rei006522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47087 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965298AbXAYFI4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:08:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alon.barlev@gmail.com, tony.luck@intel.com


The patch titled
     Dynamic kernel command-line: ia64
has been added to the -mm tree.  Its filename is
     dynamic-kernel-command-line-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Dynamic kernel command-line: ia64
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/efi.c   |    4 ++--
 arch/ia64/kernel/sal.c   |    4 ++--
 arch/ia64/kernel/setup.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/ia64/kernel/efi.c~dynamic-kernel-command-line-ia64 arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~dynamic-kernel-command-line-ia64
+++ a/arch/ia64/kernel/efi.c
@@ -413,11 +413,11 @@ efi_init (void)
 	efi_char16_t *c16;
 	u64 efi_desc_size;
 	char *cp, vendor[100] = "unknown";
-	extern char saved_command_line[];
+	extern char __initdata boot_command_line[];
 	int i;
 
 	/* it's too early to be able to use the standard kernel command line support... */
-	for (cp = saved_command_line; *cp; ) {
+	for (cp = boot_command_line; *cp; ) {
 		if (memcmp(cp, "mem=", 4) == 0) {
 			mem_limit = memparse(cp + 4, &cp);
 		} else if (memcmp(cp, "max_addr=", 9) == 0) {
diff -puN arch/ia64/kernel/sal.c~dynamic-kernel-command-line-ia64 arch/ia64/kernel/sal.c
--- a/arch/ia64/kernel/sal.c~dynamic-kernel-command-line-ia64
+++ a/arch/ia64/kernel/sal.c
@@ -194,9 +194,9 @@ static void __init
 chk_nointroute_opt(void)
 {
 	char *cp;
-	extern char saved_command_line[];
+	extern char __initdata boot_command_line[];
 
-	for (cp = saved_command_line; *cp; ) {
+	for (cp = boot_command_line; *cp; ) {
 		if (memcmp(cp, "nointroute", 10) == 0) {
 			no_int_routing = 1;
 			printk ("no_int_routing on\n");
diff -puN arch/ia64/kernel/setup.c~dynamic-kernel-command-line-ia64 arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~dynamic-kernel-command-line-ia64
+++ a/arch/ia64/kernel/setup.c
@@ -262,7 +262,7 @@ reserve_memory (void)
 	 * appropriate after a kernel panic.
 	 */
 	{
-		char *from = strstr(saved_command_line, "crashkernel=");
+		char *from = strstr(boot_command_line, "crashkernel=");
 		unsigned long base, size;
 		if (from) {
 			size = memparse(from + 12, &from);
@@ -463,7 +463,7 @@ setup_arch (char **cmdline_p)
 	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
 
 	*cmdline_p = __va(ia64_boot_param->command_line);
-	strlcpy(saved_command_line, *cmdline_p, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
 
 	efi_init();
 	io_port_init();
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-alpha.patch
dynamic-kernel-command-line-arm.patch
dynamic-kernel-command-line-arm26.patch
dynamic-kernel-command-line-avr32.patch
dynamic-kernel-command-line-cris.patch
dynamic-kernel-command-line-frv.patch
dynamic-kernel-command-line-h8300.patch
dynamic-kernel-command-line-i386.patch
dynamic-kernel-command-line-ia64.patch
dynamic-kernel-command-line-m32r.patch
dynamic-kernel-command-line-m68k.patch
dynamic-kernel-command-line-m68knommu.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
dynamic-kernel-command-line-powerpc.patch
dynamic-kernel-command-line-ppc.patch
dynamic-kernel-command-line-s390.patch
dynamic-kernel-command-line-sh.patch
dynamic-kernel-command-line-sh64.patch
dynamic-kernel-command-line-sparc.patch
dynamic-kernel-command-line-sparc64.patch
dynamic-kernel-command-line-um.patch
dynamic-kernel-command-line-v850.patch
dynamic-kernel-command-line-x86_64.patch
dynamic-kernel-command-line-xtensa.patch
