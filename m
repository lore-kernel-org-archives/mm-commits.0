Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0DE27B35B
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777387217; cv=none; b=JaRgz0dVgxsCRTsraq7obJKAbEsZel7qGJQJrie545t5DuenDKRCITKNyAhyEsBjsBKuZv6+Gth51THrIhRInMbbon6HML49cHAx2z7VpHZ/cpllTVeB4t4trPifB2efVjkrdK/7kUoNDF/V3/f48ujUehwctviwAR2+iLj8vUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777387217; c=relaxed/simple;
	bh=4odd3jnTnJIBTAFjLPvDPTJi8R8JZcpPE+t7kB9N+9I=;
	h=Date:To:From:Subject:Message-Id; b=SgRZ0rHxK5J4USZRHHO4nCRJPG7TyS6NkUht9wUyw/iZHca6z2FA016ljrWLPhImDKwziUyyuujiK53ayDWYUuM9usO33Zo0SQd/BrzB/zt1ZvDsPErnZZMXWW9xK/2A145/6yCzHULsyiXaelqZvkqFg+f3ae+GpPqZE6FUj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UnJk0c5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UnJk0c5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D4DC2BCB7;
	Tue, 28 Apr 2026 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777387216;
	bh=4odd3jnTnJIBTAFjLPvDPTJi8R8JZcpPE+t7kB9N+9I=;
	h=Date:To:From:Subject:From;
	b=UnJk0c5JmrAd8VGr4MWr7TTL0knKK9N8LnPZeYXQCSQJIuW9OXT9ePFeELMA09Fov
	 4TS2A/tUtRCDN0+aHd3kuf3nPMwQMgbP9InGJ/5hp4hZDR9wLUsk4pZfcJ4gKsYj6n
	 ZRsew3yI39xOMG1J7kTUX0oULjs7uDkPpsTQR3pY=
Date: Tue, 28 Apr 2026 07:40:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,jack@suse.cz,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch added to mm-new branch
Message-Id: <20260428144016.66D4DC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: count only the faulting address as a mmap hit
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch

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
From: fujunjie <fujunjie1@qq.com>
Subject: mm/filemap: count only the faulting address as a mmap hit
Date: Tue, 28 Apr 2026 01:59:43 +0000

Patch series "mm/filemap: tighten mmap_miss hit accounting", v3.

mmap_miss is increased when synchronous mmap readahead is needed, and
decreased when filemap_map_pages() maps folios that are already in the
page cache.  The decrease side can over-credit hits in two cases:

  - fault-around installs nearby PTEs even though the fault only proves
    that the faulting address was accessed;
  - after synchronous mmap readahead returns VM_FAULT_RETRY, the retry
    can find the folio brought in by the same miss and immediately
    cancel that miss.

Current evidence comes from a local KVM/data-disk microbenchmark using
mmap_miss_probe, with an 8 GiB guest, 2 vCPUs, 8192 KiB read_ahead_kb,
cold page cache before each run, 1% of the file accessed, and medians of 3
runs.

mmap_miss_probe mmap()s a prepared file with MADV_NORMAL and then touches
one byte at selected base-page offsets.  The access order is random,
sequential, or a fixed page stride.  The harness drops caches before each
run and samples /proc/vmstat around that access loop.

The 20 GiB case below is a larger-than-memory file case in an 8 GiB guest.
No separate memory hog was used.  The 4 GiB case uses the same 8 GiB
guest but keeps the file fit-in-memory.

Each case used a fresh temporary qcow2 data disk, seen by the guest as
/dev/vda, formatted as ext4 and mounted at /mnt/mmap-matrix.

Each result is "pgpgin GiB / elapsed seconds".  "pgpgin GiB" is the delta
of the guest /proc/vmstat pgpgin counter, converted from KiB to GiB; it is
used here as an approximate block input counter, not as resident memory or
exact application IO.  "Elapsed seconds" is the wall-clock runtime of the
whole mmap_miss_probe access pass, not per-access latency.

For the 20 GiB larger-than-memory case:

        workload       before                after
        random         223.377 GiB/101.293s  1.010 GiB/4.790s
        stride1021     204.214 GiB/97.557s   204.208 GiB/108.086s
        stride2053     409.584 GiB/193.700s  0.970 GiB/3.685s
        stride4099     406.452 GiB/134.241s  0.975 GiB/3.499s
        sequential       0.212 GiB/0.050s    0.212 GiB/0.057s

For the 4 GiB fit-in-memory case:

        workload       before              after
        random         3.987 GiB/1.960s    0.980 GiB/1.221s
        stride1021     4.002 GiB/1.838s    4.002 GiB/1.851s
        stride2053     3.991 GiB/1.835s    0.811 GiB/0.985s
        stride4099     4.001 GiB/1.836s    0.819 GiB/1.037s
        sequential     0.056 GiB/0.013s    0.056 GiB/0.018s

The 20 GiB setup also has an ablation.  P1 is only the faulting-address
hit accounting change.  P2-only is only the FAULT_FLAG_TRIED retry
filter.  P1+P2 is the combined accounting change:

        workload    variant   result
        random      baseline  223.377 GiB/101.293s
        random      P1        223.268 GiB/98.481s
        random      P2-only   223.257 GiB/100.091s
        random      P1+P2     1.010 GiB/4.790s
        stride2053  baseline  409.584 GiB/193.700s
        stride2053  P1        409.584 GiB/197.645s
        stride2053  P2-only   15.722 GiB/5.485s
        stride2053  P1+P2     0.970 GiB/3.685s
        sequential  baseline  0.212 GiB/0.050s
        sequential  P1        0.212 GiB/0.046s
        sequential  P2-only   0.212 GiB/0.050s
        sequential  P1+P2     0.212 GiB/0.057s

After the v2 implementation refactor, only the final P1+P2 shape was rerun
in the same setup.  The numbers stayed in line with the v1 P1+P2 rows
above:

        workload       larger-than-memory case    fit-in-memory case
                       20 GiB file, 1% access    4 GiB file, 1% access
        random           1.010 GiB/4.383s          0.980 GiB/1.088s
        stride1021     204.216 GiB/105.601s        4.001 GiB/1.783s
        stride2053       0.970 GiB/3.760s          0.810 GiB/0.908s
        stride4099       0.975 GiB/3.410s          0.818 GiB/0.870s
        sequential       0.212 GiB/0.060s          0.056 GiB/0.016s

This does not claim to solve every sparse pattern.  The stride1021 rows
are intentionally shown as a boundary: with 8192 KiB read_ahead_kb,
file->f_ra.ra_pages is 2048 base pages, and synchronous mmap read-around
uses a 2048-page window centered around the fault, roughly [index - 1024,
index + 1023].  stride1021 is 1021 * 4 KiB = 4084 KiB, so the next access
lands inside the previous read-around window.  About every other access
can be a real faulting-address page-cache hit, and the other half can each
read about 8 MiB.  For about 52k accesses in the 20 GiB/1% run, half of
them times 8 MiB is about 205 GiB, matching the observed 204 GiB.


This patch (of 2):

filemap_map_pages() reduces file->f_ra.mmap_miss when fault-around maps
folios that are already present in the page cache.  That hit accounting is
too generous because fault-around can install PTEs around the faulting
address even though the fault only proves that the faulting address was
accessed.

Move the mmap_miss update back into filemap_map_pages(), drop the
mmap_miss argument from the helper functions, and decrement mmap_miss only
when the helper return value shows that the faulting address was mapped. 
Keep the existing workingset-folio behavior unchanged.

Link: https://lore.kernel.org/tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com
Link: https://lore.kernel.org/tencent_756F151FE66F3D80479A6F982C0AB8569F09@qq.com
Signed-off-by: fujunjie <fujunjie1@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   62 ++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

