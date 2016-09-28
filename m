From: akpm@linux-foundation.org
Subject: +
 mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
 added to -mm tree
Date: Wed, 28 Sep 2016 13:35:33 -0700
Message-ID: <57ec2995.00LWd/zG1H275nxF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbcI1Ufe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2016 16:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix
has been added to the -mm tree.  Its filename is
     mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch

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
Subject: mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix

tweak comment

Cc: Hugh Dickins <hughd@google.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix mm/ksm.c
--- a/mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix
+++ a/mm/ksm.c
@@ -300,11 +300,9 @@ static inline void free_rmap_item(struct
 static inline struct stable_node *alloc_stable_node(void)
 {
 	/*
-	 * The caller can take too long time with GFP_KERNEL when memory
-	 * is under pressure, it may be lead to the hung task. Therefore,
-	 * Adding the __GFP_HIGH to this. it grant access to some of
-	 * memory reserves. and it will make progress to make it allocation
-	 * successful at the utmost.
+	 * The allocation can take too long with GFP_KERNEL when memory is under
+	 * pressure, which may lead to hung task warnings.  Adding __GFP_HIGH
+	 * grants access to memory reserves, helping to avoid this problem.
 	 */
 	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL | __GFP_HIGH);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

