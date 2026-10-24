Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832253;
	b=JtEIyvRSmLIyHIHruLe28SvVcobCmCgWMv0bCHhn5lraM2VwpzW+yKKVuScDXp3d4Sma
	 XKBy9w4R1ADAG2A7jlgtQIttK5PSPpBYp+TlWgYMPXsWS/VoXGxJttQG82AO9W0lXhdHi
	 0t0uv14TyIhpPQ7MKtfZKNv4/+vGkIwpnlxcXoCYDVMo2z55On9f3tlZChpyS9YeiWpBn
	 K1pW6gwc72Sf/czCl1S2BHicGNR6Jrm/s2l5zzMcyBcqEDD0ZyGw3sotwQCvgP61iZjbD
	 pKkKL4WWK3G3aZkOnOzKsqdyFqJmVWhveeJuwzpGHbSXBF8CU4zUBSj9i5/LP3QdEuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832253;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iBwya1pFxy2lB+NmEFW7mNb494AQXT82p7KLD3+pkjQ=;
	b=kem9nbnaxd5lS0klInrqOK1GeyjCO/swmy1OR7vXHsOFYTLHTR3nwdGRh20m7BKyHxtw
	 eNms5VyDzhxR5pRMQCRDwiSED0azGRuU6iJYeI30K4eOET7l/LqukP8Vl8oxv+G7pmbXR
	 ITJO2GH8DczX+wuqL9YovoRhGIr8FKcFXCOVTfVzlxuGab7o6+/Ip0kyrJcNqFQRRZFdV
	 KtiketUP24PGxnAlnJ1nKuJ+XUfKwwy33eIclMLg4HsLS+TbzpNAM6uFSZ27C0JPtCE2R
	 F2nxX4gbIMaq4Ty5qxxp+wRo9yv5+WDjsZBsZ8F+ZB2tSipb0zAAPjqzRfs5amLuVxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gvcxcjEt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86760606A31A;
	Sat, 24 Oct 2026 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gvcxcjEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545CC1F01825;
	Sat, 24 Oct 2026 08:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832253;
	bh=iBwya1pFxy2lB+NmEFW7mNb494AQXT82p7KLD3+pkjQ=;
	h=Date:To:From:Subject;
	b=gvcxcjEtSaIDItpr4FzqrBX826CJtaAM9XgvxmPR08wFL3SNGSoj85zYCUogxEfvS
	 dh5bQX8vcpPly7evxiZZP3vACn1lnHqBe/2gj1xoY6ge/o/JaLTHksd5Y7Zfj4WIvQ
	 YUdPEVrZLeMem0f10dc2ZZcD+rsdaCxIvWQFK+WU=
Date: Sat, 24 Oct 2026 01:57:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch removed from -mm tree
Message-Id: <20261024085733.545CC1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry
Date: Thu, 15 Oct 2026 18:07:15 +0200

An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
uffd bit set, the bit that userfaultfd write protection uses too.  When
__unmap_hugepage_range() zaps an entry with that bit it leaves a
PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.

In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
nothing.  The next fault has hugetlb_no_page() turn it into a present,
read-only entry with the uffd bit.  That is not an RWP entry, since it is
not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
registered together).  An earlier fix solved some side effects, now just
stop the zap from wrongly installing a marker.

Leave a marker only if the VMA is registered for write protection, both
for present and for non-present entries.  The zap of ordinary page
tables has the same test, in cond_install_uffd_wp_ptes(), and
hugetlb_change_protection() says that "uffd_rwp does not install markers".

After a zap the range of an RWP VMA is simply empty, as it is for
anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
a VMA that is not registered at all a leftover uffd bit or marker is now
dropped by the zap and no longer kept alive.

Original fix generated by an LLM and sent in private by Josef.

[david@kernel.org: a bit of description overhaul+simplification]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-9-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry
+++ a/mm/hugetlb.c
@@ -5309,7 +5309,7 @@ void __unmap_hugepage_range(struct mmu_g
 			 * drop the uffd-wp bit in this zap, then replace the
 			 * pte with a marker.
 			 */
-			if (pte_swp_uffd_any(pte) &&
+			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
 			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP),
@@ -5345,7 +5345,7 @@ void __unmap_hugepage_range(struct mmu_g
 		if (huge_pte_dirty(pte))
 			folio_mark_dirty(folio);
 		/* Leave a uffd-wp pte marker if needed */
-		if (huge_pte_uffd(pte) &&
+		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP),
_

Patches currently in -mm which might be from josef@toxicpanda.com are


