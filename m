From: akpm@linux-foundation.org
Subject: - sparc64-fix-section-mismatch-warning-in-mdescc.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:38 -0700
Message-ID: <200707230935.l6N9Zc99016506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997AbXGWJpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sparc64: fix section mismatch warning in mdesc.c
has been removed from the -mm tree.  Its filename was
     sparc64-fix-section-mismatch-warning-in-mdescc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparc64: fix section mismatch warning in mdesc.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x35264): Section mismatch: reference to .init.text:__alloc_bootmem (between 'mdesc_bootmem_alloc' and 'mdesc_bootmem_free')

Rename mdesc_mem_ops to *_ops so modpost ignores __init references and declare
mdesc_bootmem_alloc __init since it is only used during __init context.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/mdesc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sparc64/kernel/mdesc.c~sparc64-fix-section-mismatch-warning-in-mdescc arch/sparc64/kernel/mdesc.c
--- a/arch/sparc64/kernel/mdesc.c~sparc64-fix-section-mismatch-warning-in-mdescc
+++ a/arch/sparc64/kernel/mdesc.c
@@ -83,7 +83,7 @@ static void mdesc_handle_init(struct mde
 	hp->handle_size = handle_size;
 }
 
-static struct mdesc_handle *mdesc_bootmem_alloc(unsigned int mdesc_size)
+static struct mdesc_handle * __init mdesc_bootmem_alloc(unsigned int mdesc_size)
 {
 	struct mdesc_handle *hp;
 	unsigned int handle_size, alloc_size;
@@ -123,7 +123,7 @@ static void mdesc_bootmem_free(struct md
 	}
 }
 
-static struct mdesc_mem_ops bootmem_mdesc_memops = {
+static struct mdesc_mem_ops bootmem_mdesc_ops = {
 	.alloc = mdesc_bootmem_alloc,
 	.free  = mdesc_bootmem_free,
 };
@@ -860,7 +860,7 @@ void __init sun4v_mdesc_init(void)
 
 	printk("MDESC: Size is %lu bytes.\n", len);
 
-	hp = mdesc_alloc(len, &bootmem_mdesc_memops);
+	hp = mdesc_alloc(len, &bootmem_mdesc_ops);
 	if (hp == NULL) {
 		prom_printf("MDESC: alloc of %lu bytes failed.\n", len);
 		prom_halt();
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
