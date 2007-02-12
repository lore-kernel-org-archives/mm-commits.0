From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-ia64.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:51 -0800
Message-ID: <200702122247.l1CMlp8m013943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030350AbXBLWry (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: ia64
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: ia64
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

[akpm@osdl.org: move some declarations to the right place]
Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c   |    5 +++--
 arch/ia64/kernel/sal.c   |    5 +++--
 arch/ia64/kernel/setup.c |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/ia64/kernel/efi.c~dynamic-kernel-command-line-ia64 arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~dynamic-kernel-command-line-ia64
+++ a/arch/ia64/kernel/efi.c
@@ -405,6 +405,8 @@ efi_map_pal_code (void)
 	ia64_srlz_i();
 }
 
+extern char __initdata boot_command_line[];
+
 void __init
 efi_init (void)
 {
@@ -413,11 +415,10 @@ efi_init (void)
 	efi_char16_t *c16;
 	u64 efi_desc_size;
 	char *cp, vendor[100] = "unknown";
-	extern char saved_command_line[];
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
@@ -190,13 +190,14 @@ sal_desc_ap_wakeup (void *p)
 	}
 }
 
+extern char __initdata boot_command_line[];
+
 static void __init
 chk_nointroute_opt(void)
 {
 	char *cp;
-	extern char saved_command_line[];
 
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

origin.patch
