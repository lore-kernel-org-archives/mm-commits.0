From: akpm@linux-foundation.org
Subject: + memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch added to -mm tree
Date: Wed, 07 Nov 2012 14:11:41 -0800
Message-ID: <20121107221142.9D3E95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:49966 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2KGWLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 17:11:45 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt11so138490wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 14:11:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: doc: describe memcg swappiness more precisely
has been added to the -mm tree.  Its filename is
     memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: doc: describe memcg swappiness more precisely

since fe35004f (mm: avoid swapping out with swappiness==0) memcg reclaim
stopped swapping out anon pages completely when 0 value is used.
Although this is somehow expected it hasn't been done for a really long
time this way and so it is probably better to be explicit about the
effect. Moreover global reclaim swapps out even when swappiness is 0
to prevent from OOM killer.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix
+++ a/Documentation/cgroups/memory.txt
@@ -530,6 +530,10 @@ Note:
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
 
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
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
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