--- a/mm/filemap.c~mm-filemap-count-only-the-faulting-address-as-a-mmap-hit
+++ a/mm/filemap.c
@@ -3751,8 +3751,7 @@ skip:
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned long *rss, unsigned short *mmap_miss,
-			pgoff_t file_end)
+			unsigned long *rss, pgoff_t file_end)
 {
 	struct address_space *mapping = folio->mapping;
 	unsigned int ref_from_caller = 1;
@@ -3785,16 +3784,6 @@ static vm_fault_t filemap_map_folio_rang
 			goto skip;
 
 		/*
-		 * If there are too many folios that are recently evicted
-		 * in a file, they will probably continue to be evicted.
-		 * In such situation, read-ahead is only a waste of IO.
-		 * Don't decrease mmap_miss in this scenario to make sure
-		 * we can stop read-ahead.
-		 */
-		if (!folio_test_workingset(folio))
-			(*mmap_miss)++;
-
-		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
 		 * handled in the specific fault path, and it'll prohibit the
 		 * fault-around logic.
@@ -3840,7 +3829,7 @@ skip:
 
 static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 		struct folio *folio, unsigned long addr,
-		unsigned long *rss, unsigned short *mmap_miss)
+		unsigned long *rss)
 {
 	vm_fault_t ret = 0;
 	struct page *page = &folio->page;
@@ -3848,10 +3837,6 @@ static vm_fault_t filemap_map_order0_fol
 	if (PageHWPoison(page))
 		goto out;
 
-	/* See comment of filemap_map_folio_range() */
-	if (!folio_test_workingset(folio))
-		(*mmap_miss)++;
-
 	/*
 	 * NOTE: If there're PTE markers, we'll leave them to be
 	 * handled in the specific fault path, and it'll prohibit
@@ -3886,7 +3871,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 	vm_fault_t ret = 0;
 	unsigned long rss = 0;
 	unsigned int nr_pages = 0, folio_type;
-	unsigned short mmap_miss = 0, mmap_miss_saved;
 
 	/*
 	 * Recalculate end_pgoff based on file_end before calling
@@ -3925,6 +3909,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
+		vm_fault_t map_ret;
 
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
@@ -3932,13 +3917,34 @@ vm_fault_t filemap_map_pages(struct vm_f
 		end = folio_next_index(folio) - 1;
 		nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
 
-		if (!folio_test_large(folio))
-			ret |= filemap_map_order0_folio(vmf,
-					folio, addr, &rss, &mmap_miss);
-		else
-			ret |= filemap_map_folio_range(vmf, folio,
-					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss, file_end);
+		if (!folio_test_large(folio)) {
+			map_ret = filemap_map_order0_folio(vmf, folio, addr,
+							   &rss);
+		} else {
+			unsigned long start = xas.xa_index - folio->index;
+
+			map_ret = filemap_map_folio_range(vmf, folio, start,
+							  addr, nr_pages, &rss,
+							  file_end);
+		}
+		ret |= map_ret;
+
+		/*
+		 * If there are too many folios that are recently evicted
+		 * in a file, they will probably continue to be evicted.
+		 * In such situation, read-ahead is only a waste of IO.
+		 * Don't decrease mmap_miss in this scenario to make sure
+		 * we can stop read-ahead.
+		 */
+		if ((map_ret & VM_FAULT_NOPAGE) &&
+		    !folio_test_workingset(folio)) {
+			unsigned short mmap_miss;
+
+			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
+			if (mmap_miss)
+				WRITE_ONCE(file->f_ra.mmap_miss,
+					   mmap_miss - 1);
+		}
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
@@ -3948,12 +3954,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 out:
 	rcu_read_unlock();
 
-	mmap_miss_saved = READ_ONCE(file->f_ra.mmap_miss);
-	if (mmap_miss >= mmap_miss_saved)
-		WRITE_ONCE(file->f_ra.mmap_miss, 0);
-	else
-		WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss_saved - mmap_miss);
-
 	return ret;
 }
 EXPORT_SYMBOL(filemap_map_pages);
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch
mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch
mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch

