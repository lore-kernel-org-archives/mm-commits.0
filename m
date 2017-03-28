From: akpm@linux-foundation.org
Subject: +
 swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch added
 to -mm tree
Date: Tue, 28 Mar 2017 16:59:19 -0700
Message-ID: <58daf8d7.VVN7G6wW2k9HENp9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53264 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932623AbdC1X7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix
has been added to the -mm tree.  Its filename is
     swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

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
Subject: swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix

use WARN_ONCE return value, fix grammar in message

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix mm/swap_slots.c
--- a/mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix
+++ a/mm/swap_slots.c
@@ -241,11 +241,10 @@ int enable_swap_slots_cache(void)
 
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
 				alloc_swap_slot_cache, free_slot_cache);
-	if (ret < 0) {
-		WARN_ONCE(1, "Cache allocation failed (%s), operate without swap slots cache.\n",
-				__func__);
+	if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
+			       "without swap slots cache.\n", __func__))
 		goto out_unlock;
-	}
+
 	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

