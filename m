Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027522236E0
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783381685; cv=none; b=OBzL1r7kLvAuDS6Et7Mg+98Ee38spjfYXaJ+Q/LV+WV2G1MpMVgE9KXTV/1jGjKY5mIHnRIWOEnSWxr6GKs7gm1pzPT6D5a7xHJyJ64X2eDga4iUf7h7LPMcf3+z2AzrcmSwYlmKCDYyrcrURexF/To5ouI2l1HI3sexrmqWU6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783381685; c=relaxed/simple;
	bh=ZjwQrm8S6Y1DcehIKBrMeOr//BvqTGVLx0C3sarobgQ=;
	h=Date:To:From:Subject:Message-Id; b=OU1HWJmCWkS/S14ojSsjVzvl3oAS1Wnss2kqjyUDBgMMTY77dsc5Bdk5rO9cikCkOfm6MnafIA3mUsGD8XYIUAvAow7KAW3u7doVSnDwkke2U1/WERjmQEGoaJKvUyujyn4r7RJ9/DMaJVduvIT/8frxxAYSQVdWyIpbF2wqL5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LjNe9TkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LjNe9TkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BA91F000E9;
	Mon,  6 Jul 2026 23:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783381683;
	bh=vezXjbU8vwv/ngEHhlCKVqaVI/PViC1tjaX/eprXpNU=;
	h=Date:To:From:Subject;
	b=LjNe9TkYr4Y8etQ/S1Iybbj7Kt9kq5e9iVHwsWHWlRzijhhnMt1Sk38ZZJokGr99X
	 O8eKygr+wGNViR34ohTkKAMnIZTgQ/h6XJBeCwjeW7/l7fo7e3+bafqPjoh5qQO/l+
	 zqZ55BXpYvw+3lSQpEB3KTc/IFX/4dSJg0mQUfSM=
Date: Mon, 06 Jul 2026 16:48:02 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch added to mm-new branch
Message-Id: <20260706234803.63BA91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: optimize rmap_walk_ksm by passing a suitablepage index
has been added to the -mm mm-new branch.  Its filename is
     ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: optimize rmap_walk_ksm by passing a suitablepage index
Date: Fri, 3 Jul 2026 16:25:10 +0800 (CST)

User impact / Why this matters to Linux users
=============================================
When a system runs with KSM enabled and memory becomes tight, KSM pages
may be swapped out or migrated. The kernel then performs a reverse map
walk by rmap_walk_ksm to locate all page table entries that reference
these pages. If A large number of unrelated VMAs can attach to a single
anon_vma related with this KSM page, then rmap_walk might be severe
performance bottleneck.  In our embedded test environment, we observed
~20,000 VMAs sharing one anon_vma without any fork â€“ purely from VMA
splitsï¼Œ which cause 200~700ms duration of rmap_walk_ksm.

When one of those VMAs mapped a KSM page, then this KSM page's rmapping
will become bottleneck with hold its anon_vma lock for a long time. The
anon_vma lock is not only used by KSM; it is a core lock protecting the
VMA interval tree and is acquired by many critical memory operations:

  â€' Page faults: do_anonymous_page(), do_wp_page() (during COW)
  â€' Memory reclaim: try_to_unmap()
  â€' Page migration & compaction: migrate_pages(), compact_zone()
  â€' mlock / munlock: mlock_fixup()
  â€' Process exit: exit_mmap() (tearing down VMAs)
  â€' Cgroup memory accounting: mem_cgroup_move_charge()

If one thread holds the anon_vma lock for hundreds of milliseconds
because of an inefficient KSM rmap walk, any other thread that
tries to acquire the same lock (e.g., an application taking a page
fault, kswapd reclaiming pages, or a migration thread) will block.
This leads to stalled application threads, increased latency
spikes, and in extreme cases container timeouts or watchdog
triggers.

This patch reduces the worst-case anon_vma lock hold time during
ksm_rmap_walk from >500 ms to <1 ms, thereby almost eliminating
this source of lock contention and improving system responsiveness
under memory pressure.

Real-world examples:
====================
 - JVM / Go runtime: These use mmap for heap regions and later call
mprotect(PROT_NONE) for garbage collection barriers or guard pages,
splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers
or anonymous mappings are managed with madvise(MADV_DONTNEED) to
release specific pages, which also splits VMAs.

Root Cause
==========
Through local debugging trace analysis, we found that most of the
latency of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach,
leading to an excessively long hold time on the anon_vma lock (even
reaching 500ms or more), which in turn causes upper-layer applications
(waiting for the anon_vma lock) to be blocked for extended periods.

Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a
large number of loop iterations are ineffective. This inefficiency
arises because the start page index and the end page index parameters
passed to anon_vma_interval_tree_foreach span the entire address space
from 0 to ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
We cannot rely solely on anon_vma to locate all PTEs mapping this page
but also need to have the original page's linear_page_index. Since the
implementation of anon_vma_interval_tree_foreach â€” it essentially
iterates to find a suitable VMA such that the provided page index
falls within the candidate's vm_pgoff range.

vm_pgoff <= original linear page offset <= (vm_pgoff + vma_pages(v) - 1)

Fortunately, an earlier commit introduced the linear_page_index to struct
ksm_rmap_item, allowing for optimizing the RMAP walk.

Test results
============
A rmap testbench can be obtained with two Out-Of-Tree patches at [1][2].
After applying the OOT patches and building rmap_benchmark from:
tools/testing/rmap/rmap_benchmark.c, we can start the performance test.

The testing result in QEMU is shown as follows:

KSM rmapping	Maximum duration		Average duration

Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)

The benchmark numbers are realistic, since we observed ~20,000 VMAs
sharing one anon_vma on a production system running a Java application
with KSM enabled. The lock hold time before the patch was measured at
228â€¯ms (max) during rmap walks triggered by memory compaction and page
migration. The benchmark reproduces that VMA count and lockâ€‘hold
behavior in a controlled environment.

Link: https://lore.kernel.org/20260703162510242nxmjbcLy5ccp1dbZSK3EU@zte.com.cn
Link: https://lore.kernel.org/all/202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn [1]
Link: https://lore.kernel.org/all/20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn/ [2]
Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index
+++ a/mm/ksm.c
@@ -3208,6 +3208,7 @@ again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const unsigned long index = rmap_item->linear_page_index;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3221,8 +3222,18 @@ again:
 			anon_vma_lock_read(anon_vma);
 		}
 
+		/*
+		 * Currently, KSM folios are always small folios, so it's
+		 * sufficient to search for a single page. We can simply use
+		 * the linear_page_index of the original de-duplicate
+		 * anonymous page that we remembered in the rmap_item while
+		 * de-duplicating. Note that mremap() always de-duplicates KSM
+		 * folios: so if there was mremap() in our parent or our child,
+		 * we wouldn't have the KSM folio mapped in these processes
+		 * anymore.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       index, index) {
 
 			cond_resched();
 			vma = vmac->vma;
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch

