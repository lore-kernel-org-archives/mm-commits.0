Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2286320C475
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925765; cv=none; b=RcdQD8L+FpSOyLJLu77eCkHt/QLYn0JGMSyBpHOjHZzPxr6qI/W5qo3eQx4lgP/OrzGPgsHYGszWEW1y/dhy+tpdbjBsY21bzCmE6vVt5+4XFV9HgSCrWQ3Trb7U3KtOh+UsgiP9jPfUttlM85wMiF8tQD3bfmFfDfT+VFpe8i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925765; c=relaxed/simple;
	bh=J61onnF6iDexay2Rqs504BHgjdxZU8OpaeHqUBm/jXg=;
	h=Date:To:From:Subject:Message-Id; b=RVlbHyfp9pErkb+YHstu6HntlaGxDnB12LbGVlSt5eBKSJbOPflrJiHcWLevC4zrRX/UWx4EoQm4PWg7cIJAlJGTwU4mba2TPCjPp6iYHHTU8U2wfmsSJTPbDH10sSiqEZi8kPGv77W2+eSEX+PLh0TD6OaPLx9bKV27MdXpzHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apG7am5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apG7am5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1F9C4CEC6;
	Wed,  6 Nov 2024 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730925764;
	bh=J61onnF6iDexay2Rqs504BHgjdxZU8OpaeHqUBm/jXg=;
	h=Date:To:From:Subject:From;
	b=apG7am5N2tzprWUeFv12q5v9FMnhoGc98OsTuYE6ISnqCgT0sstZgCTbfRcbw7xpn
	 uqOMbmT1Z33oyjt+vqXcQIa/0qddsIcXlD/UvYs/dx3vM1vSCjRNi7eDNztAaWVcJX
	 FL8XLaIgsDM+Quzdrh0MP/xpE6GEqlw9nz84HvMI=
Date: Wed, 06 Nov 2024 12:42:44 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,hailong.liu@oppo.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,ak@linux.intel.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-count-zeromap-read-and-set-for-swapout-and-swapin.patch removed from -mm tree
Message-Id: <20241106204244.9C1F9C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: count zeromap read and set for swapout and swapin
has been removed from the -mm tree.  Its filename was
     mm-count-zeromap-read-and-set-for-swapout-and-swapin.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: count zeromap read and set for swapout and swapin
Date: Wed, 6 Nov 2024 10:19:34 +1300

When the proportion of folios from the zeromap is small, missing their
accounting may not significantly impact profiling.  However, it's easy to
construct a scenario where this becomes an issue—for example, allocating
1 GB of memory, writing zeros from userspace, followed by MADV_PAGEOUT,
and then swapping it back in.  In this case, the swap-out and swap-in
counts seem to vanish into a black hole, potentially causing semantic
ambiguity.

