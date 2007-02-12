From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-ia64-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:39:14 -0800
Message-ID: <200702120739.l1C7dF7e025002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088AbXBLHjS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:39:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alon.barlev@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     dynamic-kernel-command-line-ia64 fix
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-ia64-fix.patch

This patch was dropped because it was folded into dynamic-kernel-command-line-ia64.patch

------------------------------------------------------
Subject: dynamic-kernel-command-line-ia64 fix
From: Andrew Morton <akpm@osdl.org>

Make the completely wrong only very wrong.

Cc: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    3 ++-
 arch/ia64/kernel/sal.c |    3 ++-
 ia64/kernel/setup.c    |    0 
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/efi.c~dynamic-kernel-command-line-ia64-fix arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~dynamic-kernel-command-line-ia64-fix
+++ a/arch/ia64/kernel/efi.c
@@ -405,6 +405,8 @@ efi_map_pal_code (void)
 	ia64_srlz_i();
 }
 
+extern char __initdata boot_command_line[];
+
 void __init
 efi_init (void)
 {
@@ -413,7 +415,6 @@ efi_init (void)
 	efi_char16_t *c16;
 	u64 efi_desc_size;
 	char *cp, vendor[100] = "unknown";
-	extern char __initdata boot_command_line[];
 	int i;
 
 	/* it's too early to be able to use the standard kernel command line support... */
diff -puN arch/ia64/kernel/sal.c~dynamic-kernel-command-line-ia64-fix arch/ia64/kernel/sal.c
--- a/arch/ia64/kernel/sal.c~dynamic-kernel-command-line-ia64-fix
+++ a/arch/ia64/kernel/sal.c
@@ -190,11 +190,12 @@ sal_desc_ap_wakeup (void *p)
 	}
 }
 
+extern char __initdata boot_command_line[];
+
 static void __init
 chk_nointroute_opt(void)
 {
 	char *cp;
-	extern char __initdata boot_command_line[];
 
 	for (cp = boot_command_line; *cp; ) {
 		if (memcmp(cp, "nointroute", 10) == 0) {
diff -puN arch/ia64/kernel/setup.c~dynamic-kernel-command-line-ia64-fix arch/ia64/kernel/setup.c
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-generalize-metadata-read-write.patch
dynamic-kernel-command-line-ia64.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-4.patch
