From: akpm@linux-foundation.org
Subject: +
 sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings.patch
 added to -mm tree
Date: Mon, 08 Jun 2015 14:55:27 -0700
Message-ID: <55760f4f./qEyMLzwsom6ZRhK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbFHVz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 17:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, jovi@cloudflare.com, mingo@elte.hu, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched, numa: do not hint for NUMA balancing on VM_MIXEDMAP mappings
has been added to the -mm tree.  Its filename is
     sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: sched, numa: do not hint for NUMA balancing on VM_MIXEDMAP mappings

Jovi Zhangwei reported the following problem

  Below kernel vm bug can be triggered by tcpdump which mmaped a lot of pages
  with GFP_COMP flag.

  [Mon May 25 05:29:33 2015] page:ffffea0015414000 count:66 mapcount:1 mapping:          (null) index:0x0
  [Mon May 25 05:29:33 2015] flags: 0x20047580004000(head)
  [Mon May 25 05:29:33 2015] page dumped because: VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page))
  [Mon May 25 05:29:33 2015] ------------[ cut here ]------------
  [Mon May 25 05:29:33 2015] kernel BUG at mm/migrate.c:1661!
  [Mon May 25 05:29:33 2015] invalid opcode: 0000 [#1] SMP

In this case it was triggered by running tcpdump but it's not necessary
reproducible on all systems.

  sudo tcpdump -i bond0.100 'tcp port 4242' -c 100000000000 -w 4242.pcap

Compound pages cannot be migrated and it was not expected that such pages
be marked for NUMA balancing.  This did not take into account that drivers
such as net/packet/af_packet.c may insert compound pages into userspace
with vm_insert_page.  This patch tells the NUMA balancing protection
scanner to skip all VM_MIXEDMAP mappings which avoids the possibility that
compound pages are marked for migration.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Jovi Zhangwei <jovi@cloudflare.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched/fair.c~sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings
+++ a/kernel/sched/fair.c
@@ -2181,7 +2181,7 @@ void task_numa_work(struct callback_head
 	}
 	for (; vma; vma = vma->vm_next) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma)) {
+			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
 			continue;
 		}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

sched-numa-do-not-hint-for-numa-balancing-on-vm_mixedmap-mappings.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
mm-meminit-remove-mminit_verify_page_links.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

