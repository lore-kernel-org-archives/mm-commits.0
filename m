Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415118;
	b=rSaOjKAp7g76cc/XJbBOXi6+LLyEO9/dcqx0S7RLq9N55jRVc9nUbiyJkEtQ+nZEsu+G
	 XxpIFnrKEkJjR3znu8X7bIbBu1lNxQlJGVc2nDtIcjNiYT+cK52tcfHKmnKBD9vclb8Rj
	 q1qoNFollgFmBUXa/Kr2YhzzqwAXnTgRLwlaGogyc5m5wAc2Vc3LG4q9Cl1e+Fu2Tem1k
	 kP/Z6r44ZtoctVrPtNjaBo/mS6JIpAYBjwvQDbKGeftKPmgwr/nEU7MEwPY/og3e/yKM0
	 3MNIxyLzA3LkJnoW/VpIfA8zBWjcU031Uygc5am0D0s/XQ04rIAZedg6w14PSX2YKIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415118;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SS+oosl80XdyL0Z9mmC1t2YRkv0wru6lPfW23UT6QMY=;
	b=xzgCfr/RjUeqfuag3ULR6Vco5epTDmkZTQFQ7BDUC5mvVp4ymugx1EtEwoJoEeNgemPs
	 EuagIkuBWiZsdr9xLYOlGcdNeOB7gDT2SZdeAA4Ry3I7MletUN5Rka/67iZvb8qnG22qi
	 8bSnwKCbg/aRLgs0Y6rFhHioDlibzQ7vDXpzCfSA3MRnUaR1v8f2aqlR3IWnwNfjNOn7L
	 1T4nknHVUI0dVObdzRKtBKTDRIEdouSYhRkiE6VDBQwY6I0ekN7Rdl9KJhwbrS3t84per
	 GtE3TpSlXX6QQhXXq8b43fiHteKQ2/FjZgyVrpk7sW/vqzvjcBdmwfZoosMijG2jrng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NqCDXcii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47503606A327;
	Mon, 23 Nov 2026 06:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NqCDXcii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05F41F000CF;
	Mon, 23 Nov 2026 06:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415117;
	bh=SS+oosl80XdyL0Z9mmC1t2YRkv0wru6lPfW23UT6QMY=;
	h=Date:To:From:Subject;
	b=NqCDXciiD1MZ6od2VBAB6qyODde/9eko/R0o5oLMlL6txXQjk8ZN7KTVBU83Wi1V2
	 DsZ+2CN56r6Iv8pRDQjw5Ie/qN3mdV2aGIhX8qWti9GpnbHIQIVM/S3PK2Te7lXojt
	 9RRb59/poe0kmcViAx06hnv3U5EHoTT1dgr/xRsk=
Date: Sun, 22 Nov 2026 22:25:17 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kas@kernel.org,
	david@kernel.org,aarcange@redhat.com,donggeunyoo.kernel@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch removed from -mm tree
Message-Id: <20261123062517.A05F41F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: userfaultfd: clear the inherited uffd bit in move_swap_pte()
has been removed from the -mm tree.  Its filename was
     userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat,  3 Oct 2026 19:30:29 +0900

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never
registered for either.  Nothing clears it there, and userspace sees:

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

Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into
one that isn't, on a page that is swapped out at the time.  It hasn't
been seen in practice.

A resident page doesn't carry the bit, because move_present_ptes() builds
the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
swap entry as well, then re-arm it if the destination is RWP-registered.

The WP case has been there since v6.8, where UFFDIO_MOVE was added.

Link: https://lore.kernel.org/20261003103030.63380-1-donggeunyoo.kernel@gmail.com
Link: https://lore.kernel.org/20261003103030.63380-2-donggeunyoo.kernel@gmail.com
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

 mm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/userfaultfd.c~userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte
+++ a/mm/userfaultfd.c
@@ -1403,6 +1403,7 @@ static int move_swap_pte(struct mm_struc
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

