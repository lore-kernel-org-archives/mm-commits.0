Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793920970;
	b=Ga6exo5gu9b8S2lJhiri8wnWIEODDJh06lEiExMGzoExuGGDITQz9P8IFfkKD+YI2AkU
	 sOy7HrAUjlil6WvNFVDvMHuxtCxGMEjRiEJsAI8amQTHs6AE2P+scv9eKTixwJVwOKu+y
	 EaKvi3TspUyfdECbD1+wui8bEzAvtjJ/PlguLlwuiplPwPTCLzvunMMB7vRbxpbezpW1S
	 hngI+lxwZ5N2nxZ6EWyGOvN3Z8fi/Oxe8aHB9SI8cO6k2wASa/qN/5FKBsev37ZosJpoY
	 H/ISznCopLSM0MFV/dfPOXuDzq3zseKL3/HHBm0PFrlZ6w3V14TXsv/O5npt3av71DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793920970;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=H3H7UT4Tn3COQJGrzcVKHJgk9QoJZBEP6lc08YTHFng=;
	b=INWPLzLmyMvf7Xq9xZueaJ1bb3NnuD4/qU9x0BGf1ln3Cp1XpMpTdRGkLkox5khbzQ9W
	 wggkzJqrPO/jssF7L/nb8GKfppdpnADJLQD4Xu9oo9d7ZehmgY+Qi0/jQOWT23Gl1GiS+
	 e9PIG8BPbAlmC5Kvvppk6UqDv+2B0BqeUMzbOQ3ZP0n8XV9BXVLHYB/JIKZZT//5Uhkse
	 EDdTVNfBKXnvGZFuI2WuZfB6zetcWxnW/OLv5ry9TjmEtwtVGbnsCIDlUEAGoAQMnBNGL
	 O5QhwdLrUPOSOSXFgAwZ1g892kYgeOKDBqUbK78vUmLK9ek4RVbV3UXzVO0JOqBgS2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1c3gaekP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BF6606A31B;
	Thu,  5 Nov 2026 23:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1c3gaekP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E45B1F008A2;
	Thu,  5 Nov 2026 23:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793920969;
	bh=H3H7UT4Tn3COQJGrzcVKHJgk9QoJZBEP6lc08YTHFng=;
	h=Date:To:From:Subject;
	b=1c3gaekP6OPEjledXniFOpTKvfWGMgNDUpRSwtPGVjMS9oOAMjYvQnI3UwT0m+Cb9
	 bDOYBaMZfj04jhgjSpnGuuxzkjmO7m0iJ5qDi0YorP/TEoyK7z+qcxkpq+d/gDvKxX
	 wN5ienSFhnLfFA52rWu4sRh4e6fxPlUpmMKYeUbM=
Date: Thu, 05 Nov 2026 15:22:49 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,vbabka@kernel.org,
	tz2294@columbia.edu,surenb@google.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,rppt@kernel.org,nphamcs@gmail.com,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,
	david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20261105232249.8E45B1F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swapfile: drop a large unmapped swap-in folio in unuse_pte()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Mani Tofigh <mt4022@columbia.edu>
Subject: mm/swapfile: drop a large unmapped swap-in folio in unuse_pte()
Date: Thu, 05 Nov 2026 12:19:27 -0500

Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even for
SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into one
large folio in the swap cache.  The folio only becomes anon once
do_swap_page() maps all of it, so if the faulting PTE changes in the
meantime the folio stays in the swap cache while not being mapped or anon:

  Task A (fault)                       Task B
  do_swap_page()
    /* swaps in large folio F */
                                       madvise(MADV_DONTNEED)
                                         /* zaps the faulting PTE */
    /* PTE changed (F not mapped) */

swapoff then maps it, which marks all of its pages as mapped and
exclusive, and the next fault on one of the other PTEs crashes in
do_swap_page():

  [    6.424485] kernel BUG at mm/memory.c:5195!
  [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
  [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
  [    6.451035] Call Trace:
  [    6.451567]  <TASK>
  [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
  [    6.458525]  handle_mm_fault+0x16f/0x480
  [    6.461143]  do_user_addr_fault+0x312/0xa30
  [    6.462044]  exc_page_fault+0x66/0xc0
  [    6.462846]  asm_exc_page_fault+0x26/0x30
  [    6.476708]  </TASK>

do_swap_page() already drops such a folio from the swap cache when it
can't map all of it.  We move that check into a helper and use it in
unuse_pte() too, so swapoff drops the folio and swaps the entries in again
as small folios.  With the fix, the next fault doesn't crash anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 1s.

Link: https://lore.kernel.org/20261105-swapin-large-unmapped-v3-1-d5906e4cf18d@columbia.edu
Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c   |   13 ++++---------
 mm/swap.h     |   10 ++++++++++
 mm/swapfile.c |    9 +++++++++
 3 files changed, 23 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte
+++ a/mm/memory.c
@@ -5198,18 +5198,13 @@ check_folio:
 	 * If a large folio already belongs to anon mapping, then we
 	 * can just go on and map it partially.
 	 * If not, with the large swapin check above failing, the page table
-	 * have changed, so sub pages might got charged to the wrong cgroup,
-	 * or even should be shmem. So we have to free it and fallback.
+	 * have changed, so some folio pages might be charged to the wrong
+	 * cgroup, or even should be shmem. So we have to free it and fallback.
 	 * Nothing should have touched it, both anon and shmem checks if a
 	 * large folio is fully applicable before use.
-	 *
-	 * This will be removed once we unify folio allocation in the swap cache
-	 * layer, where allocation of a folio stabilizes the swap entries.
 	 */
-	if (!folio_test_anon(folio) && folio_test_large(folio) &&
-	    nr_pages != folio_nr_pages(folio)) {
-		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
-			swap_cache_del_folio(folio);
+	if (!swap_cache_folio_mappable(folio, nr_pages)) {
+		swap_cache_del_folio(folio);
 		goto out_nomap;
 	}
 
--- a/mm/swapfile.c~mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte
+++ a/mm/swapfile.c
@@ -2518,6 +2518,15 @@ static int unuse_pte(struct vm_area_stru
 	if (!folio_matches_swap_entry(folio, entry))
 		return 0;
 
+	/*
+	 * A large folio that a fault didn't map can't be mapped one PTE at a
+	 * time here, so drop it and swap in small folios instead.
+	 */
+	if (unlikely(!swap_cache_folio_mappable(folio, 1))) {
+		swap_cache_del_folio(folio);
+		return 0;
+	}
+
 	swapcache = folio;
 	folio = ksm_might_need_to_copy(folio, vma, addr);
 	if (unlikely(!folio))
--- a/mm/swap.h~mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte
+++ a/mm/swap.h
@@ -464,6 +464,16 @@ static inline void __swap_cache_replace_
 }
 #endif /* CONFIG_SWAP */
 
+static inline bool swap_cache_folio_mappable(struct folio *folio,
+		unsigned int nr_pages)
+{
+	if (folio_test_anon(folio) || !folio_test_large(folio) ||
+	    nr_pages == folio_nr_pages(folio))
+		return true;
+	VM_WARN_ON_ONCE_FOLIO(folio_test_dirty(folio), folio);
+	return false;
+}
+
 extern const struct swap_ops swap_bdev_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
_

Patches currently in -mm which might be from mt4022@columbia.edu are

mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch
mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch
mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch

