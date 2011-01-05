From: akpm@linux-foundation.org
Subject: + hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch added to -mm tree
Date: Wed, 05 Jan 2011 13:00:31 -0800
Message-ID: <201101052100.p05L0VWZ018105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1AEVAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 16:00:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, caiqian@redhat.com, mhocko@suse.cz, nacc@us.ibm.com


The patch titled
     hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix
has been added to the -mm tree.  Its filename is
     hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix
From: Andrew Morton <akpm@linux-foundation.org>

correctly propagate proc_doulongvec_minmax return code

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix
+++ a/mm/hugetlb.c
@@ -1859,14 +1859,16 @@ static int hugetlb_sysctl_handler_common
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
+	int ret;
 
 	if (!write)
 		tmp = h->max_huge_pages;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	if (proc_doulongvec_minmax(table, write, buffer, length, ppos))
-		return -EINVAL;
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		goto out;
 
 	if (write) {
 		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
@@ -1881,8 +1883,8 @@ static int hugetlb_sysctl_handler_common
 		if (nodes_allowed != &node_states[N_HIGH_MEMORY])
 			NODEMASK_FREE(nodes_allowed);
 	}
-
-	return 0;
+out:
+	return ret;
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
@@ -1920,22 +1922,24 @@ int hugetlb_overcommit_handler(struct ct
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
+	int ret;
 
 	if (!write)
 		tmp = h->nr_overcommit_huge_pages;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	if (proc_doulongvec_minmax(table, write, buffer, length, ppos))
-		return -EINVAL;
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		goto out;
 
 	if (write) {
 		spin_lock(&hugetlb_lock);
 		h->nr_overcommit_huge_pages = tmp;
 		spin_unlock(&hugetlb_lock);
 	}
-
-	return 0;
+out:
+	return ret;
 }
 
 #endif /* CONFIG_SYSCTL */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

