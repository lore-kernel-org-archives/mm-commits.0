Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7B45D923;
	Fri, 18 Sep 2026 05:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710227; cv=none; b=VcjQ2lSg/ZTOHewXRg6xQKPi1mou6t3e9MxypwEWoBto+KIOzdSEKuJLWS08vt0jxt8ApX+lKC/B9G2z6VJXLOe1aqgdmXnbP/+fhAQAvVP2WCktueyOYcPe9DiwMw6UEQGU3A5dYkZJBKJo6mIPbZjla4HRHqCbeLcE0i5NXk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710227; c=relaxed/simple;
	bh=/QcVhIadBwI77xTkXtnJXqkjh5aYadKn2QKEc6D8b/0=;
	h=Date:To:From:Subject:Message-Id; b=eAciDGXFfF6pSf24WY20BKn+jUUCU1OLMyHSs+38mlqmdLb6t+4+/l2Bwl6Ktr7b106JDB8kgOhm137HtmFvePnpCjTxvRTCFmEHQjWT1z4xZMpUoYxx52aRuWxKx5CWiyolZsdwi5MA3tfUDyKVLy/EwXGntmmpKoyQAOI7bCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DC2qGoMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DC2qGoMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DFE1F00893;
	Fri, 18 Sep 2026 05:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710226;
	bh=8ene5QHweez0FEJzCWpD+Vj5AXEgEwP8cakTjXRfgy8=;
	h=Date:To:From:Subject;
	b=DC2qGoMa6VXP1F2hSZE7CjIrpdiB1d5VcR7wks2bNc03q6a/5u8Nvg+sFVq1fFbzy
	 OFpoTQ+sVcN0CLH6ncBMJqAOKr4JGbkV9a18lqwI8zJ2a7fV9ii256B2bgJBVmIpW+
	 tvpgIU28FGGiJ/1Hu3v2o4aAu2uJr9XIIvpjoCMU=
Date: Thu, 17 Sep 2026 22:43:45 -0700
To: mm-commits@vger.kernel.org,yu-cheng.yu@intel.com,vbabka@kernel.org,tglx@linutronix.de,stable@vger.kernel.org,rppt@kernel.org,rick.p.edgecombe@intel.com,pfalcato@suse.de,orsonpeters@gmail.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,dave.hansen@linux.intel.com,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch removed from -mm tree
Message-Id: <20260918054346.05DFE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: fix pmd_modify() dropping the dirty bit
has been removed from the -mm tree.  Its filename was
     x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

(Pedro [1]: "FYI we just had a customer case for our downstream kernel
for this exact same issue.  This fixed it beautifully".)

Link: https://lore.kernel.org/20260903031608.1194238-1-vernon2gm@gmail.com
Link: https://lore.kernel.org/ap6IYeTM8PMinxo-@pedro-suse.tail5790ac.ts.net [1]
Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Orson Peters <orsonpeters@gmail.com>
Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Pedro Falcato <pfalcato@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: <stable@vger.kernel.org>
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

