Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7DC40B396
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144267; cv=none; b=JrA3sifDaQX8tI3CVPisy74kdiY2WhQxZW5YGVOJcImKRDB1eQjtRPhBkCVwYCU0FeJkN8O9PazYVg0WKj+J+/XYv2o8ARkuy02bTkzjSJ1rw9pRMzm7aRHVJ2Pgo42K23xZBei6u/Vxe80g11ERF7qoj7TaAS2QW5y1Sxotixk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144267; c=relaxed/simple;
	bh=Bk8SD+ei4rdW6ri049lTyWWdQ+dCi99H6HSI2R7Q7TM=;
	h=Date:To:From:Subject:Message-Id; b=H0wgfVGIi3IloYek2PZKL/fK4hiBNIdNofCTH2KdcW+JB8cnYAbY9g2Q6t+IBiM1ll/wSuc1ShFUIZ+O9OpkyBf8Ks1cyLiFAKOXnNUCpxwbSNlNKQX3A8PjnU829XuPxmMV3VqhNcE19iMzSFPBrnh1GdcxPQx5VgQAjxQLF/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x5tKy4+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x5tKy4+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F0B1F000FF;
	Sun,  4 Oct 2026 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144264;
	bh=nzTBLKqm5V5NRBTHE7bi+SZIS6quURJQSq/zSPJvLpQ=;
	h=Date:To:From:Subject;
	b=x5tKy4+Lg36ZUYyzjExwsgr+ozopvdsaf/WUrBQwMP/VelsEUSkKVz/DkAqsPuMBv
	 KGuGuMcN9FsF/V2VzgDJJSLfW6zcH6SIx6Gl2pc0hV35hDGebCGDGHXcpix01uam1m
	 v4/i6DgpkMZhR77vvjvImGd+QiEtlhZ3kQazWfO0=
Date: Sun, 04 Oct 2026 13:04:24 -0700
To: mm-commits@vger.kernel.org,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch removed from -mm tree
Message-Id: <20261004200424.B6F0B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: clear the inherited uffd bit in move_swap_pte()
has been removed from the -mm tree.  Its filename was
     userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 26 Sep 2026 21:41:44 +0900

Patch series "userfaultfd: clear the inherited uffd bit in
move_swap_pte()", v3.


UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never registered
for either, and nothing clears it afterwards.  Patch 1 clears the bit,
then re-arms it if the destination is RWP-registered, which is what the
present-page and zeropage move paths already do.  Patch 2 adds the tests
that catch it.


This patch (of 2):

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never registered
for either.  Nothing clears it there, and userspace sees:

 - /proc/<pid>/pagemap reports the page as uffd-tracked (bit 57), both
   while it is swapped out and after it is faulted back in.
 - MADV_COLLAPSE fails with EINVAL on a range containing it, because the
   collapse scan bails on a swap entry with the uffd bit set.
 - With CONFIG_PAGE_TABLE_CHECK, faulting the page in warns.
   do_swap_page() carries the bit into the present PTE and, since the
   destination isn't WP-registered, also makes it writable:

   WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
   Call Trace:
    set_ptes+0x67/0xc0
    do_swap_page+0x990/0xfe0
    __handle_mm_fault+0x7d0/0xeb0
    handle_mm_fault+0x9c/0x250
    do_user_addr_fault+0x207/0x650
    exc_page_fault+0x65/0x150
    asm_exc_page_fault+0x26/0x30

Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into one
that isn't, on a page that is swapped out at the time.  It hasn't been
seen in practice.

A resident page doesn't carry the bit, because move_present_ptes() builds
the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
swap entry as well, then re-arm it if the destination is RWP-registered.

The WP case has been there since v6.8, where UFFDIO_MOVE was added.

Link: https://lore.kernel.org/20260926124145.2878520-1-donggeunyoo.kernel@gmail.com
Link: https://lore.kernel.org/20260926124145.2878520-2-donggeunyoo.kernel@gmail.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Assisted-by: LLM
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/userfaultfd.c~userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte
+++ a/mm/userfaultfd.c
@@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struc
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
 	if (userfaultfd_rwp(dst_vma))
 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
_

Patches currently in -mm which might be from donggeunyoo.kernel@gmail.com are

selftests-mm-add-tests-for-uffdio_move-of-a-uffd-protected-swap-entry.patch
mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch
mm-damon-tests-core-kunit-test-the-size-charged-for-a-filter-trimmed-region.patch
mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch
mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

