Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1FA36EAB9
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027671; cv=none; b=M6jw0Pe/v5pFDhZyyQYboZw4UiXA7r4pLFRHBOwQAS6E4mdHXu2qTKxA5pBAKcoFzkDHsI/pV7Oyic0RGBNY3UHoXKMzyJzBl1DV4T7pkWkIK3ErXzSMCFYnVo8Bu/w8oGqah3VmUk1sGs8TZ014OCMb47tGgGuLc7xJR9p/moc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027671; c=relaxed/simple;
	bh=I5I2Rf/zltRPI0IInEIRnB8QEkL16B6o1hLHDu1qx/4=;
	h=Date:To:From:Subject:Message-Id; b=hKUEO3J34Hh+x3i2LAihfO5DXnOI5RgjToRpUud7T5HHKD7EvlHNgbhxlCX5wyXgcf7DHu9ogg1GVZZcFF2HbEpJK/5iLh6QyqQdcMqAOvSz9iWfpnpTme7MmYZhkb/+PUYD+x0gxlvttEh85ps7IChYHDZFGIhNLBJR+k3clQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0TXv/NJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0TXv/NJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1A81F00893;
	Fri, 29 May 2026 04:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027670;
	bh=T4Div/Q5AKLwNbF1UuEi0Rb1OJuur+mStBWMrdJlY0I=;
	h=Date:To:From:Subject;
	b=0TXv/NJRtv2N4ab7KnWN8Dz94+3bz3VxdgNyP6ReGbFRBLHc4lV9okCC8dgqLkozY
	 FTQNOQ2+Ia5SW8Yg7qT7qX0anxquGpTHM9qFKCmfSqMHaaPem2H8QdYxNiEw9PZnHE
	 SvfysOw8IWOFoJNWdt6n9cw/BOfKmSCRC1o7q0CM=
Date: Thu, 28 May 2026 21:07:50 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,bsegall@google.com,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-add-__gfp_skip_kasan-support.patch removed from -mm tree
Message-Id: <20260529040750.6B1A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: add __GFP_SKIP_KASAN support
has been removed from the -mm tree.  Its filename was
     vmalloc-add-__gfp_skip_kasan-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: vmalloc: add __GFP_SKIP_KASAN support
Date: Wed, 29 Apr 2026 15:57:02 +0530

Patch series "kasan: hw_tags: Disable tagging for stack and page-tables",
v4.

Stacks and page tables are always accessed with the match-all tag, so
assigning a new random tag every time at allocation and setting invalid
tag at deallocation time, just adds overhead without improving the
detection.

With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
(match-all tag) is stored in the page flags while keeping the poison tag
in the hardware.  The benefit of it is that 256 tag setting instruction
per 4 kB page aren't needed at allocation and deallocation time.

Thus match-all pointers still work, while non-match tags (other than
poison tag) still fault.

__GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
unchanged.

Benchmark:
The benchmark has two modes. In thread mode, the child process forks
and creates N threads. In pgtable mode, the parent maps and faults a
specified memory size and then forks repeatedly with children exiting
immediately.

Thread benchmark:
2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)

The pgtable samples:
- 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)


This patch (of 3):

For allocations that will be accessed only with match-all pointers (e.g.,
kernel stacks), setting tags is wasted work.  If the caller already set
__GFP_SKIP_KASAN, skip tag setting of vmalloc pages.

Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc APIs. 
So it wasn't being checked.  Now its being checked and acted upon.  Other
KASAN modes are unchanged because __GFP_SKIP_KASAN is ignored for them in
the page allocator, and in vmalloc too we ignore this flag for them.

This is a preparatory patch for optimizing kernel stack allocations.

Link: https://lore.kernel.org/20260429102704.680174-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260429102704.680174-2-dev.jain@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    6 +++---
 mm/vmalloc.c              |   13 +++++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/gfp_types.h~vmalloc-add-__gfp_skip_kasan-support
+++ a/include/linux/gfp_types.h
@@ -281,9 +281,9 @@ enum {
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
- * kasan_unpoison_vmalloc instead. For userspace pages, results in
- * poisoning being skipped as well, see should_skip_kasan_poison for
- * details. Only effective in HW_TAGS mode.
+ * kasan_unpoison_vmalloc instead. If passed to vmalloc, kasan_unpoison_vmalloc
+ * is skipped too. For userspace pages, results in poisoning being skipped as
+ * well, see should_skip_kasan_poison for details. Only effective in HW_TAGS mode.
  */
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
--- a/mm/vmalloc.c~vmalloc-add-__gfp_skip_kasan-support
+++ a/mm/vmalloc.c
@@ -3933,7 +3933,7 @@ fail:
 				__GFP_NOFAIL | __GFP_ZERO |\
 				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
-				GFP_USER | __GFP_NOLOCKDEP)
+				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
 
 static gfp_t vmalloc_fix_flags(gfp_t flags)
 {
@@ -3974,6 +3974,9 @@ static gfp_t vmalloc_fix_flags(gfp_t fla
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
+ * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
+ * (when prot=%PAGE_KERNEL).
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -3987,6 +3990,7 @@ void *__vmalloc_node_range_noprof(unsign
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
 	unsigned long original_align = align;
 	unsigned int shift = PAGE_SHIFT;
+	bool skip_vmalloc_kasan = kasan_hw_tags_enabled() && (gfp_mask & __GFP_SKIP_KASAN);
 
 	if (WARN_ON_ONCE(!size))
 		return NULL;
@@ -4017,7 +4021,7 @@ void *__vmalloc_node_range_noprof(unsign
 again:
 	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
-				  gfp_mask, caller);
+				  gfp_mask & ~__GFP_SKIP_KASAN, caller);
 	if (!area) {
 		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
@@ -4035,7 +4039,7 @@ again:
 	 * kasan_unpoison_vmalloc().
 	 */
 	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		if (kasan_hw_tags_enabled()) {
+		if (kasan_hw_tags_enabled() && !skip_vmalloc_kasan) {
 			/*
 			 * Modify protection bits to allow tagging.
 			 * This must be done before mapping.
@@ -4072,7 +4076,8 @@ again:
 	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
+	if (!skip_vmalloc_kasan)
+		area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
_

Patches currently in -mm which might be from usama.anjum@arm.com are


