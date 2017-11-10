From: akpm@linux-foundation.org
Subject: +
 tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch added
 to -mm tree
Date: Fri, 10 Nov 2017 14:39:49 -0800
Message-ID: <5a062ab5.aKf3FW+irqfApNGa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754778AbdKJWju (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2017 17:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jpoimboe@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/objtool/Makefile: don't assume sync-check.sh is executable
has been added to the -mm tree.  Its filename is
     tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/objtool/Makefile: don't assume sync-check.sh is executable

patch(1) loses the x bit.  Kernel build breaks.

Fixes: 3bd51c5a371de ("objtool: Move kernel headers/code sync check to a script")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/objtool/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/objtool/Makefile~tools-objtool-makefile-dont-assume-sync-checksh-is-executable tools/objtool/Makefile
--- a/tools/objtool/Makefile~tools-objtool-makefile-dont-assume-sync-checksh-is-executable
+++ a/tools/objtool/Makefile
@@ -44,7 +44,7 @@ $(OBJTOOL_IN): fixdep FORCE
 	@$(MAKE) $(build)=objtool
 
 $(OBJTOOL): $(LIBSUBCMD) $(OBJTOOL_IN)
-	@./sync-check.sh
+	@$(CONFIG_SHELL) ./sync-check.sh
 	$(QUIET_LINK)$(CC) $(OBJTOOL_IN) $(LDFLAGS) -o $@
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