On the other hand, Usama reported that zero-filled pages can exceed 10% in
workloads utilizing zswap, while Hailong noted that some app in Android
have more than 6% zero-filled pages.  Before commit 0ca0c24e3211 ("mm:
store zero pages to be swapped out in a bitmap"), both zswap and zRAM
implemented similar optimizations, leading to these optimized-out pages
being counted in either zswap or zRAM counters (with pswpin/pswpout also
increasing for zRAM).  With zeromap functioning prior to both zswap and
zRAM, userspace will no longer detect these swap-out and swap-in actions.

We have three ways to address this:

1. Introduce a dedicated counter specifically for the zeromap.

2. Use pswpin/pswpout accounting, treating the zero map as a standard
   backend.  This approach aligns with zRAM's current handling of
   same-page fills at the device level.  However, it would mean losing the
   optimized-out page counters previously available in zRAM and would not
   align with systems using zswap.  Additionally, as noted by Nhat Pham,
   pswpin/pswpout counters apply only to I/O done directly to the backend
   device.

3. Count zeromap pages under zswap, aligning with system behavior when
   zswap is enabled.  However, this would not be consistent with zRAM, nor
   would it align with systems lacking both zswap and zRAM.

Given the complications with options 2 and 3, this patch selects
option 1.

We can find these counters from /proc/vmstat (counters for the whole
system) and memcg's memory.stat (counters for the interested memcg).

For example:

$ grep -E 'swpin_zero|swpout_zero' /proc/vmstat
swpin_zero 1648
swpout_zero 33536

$ grep -E 'swpin_zero|swpout_zero' /sys/fs/cgroup/system.slice/memory.stat
swpin_zero 3905
swpout_zero 3985

This patch does not address any specific zeromap bug, but the missing
swpout and swpin counts for zero-filled pages can be highly confusing and
may mislead user-space agents that rely on changes in these counters as
indicators.  Therefore, we add a Fixes tag to encourage the inclusion of
this counter in any kernel versions with zeromap.

Link: https://lkml.kernel.org/r/20241105211934.5083-1-21cnbao@gmail.com
Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++++
 include/linux/vm_event_item.h           |    2 ++
 mm/memcontrol.c                         |    4 ++++
 mm/page_io.c                            |   16 ++++++++++++++++
 mm/vmstat.c                             |    2 ++
 5 files changed, 33 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-count-zeromap-read-and-set-for-swapout-and-swapin
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1599,6 +1599,15 @@ The following nested keys are defined.
 	  pglazyfreed (npn)
 		Amount of reclaimed lazyfree pages
 
+	  swpin_zero
+		Number of pages swapped into memory and filled with zero, where I/O
+		was optimized out because the page content was detected to be zero
+		during swapout.
+
+	  swpout_zero
+		Number of zero-filled pages swapped out with I/O skipped due to the
+		content being detected as zero.
+
 	  zswpin
 		Number of pages moved in to memory from zswap.
 
--- a/include/linux/vm_event_item.h~mm-count-zeromap-read-and-set-for-swapout-and-swapin
+++ a/include/linux/vm_event_item.h
@@ -134,6 +134,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_SWAP
 		SWAP_RA,
 		SWAP_RA_HIT,
+		SWPIN_ZERO,
+		SWPOUT_ZERO,
 #ifdef CONFIG_KSM
 		KSM_SWPIN_COPY,
 #endif
--- a/mm/memcontrol.c~mm-count-zeromap-read-and-set-for-swapout-and-swapin
+++ a/mm/memcontrol.c
@@ -431,6 +431,10 @@ static const unsigned int memcg_vm_event
 	PGDEACTIVATE,
 	PGLAZYFREE,
 	PGLAZYFREED,
+#ifdef CONFIG_SWAP
+	SWPIN_ZERO,
+	SWPOUT_ZERO,
+#endif
 #ifdef CONFIG_ZSWAP
 	ZSWPIN,
 	ZSWPOUT,
--- a/mm/page_io.c~mm-count-zeromap-read-and-set-for-swapout-and-swapin
+++ a/mm/page_io.c
@@ -204,7 +204,9 @@ static bool is_folio_zero_filled(struct
 
 static void swap_zeromap_folio_set(struct folio *folio)
 {
+	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	int nr_pages = folio_nr_pages(folio);
 	swp_entry_t entry;
 	unsigned int i;
 
@@ -212,6 +214,12 @@ static void swap_zeromap_folio_set(struc
 		entry = page_swap_entry(folio_page(folio, i));
 		set_bit(swp_offset(entry), sis->zeromap);
 	}
+
+	count_vm_events(SWPOUT_ZERO, nr_pages);
+	if (objcg) {
+		count_objcg_events(objcg, SWPOUT_ZERO, nr_pages);
+		obj_cgroup_put(objcg);
+	}
 }
 
 static void swap_zeromap_folio_clear(struct folio *folio)
@@ -503,6 +511,7 @@ static void sio_read_complete(struct kio
 static bool swap_read_folio_zeromap(struct folio *folio)
 {
 	int nr_pages = folio_nr_pages(folio);
+	struct obj_cgroup *objcg;
 	bool is_zeromap;
 
 	/*
@@ -517,6 +526,13 @@ static bool swap_read_folio_zeromap(stru
 	if (!is_zeromap)
 		return false;
 
+	objcg = get_obj_cgroup_from_folio(folio);
+	count_vm_events(SWPIN_ZERO, nr_pages);
+	if (objcg) {
+		count_objcg_events(objcg, SWPIN_ZERO, nr_pages);
+		obj_cgroup_put(objcg);
+	}
+
 	folio_zero_range(folio, 0, folio_size(folio));
 	folio_mark_uptodate(folio);
 	return true;
--- a/mm/vmstat.c~mm-count-zeromap-read-and-set-for-swapout-and-swapin
+++ a/mm/vmstat.c
@@ -1415,6 +1415,8 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_SWAP
 	"swap_ra",
 	"swap_ra_hit",
+	"swpin_zero",
+	"swpout_zero",
 #ifdef CONFIG_KSM
 	"ksm_swpin_copy",
 #endif
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-add-per-order-mthp-swpin-counters.patch
mm-add-per-order-mthp-swpin-counters-v2.patch

