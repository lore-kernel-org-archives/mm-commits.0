From: akpm@linux-foundation.org
Subject: + bootmem-fix-wrong-call-parameter-for-free_bootmem.patch added to -mm tree
Date: Mon, 12 Nov 2012 15:24:02 -0800
Message-ID: <20121112232403.89D5520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40017 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2KLXYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 18:24:06 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so136938eei.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 15:24:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, benh@kernel.crashing.org, egtvedt@samfundet.no, fujita.tomonori@lab.ntt.co.jp, hannes@cmpxchg.org, hskinnemoen@gmail.com


The patch titled
     Subject: bootmem: fix wrong call parameter for free_bootmem()
has been added to the -mm tree.  Its filename is
     bootmem-fix-wrong-call-parameter-for-free_bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: bootmem: fix wrong call parameter for free_bootmem()

It is strange that alloc_bootmem() returns a virtual address and
free_bootmem() requires a physical address.  Anyway, free_bootmem()'s
first parameter should be physical address.

There are some call sites for free_bootmem() with virtual address.  So fix
them.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/celleb_pci.c |    4 ++--
 drivers/macintosh/smu.c                  |    2 +-
 lib/cpumask.c                            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/cell/celleb_pci.c~bootmem-fix-wrong-call-parameter-for-free_bootmem arch/powerpc/platforms/cell/celleb_pci.c
--- a/arch/powerpc/platforms/cell/celleb_pci.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
+++ a/arch/powerpc/platforms/cell/celleb_pci.c
@@ -401,11 +401,11 @@ error:
 	} else {
 		if (config && *config) {
 			size = 256;
-			free_bootmem((unsigned long)(*config), size);
+			free_bootmem(__pa(*config), size);
 		}
 		if (res && *res) {
 			size = sizeof(struct celleb_pci_resource);
-			free_bootmem((unsigned long)(*res), size);
+			free_bootmem(__pa(*res), size);
 		}
 	}
 
diff -puN drivers/macintosh/smu.c~bootmem-fix-wrong-call-parameter-for-free_bootmem drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
+++ a/drivers/macintosh/smu.c
@@ -565,7 +565,7 @@ fail_msg_node:
 fail_db_node:
 	of_node_put(smu->db_node);
 fail_bootmem:
-	free_bootmem((unsigned long)smu, sizeof(struct smu_device));
+	free_bootmem(__pa(smu), sizeof(struct smu_device));
 	smu = NULL;
 fail_np:
 	of_node_put(np);
diff -puN lib/cpumask.c~bootmem-fix-wrong-call-parameter-for-free_bootmem lib/cpumask.c
--- a/lib/cpumask.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
+++ a/lib/cpumask.c
@@ -161,6 +161,6 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	free_bootmem((unsigned long)mask, cpumask_size());
+	free_bootmem(__pa(mask), cpumask_size());
 }
 #endif
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-remove-page_address_pool-list-v2.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
avr32-kconfig-remove-have_arch_bootmem.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch

