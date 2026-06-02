Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977DC3C4167
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439203; cv=none; b=rAKLjYdcKlmVQojujK27ETC22GWG9Sl4xwEvlacwfMOpSxNelJ5ZB7ggmxEvQgwtV49iyyM2byAIF3OwwqvIR6Ym4JYvn6BTJmgJvKZqRtWBCJiLrFLmhZCOH/Nz4LH/Vu5rHc2IR9FAmVB/ONvuZ2WYgwRzOvsTNJGeO/Ht8pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439203; c=relaxed/simple;
	bh=lwvBXAPMpl5rF3+YdWCGfcnRO0LzxOgy9Z9UpJ4ZSdY=;
	h=Date:To:From:Subject:Message-Id; b=iIWYdhKVGOQ/pslH7dKOKG1qHk/azz1PILMq/7OCjBlpTX+lz6K0fLR7MpjIL8vNwN9WFTbQT5B6bgzCZmTH4sCBXFfQBhHdyXtSLSD1Ks0u6UjXi9foo0hdHGqm4ji7C0nt2VqmDrKfVdkOyoCUZme1Wxhzkt0lwSCQJkO1VzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQEiPJau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQEiPJau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD991F00898;
	Tue,  2 Jun 2026 22:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439202;
	bh=dVDm5GGajrcbdgUtofJDLbHRYos7b6cme1ifMallVs0=;
	h=Date:To:From:Subject;
	b=NQEiPJauEGy87AWqPoqf+8Vp0WCCtKVzy7MUijv1RbjoclwRkmyyn7CDz/AZzgper
	 r3Gjdz8vU2zroa0lbUr4kql0fa37Ejfj5Teapoyi7UeV/dOSptDali3B/k1l3NTkIP
	 5kfrIWnejWqewY19X8RWMdjVBDZqZJPlAhgSYhEc=
Date: Tue, 02 Jun 2026 15:26:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,william.kucharski@linux.dev,shakeel.butt@linux.dev,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch removed from -mm tree
Message-Id: <20260602222642.6AD991F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make mmap_miss accounting symmetric for VM_SEQ_READ
has been removed from the -mm tree.  Its filename was
     mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: make mmap_miss accounting symmetric for VM_SEQ_READ
Date: Mon, 25 May 2026 07:57:51 -0700

do_sync_mmap_readahead() skips both the mmap_miss increment and the
MMAP_LOTSAMISS check for VM_SEQ_READ mappings, since sequential access is
non-speculative and should always read ahead.  The two decrement sites in
do_async_mmap_readahead() and filemap_map_pages() do not mirror this skip,
so concurrent faults on a VM_SEQ_READ mapping can still drive
ra->mmap_miss down to zero through the decrement paths even though nothing
in the sync path ever increments it.  The counter itself is per-file
(file->f_ra.mmap_miss), so it can be moved by any VMA mapping the file,
not just the one currently faulting.

Skip the decrement for VM_SEQ_READ in both decrement sites so the counter
only moves for mappings that also participate in the increment side.  No
functional change for VM_SEQ_READ users, since the increment-side gate
already prevents the counter from being consulted on their behalf, but it
stops a VM_SEQ_READ mapping from biasing the counter for other mappings of
the same file.

Link: https://lore.kernel.org/20260525145751.2671248-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Closes: https://lore.kernel.org/all/8edc8cd0-f65c-4456-9b3f-362e744c9a96@linux.dev/
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read
+++ a/mm/filemap.c
@@ -3434,8 +3434,13 @@ static struct file *do_async_mmap_readah
 	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
 	 * times for a single folio and break the balance with mmap_miss
 	 * increase in do_sync_mmap_readahead().
+	 *
+	 * VM_SEQ_READ mappings skip the mmap_miss increment in
+	 * do_sync_mmap_readahead(), so skip the decrement here as well to
+	 * keep the counter symmetric.
 	 */
-	if (likely(!folio_test_locked(folio))) {
+	if (likely(!folio_test_locked(folio)) &&
+	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3936,10 +3941,15 @@ vm_fault_t filemap_map_pages(struct vm_f
 		 * In such situation, read-ahead is only a waste of IO.
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
+		 *
+		 * VM_SEQ_READ mappings skip the mmap_miss increment in
+		 * do_sync_mmap_readahead(), so skip the decrement here as
+		 * well to keep the counter symmetric.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
-		    !folio_test_workingset(folio)) {
+		    !folio_test_workingset(folio) &&
+		    !(vma->vm_flags & VM_SEQ_READ)) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch
mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

