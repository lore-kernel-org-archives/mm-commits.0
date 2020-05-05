From: akpm@linux-foundation.org
Subject: + arch-x86-makefile-use-config_shell.patch added to -mm
 tree
Date: Tue, 05 May 2020 14:13:01 -0700
Message-ID: <20200505211301.9_zLPwR3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEEVND (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 17:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, mm-commits@vger.kernel.org, ndesaulniers@google.com


The patch titled
     Subject: arch/x86/Makefile: use $(CONFIG_SHELL)
has been added to the -mm tree.  Its filename is
     arch-x86-makefile-use-config_shell.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-makefile-use-config_shell.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-makefile-use-config_shell.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
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
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch
