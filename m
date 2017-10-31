From: akpm@linux-foundation.org
Subject: + support-resetting-warn_once-for-all-architectures-v2-fix.patch
 added to -mm tree
Date: Tue, 31 Oct 2017 16:26:29 -0700
Message-ID: <59f906a5.eB5TZx6VEHOwlZuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbdJaX0a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Oct 2017 19:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-for-all-architectures-v2-fix
has been added to the -mm tree.  Its filename is
     support-resetting-warn_once-for-all-architectures-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/support-resetting-warn_once-for-all-architectures-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/support-resetting-warn_once-for-all-architectures-v2-fix.patch

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
Subject: support-resetting-warn_once-for-all-architectures-v2-fix

fix unused var warning

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bug.c~support-resetting-warn_once-for-all-architectures-v2-fix lib/bug.c
--- a/lib/bug.c~support-resetting-warn_once-for-all-architectures-v2-fix
+++ a/lib/bug.c
@@ -206,9 +206,9 @@ static void clear_once_table(struct bug_
 
 void generic_bug_clear_once(void)
 {
+#ifdef CONFIG_MODULES
 	struct module *mod;
 
-#ifdef CONFIG_MODULES
 	rcu_read_lock_sched();
 	list_for_each_entry_rcu(mod, &module_bug_list, bug_list)
 		clear_once_table(mod->bug_table,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-deferred_init_memmap-improvements-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

