Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D4A4B403F;
	Sat, 10 Oct 2026 19:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791659548; cv=none; b=fLbgNxsFJVKFntpHOXxPPLgC6bsdu2OxUedoChywNOD3ep7sC4Kq3RmL+SvY+w7aiyHryuoOFforjB5NRe5T5aY5ImPeM1rF7HVJdopMMWWZC3F/lioGZrx1W4G8MBaNRQ2xBIwoaMNWz31JWQMk8E8TBV780GNjEc7PaIJztp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791659548; c=relaxed/simple;
	bh=i2R1j87DdvdPm5zzCUiB/kLw2ooEOUJv41YBgQUtgfw=;
	h=Date:To:From:Subject:Message-Id; b=ZHchhMw94ObYvL3xDUU3pvQWLwZ+xPde6436u9e1XP91vxrxe42RIHIIP5ozMrMclpk1qRbmR3bgIZKotgS4XogFlscrBT3DYOUdxBSACCr36yN50d85Hg22SN4OvOztRiHVMv8YMqiK95URRWSIuhCd/YTv96TtdBGmH9pATvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vHo/K5E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vHo/K5E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F051F000FF;
	Sat, 10 Oct 2026 19:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791659546;
	bh=MENVa0NuinOwz5GuUefqGmQRI48AhugaEkeulW8O1i4=;
	h=Date:To:From:Subject;
	b=vHo/K5E3BxLjb/XEwHAQUGYKorYz1RPKZKHiyCjIOBjzc/Vwq8rl6hZnCx20Yf5Oo
	 IOXbTGo8b1S97kkfRUtyqBK3CBILBy/AH3uSFeqLG6GTCM4IDxYp/3+lre2xupCnye
	 DmGLpRBUmk+PYvN6RzMbssAfmUIjKaqou7s2ffls=
Date: Sat, 10 Oct 2026 12:12:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,bjorn@rivosinc.com,apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-missing-page-table-destructor-in-pagetable_free.patch added to mm-unstable branch
Message-Id: <20261010191226.13F051F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix missing page-table destructor in pagetable_free()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-missing-page-table-destructor-in-pagetable_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-missing-page-table-destructor-in-pagetable_free.patch

This patch will later appear in the mm-unstable branch at
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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: fix missing page-table destructor in pagetable_free()
Date: Sat, 10 Oct 2026 19:24:54 +0800

Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
tables.

HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
splitting a PMD. Restoring the vmemmap backing pages does not collapse
the PTE table, so a later memory hot-remove eventually frees it through
pagetable_free() on x86-64. That releases the page without running the
matching destructor and leaves NR_PAGETABLE elevated.

Make pagetable_free() detect constructor-backed pages and run the
destructor before releasing their memory to fix the problem.

Link: https://lore.kernel.org/20261010112457.49485-2-songmuchun@bytedance.com
Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 include/linux/mm.h |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-fix-missing-page-table-destructor-in-pagetable_free
+++ a/include/linux/mm.h
@@ -3969,23 +3969,6 @@ static inline void pagetable_free_kernel
 	__pagetable_free(pt);
 }
 #endif
-/**
- * pagetable_free - Free pagetables
- * @pt:	The page table descriptor
- *
- * pagetable_free frees the memory of all page tables described by a page
- * table descriptor and the memory for the descriptor itself.
- */
-static inline void pagetable_free(struct ptdesc *pt)
-{
-	if (ptdesc_test_kernel(pt)) {
-		ptdesc_clear_kernel(pt);
-		pagetable_free_kernel(pt);
-	} else {
-		__pagetable_free(pt);
-	}
-}
-
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
 #if ALLOC_SPLIT_PTLOCKS
 void __init ptlock_cache_init(void);
@@ -4078,6 +4061,26 @@ static inline void pagetable_dtor(struct
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+/**
+ * pagetable_free - Free pagetables
+ * @pt:	The page table descriptor
+ *
+ * pagetable_free frees the memory of all page tables described by a page
+ * table descriptor and the memory for the descriptor itself.
+ */
+static inline void pagetable_free(struct ptdesc *pt)
+{
+	if (PageTable(ptdesc_page(pt)))
+		pagetable_dtor(pt);
+
+	if (ptdesc_test_kernel(pt)) {
+		ptdesc_clear_kernel(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
+}
+
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
 {
 	pagetable_dtor(ptdesc);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

