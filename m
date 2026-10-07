Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7096314D37
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334357; cv=none; b=Rlrtf//FVMk9qGVy/pnovAqZ/hC2/mqpWs3goHd9M/A571aOGv55MTqUEa/itUkbq/fKystiYn6s1PdwTd8E8RSKPu3jvSbJk+bGUpKWBwV0FfjNe8+cRgAV26pTMMo7LHIgjVMnUHHy0ga5eanApJR68xytePr42qDKU+kPuSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334357; c=relaxed/simple;
	bh=eL9zqIiyL/UnUb5J1mmAofBgzxd1J3GP4DczPQ1ENQw=;
	h=Date:To:From:Subject:Message-Id; b=S3TVdfKeSgLJGPKO5YX5Tnm3+ofgMBfN9dcuIDXtRIdwe7xrkliZNKprWQVuNrBBH6DCTwtTGMcYt6eIkrE96IVqj50tuYZV+yQAUTm8TstvVf36RDY1xl4b/ZQ+9w2MmPb1l5weJzhsliU645v0qK5mdU2RsVlt151C4CvtEkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UTrdXT1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UTrdXT1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0BA1F0089C;
	Wed,  7 Oct 2026 00:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334356;
	bh=vyeP17fNRPVg8grIpNy8v/qPC8yFKLfnL/uiip0VDeA=;
	h=Date:To:From:Subject;
	b=UTrdXT1oI8FcOFWEoi33UFBB7F9TewtJJXHltdMoynzUsJbvVFm+H+J4fnE46Ca+z
	 b1MZxa03Y3c0Uiivss2l5iiSiyBUJS35F1nBCu55p5Hn/CpfUCK1F1EkdlLREoN1eX
	 T53COcyvULtqkCFA1FdgsYYzw0EEUOJ4h/OdVuBM=
Date: Tue, 06 Oct 2026 17:52:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch removed from -mm tree
Message-Id: <20261007005236.7E0BA1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused totalram_pages_inc() and totalram_pages_dec()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove unused totalram_pages_inc() and totalram_pages_dec()
Date: Tue, 01 Sep 2026 15:38:05 -0400

totalram_pages_inc() and totalram_pages_dec() have had no callers since
commit 7fbc5e26123e ("memblock: extract page freeing from
free_reserved_area() into a helper") and commit 287b89773d81
("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
totalram_pages_*"), respectively. Remove them.

Drop the totalram_pages_inc() stub from tools mm.h too.

Link: https://lore.kernel.org/20260901-mm-remove-unused-helpers-v2-2-f6474e169c23@columbia.edu
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/mm.h       |   10 ----------
 tools/include/linux/mm.h |    4 ----
 2 files changed, 14 deletions(-)

--- a/include/linux/mm.h~mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec
+++ a/include/linux/mm.h
@@ -57,16 +57,6 @@ static inline unsigned long totalram_pag
 	return (unsigned long)atomic_long_read(&_totalram_pages);
 }
 
-static inline void totalram_pages_inc(void)
-{
-	atomic_long_inc(&_totalram_pages);
-}
-
-static inline void totalram_pages_dec(void)
-{
-	atomic_long_dec(&_totalram_pages);
-}
-
 static inline void totalram_pages_add(long count)
 {
 	atomic_long_add(count, &_totalram_pages);
--- a/tools/include/linux/mm.h~mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec
+++ a/tools/include/linux/mm.h
@@ -33,10 +33,6 @@ static inline phys_addr_t virt_to_phys(v
 	return (phys_addr_t)address;
 }
 
-static inline void totalram_pages_inc(void)
-{
-}
-
 static inline void totalram_pages_add(long count)
 {
 }
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

