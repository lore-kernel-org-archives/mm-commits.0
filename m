From: akpm@linux-foundation.org
Subject: [merged]
 tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch removed
 from -mm tree
Date: Tue, 16 Jan 2018 11:30:34 -0800
Message-ID: <20180116193034.hjU0Gn6Dr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeAPTaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 14:30:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jpoimboe@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org, nicolasbock@gentoo.org


The patch titled
     Subject: tools/objtool/Makefile: don't assume sync-check.sh is executable
has been removed from the -mm tree.  Its filename was
     tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/objtool/Makefile: don't assume sync-check.sh is executable

patch(1) loses the x bit.  So if a user follows our patching instructions
in Documentation/admin-guide/README.rst, their kernel will not compile.

Fixes: 3bd51c5a371de ("objtool: Move kernel headers/code sync check to a script")
Reported-by: Nicolas Bock <nicolasbock@gentoo.org>
Reported-by Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/objtool/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/objtool/Makefile~tools-objtool-makefile-dont-assume-sync-checksh-is-executable tools/objtool/Makefile
--- a/tools/objtool/Makefile~tools-objtool-makefile-dont-assume-sync-checksh-is-executable
+++ a/tools/objtool/Makefile
@@ -46,7 +46,7 @@ $(OBJTOOL_IN): fixdep FORCE
 	@$(MAKE) $(build)=objtool
 
 $(OBJTOOL): $(LIBSUBCMD) $(OBJTOOL_IN)
-	@./sync-check.sh
+	@$(CONFIG_SHELL) ./sync-check.sh
 	$(QUIET_LINK)$(CC) $(OBJTOOL_IN) $(LDFLAGS) -o $@
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

