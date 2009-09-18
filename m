From: akpm@linux-foundation.org
Subject: + x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch added to -mm tree
Date: Fri, 18 Sep 2009 14:50:08 -0700
Message-ID: <200909182150.n8ILo8As030900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZIRVvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 17:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, jbarnes@virtuousgeek.org, sjayaraman@suse.de, yinghai@kernel.org


The patch titled
     x86: default pcibus cpumask to all cpus if it lacks affinity
has been added to the -mm tree.  Its filename is
     x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch

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
Subject: x86: default pcibus cpumask to all cpus if it lacks affinity
From: David Rientjes <rientjes@google.com>

The early initialization of the pci bus to node mapping leaves all busses
with a node id of -1 if it lacks memory affinity.  Thus, cpumask_of_pcibus
must return all online cpus for such busses.

Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pci.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pci.h~x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h~x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity
+++ a/arch/x86/include/asm/pci.h
@@ -143,7 +143,11 @@ static inline int __pcibus_to_node(const
 static inline const struct cpumask *
 cpumask_of_pcibus(const struct pci_bus *bus)
 {
-	return cpumask_of_node(__pcibus_to_node(bus));
+	int node;
+
+	node = __pcibus_to_node(bus);
+	return (node == -1) ? cpu_online_mask :
+			      cpumask_of_node(node);
 }
 #endif
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
linux-next.patch
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
hugetlb-add-map_hugetlb-example.patch
flex_array-add-flex_array_clear-function.patch
flex_array-poison-free-elements.patch
flex_array-add-flex_array_shrink-function.patch
flex_array-introduce-define_flex_array.patch
flex_array-add-missing-kerneldoc-annotations.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
walk-system-ram-range-fix-2.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

