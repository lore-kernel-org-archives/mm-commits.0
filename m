Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832467;
	b=JZ77WbP11E+NI+0/pQWS8WMKPQL+C0bQjZgE0Ekhl5AGCW0ChrVAvY70jnZu/VN0Tx48
	 HLN+HW65wi4+TNOfllf8AMjpaZMzbBM50AUXdpjqWH11TV4ebMBdgiJaDQfSVi07ZzFSi
	 Bi7O9vtZNpipxVl/aUiPBugxa/Tvrm4MtDlktsUj/ucpJkVhOpDh3IzIpHNIzsGJyEyX0
	 499HoUT8WmA5IK05P5np0rHVV3nmQw2/IcWLCUlurZopgfwzyBRBRZl5E6vNbrZrQdHAk
	 r8J2Cx9Cq1nHVq6QWdquktXUNONXrBkAtkJXlXzlSWH3lVW4xTFT/823AQ9zBF2UEzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832467;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=337xbWffVZGKdi/djWAmhdNf/sZVVOmRIgfvaCqBBK4=;
	b=KhjAMMvtoOJpRanNFLYZwz+JQTq2Z6W6Z21NMongU/whdBsPwgbSEbcZ+I5m+T05rOoE
	 o4qLLyvR6Dx5g0q7s/oAY8g2SygKN9NU7++Cb+hDOkUCBlSPXZtZAkmd4I2U5a3lyTfmt
	 RmpnsWiNAPc+ih5W8dSQuVCuvGdh7DIgYhdsPidDhGNAXABXVeq4CL76+K7mLb3Hd3+Kk
	 qysNVLP/w9A1Qpo3gLjzHmSQIr2Yj8lSyJIRBNeFXRnTANeTZMyLFFW5jDPSeJbiJMcvt
	 ESucOhtVRxLX4jT3DIrBZPCi/L675YHgxpqPI3pcrtEj+SvXzdwaNq0wwApSPeQtaXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="rhj8rK/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE59606A322;
	Sat, 24 Oct 2026 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rhj8rK/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676E11F01828;
	Sat, 24 Oct 2026 09:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832467;
	bh=337xbWffVZGKdi/djWAmhdNf/sZVVOmRIgfvaCqBBK4=;
	h=Date:To:From:Subject;
	b=rhj8rK/tZ9kqKmDNFYUkQdA4FY5KNCqsqpGizvonodHSHl8uL331u5ojJiN4v79PL
	 kPg6mr9zwmlMctZ7THOob1eYV2LWUAX/xzydTnmXvihBomMHIIh3n4fTpM4AFGLPX2
	 ByEYuN4AZC0J9uv8p2MRnCxMoauBeku8NmoaKh8A=
Date: Sat, 24 Oct 2026 02:01:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,riel@surriel.com,malhyuk97@gmail.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kylebot@openai.com,jannh@google.com,harry@kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch removed from -mm tree
Message-Id: <20261024090107.676E11F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/rmap: don't discard lazyfree THPs at PMD level
has been removed from the -mm tree.  Its filename was
     mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/rmap: don't discard lazyfree THPs at PMD level
Date: Mon, 12 Oct 2026 22:20:16 -0400

__discard_anon_folio_pmd_locked() clears a lazyfree THP's PMD before it
determines whether the folio can be discarded, and restores it if the
folio is dirty or has extra references.  It is done under only the PMD
lock and the anon_vma read lock inside try_to_unmap_one() and no mmap lock
is held.  The temporarily none PMD causes UAF.

A parallel munmap() or mremap() is supposed to serialize with it on the
PMD lock, but zap_pmd_range() (called by munmap()) and move_page_tables()
(called by mremap()) do not take the lock when they see the temporarily
none PMD and skip the PMD.  There is no more page table walk after the
none PMD is restored:

- munmap(): free_pgtables() waits in unlink_anon_vmas() for the anon_vma
  lock, then free_pmd_range() drops the restored PMD as bad without
  removing the rmap, so the folio keeps a stale mapcount.

- whole-VMA MREMAP_DONTUNMAP: dontunmap_complete() unlinks the source VMA
  from its anon_vma while the restored PMD still maps the folio.

- plain mremap(): the THP is not moved but unmapped, so the THP's data is
  lost.

In the first two cases, the folio stays mapped, but no VMA that maps it is
linked to its anon_vma.  When the anon_vma is freed, it is still reachable
when one rmap walks the folio.  Racing lazyfree reclaim against
MREMAP_DONTUNMAP as an unprivileged user reproduces a KASAN use-after-free
in folio_lock_anon_vma_read() as reported in the Closes link.

One solution is to use an invalidated PMD instead of a cleared one until
the discard is committed, but it needs arch fixes first.
1. GUP-fast still follows an invalidated PMD on riscv, LoongArch and s390.
2. sparc64 miscounts thp_pte_count when an invalidated PMD is set again or
   cleared.

To keep the fix simple for backport, stop discarding lazyfree THPs at PMD
level instead. try_to_unmap_one() splits the PMD and discards the folio at
PTE level.

unmap_huge_pmd_locked() and __discard_anon_folio_pmd_locked() are left in
place, unused, to minimize this fix for backport and the invalidated PMD
approach is planned as a follow-up series to use them again.

Link: https://lore.kernel.org/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com
Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: JongHyuk Kim(MalHyuk) <malhyuk97@gmail.com>
  Link: https://lore.kernel.org/CADQRuqvXQ=YE=7T3oR66vTxE33pi=ygEeZKPTOU=cALZL0Figw@mail.gmail.com
Assisted-by: LLM
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/rmap.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/rmap.c~mm-rmap-dont-discard-lazyfree-thps-at-pmd-level
+++ a/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
_

Patches currently in -mm which might be from ziy@nvidia.com are


