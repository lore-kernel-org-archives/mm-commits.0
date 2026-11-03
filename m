Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672127;
	b=QxvYFLf95cd2iPkPY0iOgmHorLdYyysJeY45eUoG37F5pmSVIytBhtJOY/Kzl4jy8C+Q
	 ozVWiTywLz82G55PO8Ho591/BPmRhio1O5NrGLgatSpihwO6Qd/HoAy0IHvVMRY81dCJn
	 j0qJaO9av4x9iGP2QzIAdZRFnJe82YW5wEejpXI9MiCwBsGCK6gGhnrdZwLNAU6aeApGi
	 uJP2CxDNG2goGk4ePy2Jt0M9AwFt+fOxesi21b/zmFzL3KL/wNK16BYMqg1keQ67FgtIn
	 pIc49R6v19tpw0+X9/hDSwhcdP5z4QljqbgESKuoaRaVY0hfQnI0axUqxUUOf7o8sjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672127;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oTF8QaOB4cRFamksKRcLhEEEJhAZ4Jr1ZHnY/JyIO90=;
	b=i21zzZN9O5qcr/W1fvmsQt61d+sNXPNrKPS8iDkMhd+T81k09ZiwTVNkB8/c1Ssdr8A8
	 9Tc2eOKH+eI7J/eqPnn34EnkRxwIl0OwmvH8AuTs05nWLMSdx0w/psZGAdM8krHT15qnI
	 nnU574u+kxiPgg9J2ocscF7e1fd7qFm6XCqGSxCBLk1cdvrsIBigaq35GlVVLafPTJxS/
	 U/3mP30Tjmap/dP8C7hOZLYyTbHBB5JTSTaqabusdCfSaTko/wyAdc9ye8ojW7izWdbBy
	 F+Yiucvr3QhKq+0xYPtiKIT++EReGqT3VQ2LVKA5i1Tb5LwkrRyxRypJl5sEvQ6kIXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Knj0wGPh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D77606A32F
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Knj0wGPh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913F51F00919;
	Tue,  3 Nov 2026 02:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672126;
	bh=oTF8QaOB4cRFamksKRcLhEEEJhAZ4Jr1ZHnY/JyIO90=;
	h=Date:To:From:Subject;
	b=Knj0wGPhVRtohUsya5Nuzy2DWCOzsciOfDikJnmtNSF1QG19oFnb3Mbi2z2e/9r+m
	 +g2AndVFpBZ3/rUcuSk9AFFTOrfCPn3yD6pYI37KnUSG5JMGnvEdzEG6qv5uU8qhTm
	 eqq4+vMGJBa3PYfTN83dDkmtbwYCq71XgeUP5EQs=
Date: Mon, 02 Nov 2026 18:15:26 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,
	osalvador@suse.de,muchun.song@linux.dev,lizhe.67@bytedance.com,
	azpijr@gmail.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch removed from -mm tree
Message-Id: <20261103021526.913F51F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: disable PMD sharing for UFFD missing mode
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: disable PMD sharing for UFFD missing mode
Date: Thu, 22 Oct 2026 11:45:42 +0800

For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
sufficient to have the VMA registered for missing mode.

However, UFFD missing mode does currently not block PMD table sharing, so
installing the marker will be visible to everyone using the shared PMD
table, which is wrong as UFFDIO_POISON must stay local to the process.

To fix it, make uffd_disable_huge_pmd_share() cover VM_UFFD_MISSING as
well. With missing mode covered, hugetlb PMD sharing is disabled for all
userfaultfd registered VMAs, so the helper can simply return whether the
VMA has a userfaultfd context instead of testing individual UFFD mode
flags. Add a debug check on the marker installation path.

The existing registration path will then unshare PMD tables, and
subsequent faults will not share them while the mapping remains
registered.

The alternative would be to unshare PMD tables selectively when
installing poison markers, which results in way more complexity. Or
alternatively, simply failing the marker installation, which might break
some use cases.

This also disables PMD sharing for userfaultfd registrations that never
use UFFDIO_POISON.

Link: https://lore.kernel.org/20261022034543.51226-3-lizhe.67@bytedance.com
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Li Zhe <lizhe.67@bytedance.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---

 include/linux/userfaultfd_k.h |   16 +++-------------
 mm/hugetlb.c                  |    1 +
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode
+++ a/include/linux/userfaultfd_k.h
@@ -168,22 +168,12 @@ static inline bool is_mergeable_vm_userf
 }
 
 /*
- * Never enable huge pmd sharing on some uffd registered vmas:
- *
- * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
- *   tracking information is per pgtable entry.
- *
- * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
- *   VMAs which share huge pmds. (If you have two mappings to the same
- *   underlying pages, and fault in the non-UFFD-registered one with a write,
- *   with huge pmd sharing this would *also* setup the second UFFD-registered
- *   mapping, and we'd not get minor faults.)
+ * Never enable huge pmd sharing on userfaultfd registered VMAs, because
+ * userfaultfd state can be tracked per VMA or per page table entry.
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
-					VMA_UFFD_MINOR));
+	return vma->vm_userfaultfd_ctx.ctx;
 }
 
 /*
--- a/mm/hugetlb.c~mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode
+++ a/mm/hugetlb.c
@@ -6388,6 +6388,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			return -EEXIST;
 		}
 
+		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
 		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
 		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

