Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E626A37CD21;
	Thu,  3 Sep 2026 04:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408866; cv=none; b=IYCjoDv8eSg/8hoMH35Mg1URifteSXo3Le9NhfXwaRX13jKS8RviWGQco6NtgBHaW2chb5cmzQW56LRyaJWg5oIgjhXX2I2jADSkGaoQfQkZuYokb2sD9c43vzMInu1NDQkm0Bm/jj7K6HVH/B9f5vUV12QAH2izHW3auhh97yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408866; c=relaxed/simple;
	bh=eG7XwCvlXryH5rAfF7mveTO/FpMe58WtNzzxletXP0s=;
	h=Date:To:From:Subject:Message-Id; b=YwAcPWW+RmarWp88t7K7sg6UuefuZnJ3AGOyGxdOaXfQxm6CJYBDXYDIWVXLQL0a0ISU01sIDpmDM+A/GhS4n0xwaP9D4O+ZdTC7q/8HiiTSo9OkGWodXfKlvbf4A35n1GBqUPnCKWEtoO92S1X4KAeHPIpmxmIGpb86QxcjUHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JCzo4FBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JCzo4FBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF261F000E9;
	Thu,  3 Sep 2026 04:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788408862;
	bh=Y+4UE3Q8YJmIHGrNwd2eSiyT9P58jvJ+JNvzmjjQC2E=;
	h=Date:To:From:Subject;
	b=JCzo4FBw0QzJhbkeI2AIuopUK1z2sn8GJjwcKH9Ew6fD4WjOXILRELtIKhbJpcbTH
	 f6ZfFNm7Fld/L8PcoBaWZiRlpwRowzufZAp6KOKEpZymPHTEb2GX8w7v8HX2+zXhHB
	 sUA8mg6+ue1l6inNzWcGetYhGwPOjzpapreWJouk=
Date: Wed, 02 Sep 2026 21:14:22 -0700
To: mm-commits@vger.kernel.org,yu-cheng.yu@intel.com,vbabka@kernel.org,tglx@linutronix.de,stable@vger.kernel.org,rppt@kernel.org,rick.p.edgecombe@intel.com,orsonpeters@gmail.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,dave.hansen@linux.intel.com,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch added to mm-new branch
Message-Id: <20260903041422.BCF261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: fix pmd_modify() dropping the dirty bit
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch

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
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: x86/mm: fix pmd_modify() dropping the dirty bit
Date: Thu, 3 Sep 2026 11:16:08 +0800

pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
silently discarding the hardware dirty bit.  The subsequent
pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
_PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
stripped from the value, so there is nothing left to transfer.

Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask, and
pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify() is the
odd one out.  Any pmd_modify() on a writable, dirty PMD loses the dirty
state.

One visible consequence is data loss with MADV_FREE on PMD-mapped THP:

    memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
    madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
                                      // folio marked lazyfree
    memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
    mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
    mprotect(buf, size, PROT_READ|PROT_WRITE);
    // ... memory pressure ...

Reclaim (e.g.  under memcg pressure) then finds the lazyfree folio with no
dirty bit set anywhere and frees it in __discard_anon_folio_pmd_locked(),
even though the data was rewritten after MADV_FREE; subsequent reads fault
in fresh zero pages.  NUMA hinting alone can trigger the same loss, as
do_huge_pmd_numa_page() restores the PMD through pmd_modify() as well.

PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
the dirty bit means rewritten data is never written back.

Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
pte_modify() and pud_modify() do.  The existing
pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
hardware-dirty <-> saved-dirty transition based on the write bit,
preserving the shadow-stack encoding rules.

Link: https://lore.kernel.org/20260903031608.1194238-1-vernon2gm@gmail.com
Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
Reported-by: Orson Peters <orsonpeters@gmail.com>
Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-fix-pmd_modify-dropping-the-dirty-bit
+++ a/arch/x86/include/asm/pgtable.h
@@ -806,7 +806,7 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	pmdval_t val = pmd_val(pmd), oldval = val;
 	pmd_t pmd_result;
 
-	val &= (_HPAGE_CHG_MASK & ~_PAGE_DIRTY);
+	val &= _HPAGE_CHG_MASK;
 	val |= check_pgprot(newprot) & ~_HPAGE_CHG_MASK;
 	val = flip_protnone_guard(oldval, val, PHYSICAL_PMD_PAGE_MASK);
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch
mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch
mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch
x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch

