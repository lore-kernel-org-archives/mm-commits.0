Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777179;
	b=X/Dk8aJtwq2Avs06O6R9sGiNjO7VutAkyUCiPWuGVY9ZeoCjkF0srkCxteQvN1KNQqh5
	 x8zrYRx20FAVvq1tmL2e+/Mqyq/uyJDNVaZP4T3tZkOZ1cZ3MoNmeyu1sUrB+DMCUpIbt
	 Vemcr1+e0/FJr5l7YgdT2Q1DewJPFoj3eLUuVYVser+8hfY6fJytFXR+mcpdFyXyVLZyy
	 2Zbvzo0aw3fcY7gB8noqX0AfFffJBpuNC2++9KKiGW+Hm+Iy0OXZ6Tza45cNjQ1iFK9PV
	 D9LyvQLEnLyg2oqxbY53FOfbZlJP3SuzntkDIzXE3dUy/SFJg9DWz/+7FEoCg25qlow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777179;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=odPVEGJNI068vOlDDlXNPqYz0NLXdEZnh3rgurqIlvs=;
	b=pri2Ehx5IVRQY+peAq3th4JjHVPeIPh2Ud5hx4YZpX8V80vHkckYZ4HLs6NLnCX2akHh
	 UJDvy0ke12ny741YOSatOoyXzkMqrWevNJjPxDBgcRLI3VPHGbTk51Hz7KrGxsYmOSiCE
	 CI0TURqHEbQEpLc3WHGtcs38yHskHCsgIFV34cz9wJzPiPW01bAJpK8YT3n0uZLuTIJyd
	 r/KOdNcIqWincW00mdCUVuQuEI8G9/efkOMkIaN9u9BJiYvP/qO2xd5EfMzucsq5DtThJ
	 HWufYBMQZklvsBHA5g7qdRTPI72M+ka1f0iZhVSu804uWUdDTs8cWj8h4TM57QFG+VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t89g3hbC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB4606A335;
	Wed,  4 Nov 2026 07:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t89g3hbC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325BD1F000C1;
	Wed,  4 Nov 2026 07:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793777178;
	bh=odPVEGJNI068vOlDDlXNPqYz0NLXdEZnh3rgurqIlvs=;
	h=Date:To:From:Subject;
	b=t89g3hbCwfpvNJaLL7DpZKZf5FcM5JEUHOQDYbZMXdsZlx0EilYxqjO98gCwCF1Fm
	 1O2LuvuOpjqn7apBzPQ9QFs/Q+UUiHpsZ9jQ80BKQq63oCPaNZW4tzXTYhnlHRCDL5
	 PYwnoTj2l0IUbI85CygX5JD3+JQZpZbNGmWeAzig=
Date: Tue, 03 Nov 2026 23:26:17 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,yosry@kernel.org,
	vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,
	stable@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,
	rppt@kernel.org,nphamcs@gmail.com,neil@brown.name,mt4022@columbia.edu,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,
	josef@toxicpanda.com,hch@lst.de,hannes@cmpxchg.org,hanchuanhua@oppo.com,
	david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,
	baoquan.he@linux.dev,baohua@kernel.org,mason@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-large-swap-in-across-swap-file-extents.patch added to mm-new branch
Message-Id: <20261104072618.325BD1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, swap: fix large swap-in across swap file extents
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-fix-large-swap-in-across-swap-file-extents.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-large-swap-in-across-swap-file-extents.patch

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
From: Chris Mason <mason@kernel.org>
Subject: mm, swap: fix large swap-in across swap file extents
Date: Wed, 04 Nov 2026 00:18:15 +0800

A page fault can give an unprivileged process blocks of other users'
files instead of its own swapped-out data. This affects systems with a
swap file on a synchronous block device, such as brd or zram. For an
anonymous mapping it also takes a huge page size below the PMD size
(mTHP), such as 64 KiB, that is enabled for anonymous memory.

A swap area is divided into slots of one page each. A swap file is a
regular file, so adjacent swap slots can lie in two extents, far apart
on disk. A folio is read from swap with a single bio that starts at the
sector of the folio's first slot. So all slots of a large folio must be
contiguous on disk.

The swap allocator knows this: it only hands out a run of slots for a
large folio if the swap area is a block device (SWP_BLKDEV).

The swap-in path does not. On a synchronous device (SWP_SYNCHRONOUS_IO),
one that always completes I/O in the submitter's context, do_swap_page()
can read several swapped-out pages as one large folio (a large swap-in).
thp_swapin_suitable_orders() makes that decision, and looks only at the
swap offsets (the slot numbers) in the page table.

Pages that were swapped out one at a time can end up in consecutive,
aligned slots, and are then read as one large folio. If the extent of
the first slot ends inside that folio, the rest of the folio is filled
from the blocks that follow the extent on disk. These blocks can belong
to other files.

Reproduced with a fragmented swap file on brd and 64 KiB folios enabled.
After single pages were swapped out, a fault returned blocks of a
root-owned file with mode 0600.

Fix this by allowing a large swap-in only when SWP_BLKDEV is set.

Known gaps:
- A swap file on zram, brd, pmem or btt is now read one page at a time,
  even where its slots lie in one extent. Its swpin counters in
  /sys/kernel/mm/transparent_hugepage/hugepages-*/stats stay at 0.
- There could be devices with SWP_SYNCHRONOUS_IO but not
  SWP_BLKDEV, so the new check would have to let that device pass.

[kasong@tencent.com: simplify the note about the unmerged xswap patch]
Link: https://lore.kernel.org/20261104-swap-fixes-v2-2-204be064be5b@tencent.com
Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-swap-fix-large-swap-in-across-swap-file-extents
+++ a/mm/memory.c
@@ -4830,7 +4830,8 @@ static inline unsigned long thp_swap_sui
 	return orders;
 }
 
-static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
+static unsigned long thp_swapin_suitable_orders(struct swap_info_struct *si,
+						struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long orders;
@@ -4855,6 +4856,14 @@ static unsigned long thp_swapin_suitable
 	if (!zswap_never_enabled())
 		return 0;
 
+	/*
+	 * Neighbouring slots of a swap file can lie in two extents, and a folio
+	 * is read with one bio. The flag is set in swapon() and stays, so the
+	 * race is benign.
+	 */
+	if (!data_race(si->flags & SWP_BLKDEV))
+		return 0;
+
 	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
@@ -4891,7 +4900,8 @@ static unsigned long thp_swapin_suitable
 	return orders;
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
+static unsigned long thp_swapin_suitable_orders(struct swap_info_struct *si,
+						struct vm_fault *vmf)
 {
 	return 0;
 }
@@ -5037,7 +5047,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
 		if (swap_entry_synchronous(si, entry))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
-					    thp_swapin_suitable_orders(vmf) | BIT(0),
+					    thp_swapin_suitable_orders(si, vmf) | BIT(0),
 					    vmf, NULL, 0);
 		else
 			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch

