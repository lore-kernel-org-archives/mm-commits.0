From: akpm@linux-foundation.org
Subject: [merged] arch-x86-makefile-use-config_shell.patch removed
 from -mm tree
Date: Mon, 11 May 2020 11:45:38 -0700
Message-ID: <20200511184538.RHqft-CPy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgEKSpj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 14:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, mm-commits@vger.kernel.org, ndesaulniers@google.com


The patch titled
     Subject: arch/x86/Makefile: use $(CONFIG_SHELL)
has been removed from the -mm tree.  Its filename was
     arch-x86-makefile-use-config_shell.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/Makefile: use $(CONFIG_SHELL)

When scripts/x86-check-compiler.sh doesn't have the x bit set:

q:/usr/src/25> make clean
make: execvp: ./scripts/x86-check-compiler.sh: Permission denied

Fix this by using $(CONFIG_SHELL).

This will happen if the user downloads and applies patch-5.7.tar.gz, since
patch(1) doesn't preserve the x bit.

Fixes: 73da86741e7f7 ("x86/build: Check whether the compiler is sane")
Cc: Borislav Petkov <bp@suse.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile~arch-x86-makefile-use-config_shell
+++ a/arch/x86/Makefile
@@ -2,7 +2,7 @@
 # Unified Makefile for i386 and x86_64
 
 #  Check the compiler
-sane_compiler := $(shell $(srctree)/scripts/x86-check-compiler.sh $(CC))
+sane_compiler := $($(CONFIG_SHELL) $(srctree)/scripts/x86-check-compiler.sh $(CC))
 $(if $(sane_compiler),$(error $(CC) check failed. Aborting),)
 
 # select defconfig based on actual architecture
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix.patch
linux-next-rejects.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
