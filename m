Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641247;
	b=dTH2LgrBSjlTRTiKNnS8qx2AfktI970Eak0xUb9+d/pxIk2TgtZveXdfesW8KqNc+khT
	 TxWkInzp/Gb6GSu0nC5h51Flv99DjkROJNIL53CKv5MoaQ89s+RE/lCJN2z83vwoazcPO
	 9CJeWbVxhkjuZqaB4LzKnCJhKe1wKHm3+L30btuDajHJZdWoFLLrDAjDBrqjbmOrtsyBi
	 mo7oMdUwizjeKV8FKfvDhXZGhytnXbTqiHHl+f6xWAkPdYhY2c8xNx4S6tFtRHML1u3IB
	 +2Jcm1Igf95ROGq+wY3ABjmzKyeYJ8bOTF5K0AeB6en7Xv+9qx7Ycs2VaSrU0Lbi2LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641247;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uZpNgPXOVoRccifJpkzYv5udRdZKTjnypRgmMAsu1/o=;
	b=TbxNvfcTbgTA6DgBKbiqtADbyp+ktfoiCvUfnlvHKFe45oYF/melt/8uRPqKrm9EbpYX
	 zquL2CsxF9JTLu/PDpOrIq2b+5iJQOG2MPSZ5ZBbgjECAY/CAolh9iQ3GvpOUtvyeH9vN
	 S7sQDJ578MqSYTN33+t+CxkZSpcVUz86qN6q62MPblXiQnrcT9nYr1hUsiMz5SaifzQF8
	 VpIYX3n4tpg/WYj92ab0PPEY2Q8+azsA12637vdN3cWBXZYhKar9ZFS2uZ+7yLP5DN4I0
	 F6gEdXIPvBzxqH7txWCpxlJHO4whYM34ep4c2J12LkeGpGRNTxiyaKtDUUZEUorWBZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QqJZtHgK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4833606B0C9
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QqJZtHgK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6171F00A16;
	Mon,  2 Nov 2026 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793641246;
	bh=uZpNgPXOVoRccifJpkzYv5udRdZKTjnypRgmMAsu1/o=;
	h=Date:To:From:Subject;
	b=QqJZtHgK2aImkrR2s9pEekc4dqVaIMyJGOMOmlstYyiAKstpwh32MoKBdCGj8bY2+
	 6uoNn4q00jbgDLZm836a62lKr+MmTCbWSNug6LkjOwUSfReSZNnlva261ZP/P6YIvQ
	 t6vipqU/HW5siMNcURSssJq3jPH+yIiSw6wlLRRQ=
Date: Mon, 02 Nov 2026 09:40:44 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,yosry@kernel.org,
	vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,rppt@kernel.org,nphamcs@gmail.com,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,
	hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,
	chengming.zhou@linux.dev,baoquan.he@linux.dev,baohua@kernel.org,
	alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bypass-swap-readahead-for-zswap.patch added to mm-new branch
Message-Id: <20261102174046.5C6171F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: bypass swap readahead for zswap
has been added to the -mm mm-new branch.  Its filename is
     mm-bypass-swap-readahead-for-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bypass-swap-readahead-for-zswap.patch

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
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm: bypass swap readahead for zswap
Date: Mon,  2 Nov 2026 15:48:22 +0100

Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
device") made SWP_SYNCHRONOUS_IO devices (e.g.  zram) skip swap readahead.

zswap is the same kind of in-memory, synchronous backend as zram, not a
swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
swapin_readahead().

Here are the results from bypassing readahead for zswap too: it was
measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
off, on Sapphire Rapids and 3 iterations.

  768M memcg (sustained swap thrash):
    metric                 mm-new    + bypass    delta
    build time (s)          405.0       341.7    -15.6%
    zswap-in (GB)            79.5        53.0     -33%
    zswap-out (GB)          144.8       115.6     -20%
    swap readahead (pages)  6.79M       0.45M     -93%
    swap_ra hit (%)          72.1        89.9     +18pp

  1G memcg (light pressure, build not memory-bound):
    metric                 mm-new    + bypass    delta
    build time (s)          177.7       176.0    ~same (no regression)
    zswap-in (GB)            10.2         7.5     -26%
    zswap-out (GB)           27.7        25.1      -9%
    swap readahead (pages)  1.07M       0.08M     -93%
    swap_ra hit (%)          68.6        87.2     +19pp

Similar gains were observed on an AMD EPYC 7D13 host.

All the results above use the default page-cluster=3 and
vma_ra_enabled=true.  Setting page-cluster to 0 gives the same gain on a
zswap-only system, but page-cluster is global: it also disables readahead
for the asynchronous swap backends that other tenants of the same host may
use.

The gain is from no longer prefetching pages that are pointless for an
in-memory backend: readahead inflates anon residency and thrashes the page
cache (file pages get evicted and re-read), lengthens each fault by
synchronously (de)compressing a cluster of neighbours, and adds
compression traffic when those extra pages are reclaimed.

Bypassing swap readahead for zswap therefore makes sense.

Link: https://lore.kernel.org/20261102144835.304017-1-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: <ryncsn@gmail.com>
Cc: <chrisl@kernel.org>
---

 include/linux/zswap.h |    6 ++++++
 mm/memory.c           |    4 ++--
 mm/swap.h             |   25 +++++++++++++++++++++++++
 mm/zswap.c            |    5 ++++-
 4 files changed, 37 insertions(+), 3 deletions(-)

--- a/include/linux/zswap.h~mm-bypass-swap-readahead-for-zswap
+++ a/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruv
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_is_present(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(v
 	return true;
 }
 
+static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
--- a/mm/memory.c~mm-bypass-swap-readahead-for-zswap
+++ a/mm/memory.c
@@ -5034,8 +5034,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
-		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
+		if (swap_entry_synchronous(si, entry))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
--- a/mm/swap.h~mm-bypass-swap-readahead-for-zswap
+++ a/mm/swap.h
@@ -94,6 +94,7 @@ static inline int mem_cgroup_swappiness(
 
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
+#include <linux/zswap.h> /* for zswap_is_present */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 static inline unsigned int swp_cluster_offset(swp_entry_t entry)
@@ -336,6 +337,24 @@ struct folio *swapin_sync(swp_entry_t en
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
+/**
+ * swap_entry_synchronous - check if @entry is read synchronously
+ * @si: the swap device of @entry
+ * @entry: the swap entry
+ *
+ * SWP_SYNCHRONOUS_IO devices and zswap complete a read in the faulting
+ * context, so swap readahead has no asynchronous I/O to overlap.
+ *
+ * Context: The caller must hold a reference on @si. The answer is a hint: the
+ * entry can be written back from zswap or freed concurrently.
+ */
+static inline bool swap_entry_synchronous(struct swap_info_struct *si,
+					  swp_entry_t entry)
+{
+	return data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
+	       zswap_is_present(entry, 1);
+}
+
 #else /* CONFIG_SWAP */
 
 static inline struct swap_cluster_info *swap_cluster_get_and_lock(
@@ -423,6 +442,12 @@ static inline void swap_update_readahead
 {
 }
 
+static inline bool swap_entry_synchronous(struct swap_info_struct *si,
+					  swp_entry_t entry)
+{
+	return false;
+}
+
 static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	return 0;
--- a/mm/zswap.c~mm-bypass-swap-readahead-for-zswap
+++ a/mm/zswap.c
@@ -1695,12 +1695,15 @@ check_old:
  * change under it.
  * Return: true if at least one slot in the range is in zswap.
  */
-static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+bool zswap_is_present(swp_entry_t entry, unsigned int nr)
 {
 	pgoff_t offset = swp_offset(entry);
 	struct xarray *tree = swap_zswap_tree(entry);
 	unsigned long index = offset;
 
+	if (zswap_never_enabled() || xa_empty(tree))
+		return false;
+
 	/*
 	 * A pinned range is at most SWAPFILE_CLUSTER slots and is aligned to
 	 * its own size, so one tree covers all of it and a single lookup is
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch
mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch
mm-bypass-swap-readahead-for-zswap.patch

