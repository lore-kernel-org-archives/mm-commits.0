From: akpm@linux-foundation.org
Subject: + mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch added to -mm tree
Date: Mon, 12 Nov 2012 16:13:09 -0800
Message-ID: <20121113001310.40691200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34277 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2KMANN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 19:13:13 -0500
Received: by mail-fa0-f74.google.com with SMTP id w1so10240fad.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 16:13:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@linux.intel.com, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix fix
has been added to the -mm tree.  Its filename is
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix fix

On Fri, 9 Nov 2012, Randy Dunlap wrote:

> on x86_64:
>
> In file included from mm/mprotect.c:13:0:
> include/linux/shm.h:57:20: error: redefinition of 'do_shmat'
> include/linux/shm.h:57:20: note: previous definition of 'do_shmat' was here
> include/linux/shm.h:63:19: error: redefinition of 'is_file_shm_hugepages'
> include/linux/shm.h:63:19: note: previous definition of 'is_file_shm_hugepages' was here
> include/linux/shm.h:67:20: error: redefinition of 'exit_shm'
> include/linux/shm.h:67:20: note: previous definition of 'exit_shm' was here
>
> In file included from include/linux/hugetlb.h:16:0,
>                  from mm/mmap.c:23:
> include/linux/shm.h:57:20: error: redefinition of 'do_shmat'
> include/linux/shm.h:57:20: note: previous definition of 'do_shmat' was here
> include/linux/shm.h:63:19: error: redefinition of 'is_file_shm_hugepages'
> include/linux/shm.h:63:19: note: previous definition of 'is_file_shm_hugepages' was here
> include/linux/shm.h:67:20: error: redefinition of 'exit_shm'
> include/linux/shm.h:67:20: note: previous definition of 'exit_shm' was here
> make[2]: *** [mm/mprotect.o] Error 1
>

This is an elusive one, I couldn't reproduce it with master.  This appears
to only happen on the akpm branch, correct?

It happens because of e37c64a9751a ("mm: support more pagesizes for
MAP_HUGETLB/SHM_HUGETLB") adds a spurious "#endif" to include/linux/shm.h
and gets reverted in master by 359078d82a20 ("Revert "mm: support more
pagesizes for MAP_HUGETLB/SHM_HUGETLB"") because of another build failure
that Stephen reports on November 8:

mm/mmap.c: In function 'SYSC_mmap_pgoff':
mm/mmap.c:1271:15: error: 'MAP_HUGE_SHIFT' undeclared (first use in this function)
mm/mmap.c:1271:15: note: each undeclared identifier is reported only once for each function it appears in
mm/mmap.c:1271:33: error: 'MAP_HUGE_MASK' undeclared (first use in this function)

I think the best bet would be to merge the following in -mm and then let
Stephen revert it in master again if his build error persists for powerpc:

mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix

Fix the build:

include/linux/shm.h:57:20: error: redefinition of 'do_shmat'
include/linux/shm.h:57:20: note: previous definition of 'do_shmat' was here
include/linux/shm.h:63:19: error: redefinition of 'is_file_shm_hugepages'
include/linux/shm.h:63:19: note: previous definition of 'is_file_shm_hugepages' was here
include/linux/shm.h:67:20: error: redefinition of 'exit_shm'
include/linux/shm.h:67:20: note: previous definition of 'exit_shm' was here

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shm.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/shm.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix include/linux/shm.h
--- a/include/linux/shm.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix
+++ a/include/linux/shm.h
@@ -23,8 +23,6 @@ struct shmid_kernel /* private to the ke
 	struct task_struct	*shm_creator;
 };
 
-#endif
-
 /* shm_mode upper byte flags */
 #define	SHM_DEST	01000	/* segment will be destroyed on last detach */
 #define SHM_LOCKED      02000   /* segment will not be swapped */
@@ -46,8 +44,6 @@ struct shmid_kernel /* private to the ke
 #define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
 #define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
 
-#ifdef __KERNEL__
-
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-fix-build-warning-for-uninitialized-value.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch
irq-tsk-comm-is-an-array.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
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
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch
mm-mempolicy-remove-duplicate-code.patch
mm-cleanup-register_node.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch

