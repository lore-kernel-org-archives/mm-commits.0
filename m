Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5C523ABAA
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773159888; cv=none; b=mLcBYwuqNu5vM4OD66EP3Xo6DLV1oXivUki6izs0j4Xu2ca9FrkEuroBNOxv50zgeYHEDSfdAduWnkdBNRebk65v7iZ6+ZaKpPrZJ2VjcMG9zkQbxhQ4bEQNaT6uMIqmusVUJkah8BYhmRJn1EMxPD1Yv9l03ffsUlfg7HO7NIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773159888; c=relaxed/simple;
	bh=fGsLSHMLbgXJ+0lVJVtK9vTpzqsZb9wypjAr+xr2pQg=;
	h=Date:To:From:Subject:Message-Id; b=exLNrsuL5FfSY9aKVSl2NE8L8eJkQh56bmnA1OOGE6C5xxKRShmbm1Vni0NYUukZrCjd2fyCKoVPZ5kpD6NMUXCP4+4P+a8mLIBNtLZr1d9BnAaOeRStIBXwgx5WDoB/WBcVaz1jZVmr5NOsPZbjRwK3qeo2DFGPqyEkqY+BtG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F+xlRxMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F+xlRxMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA1C19423;
	Tue, 10 Mar 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773159888;
	bh=fGsLSHMLbgXJ+0lVJVtK9vTpzqsZb9wypjAr+xr2pQg=;
	h=Date:To:From:Subject:From;
	b=F+xlRxMX8kcld1pG72IUv46+3L3LuXPnsxkGk4CVyLcyXEwPqt0vuUTrMgf7DhXuk
	 R9E514u41Js+yicTZoq+xY+oWyQYXalIFsQ/HHF+EsCmb3OFDswdtam1SRWCVuCEKw
	 wzrO8Hl84oPg7k5uozT3KqWdukysmwa+78zhGQ3w=
Date: Tue, 10 Mar 2026 09:24:47 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,rppt@kernel.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,wangruikang@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-patch-avoid-early-page_to_phys.patch added to mm-hotfixes-unstable branch
Message-Id: <20260310162448.27AA1C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: avoid early page_to_phys()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-patch-avoid-early-page_to_phys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-patch-avoid-early-page_to_phys.patch

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
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: riscv: avoid early page_to_phys()
Date: Tue, 10 Mar 2026 16:25:33 +0800

Similarly to commit 8d09e2d569f6 ("arm64: patching: avoid early
page_to_phys()"), avoid using phys_to_page() for the kernel address case
in patch_map().

Since this is called from apply_boot_alternatives() in setup_arch(), and
commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE
memory model") has moved sparse_init() to after setup_arch(),
phys_to_page() is not available there yet, and it panics on boot with
SPARSEMEM on RV32, which does not use SPARSEMEM_VMEMMAP.

Link: https://lkml.kernel.org/r/20260310-riscv-sparsemem-alternatives-fix-v1-1-659d5dd257e2@iscas.ac.cn
Fixes: 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memory model")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Reported-by: Thomas Wei√üschuh <thomas.weissschuh@linutronix.de>
Closes: https://lore.kernel.org/r/20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de/
Suggested-by: Mike Rapoport <rppt@kernel.org>
Tested-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/patch.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/arch/riscv/kernel/patch.c~riscv-patch-avoid-early-page_to_phys
+++ a/arch/riscv/kernel/patch.c
@@ -42,19 +42,20 @@ static inline bool is_kernel_exittext(ui
 static __always_inline void *patch_map(void *addr, const unsigned int fixmap)
 {
 	uintptr_t uintaddr = (uintptr_t) addr;
-	struct page *page;
+	phys_addr_t phys;
 
-	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
-		page = phys_to_page(__pa_symbol(addr));
-	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
-		page = vmalloc_to_page(addr);
-	else
-		return addr;
+	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
+		phys = __pa_symbol(addr);
+	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
+		struct page *page = vmalloc_to_page(addr);
 
-	BUG_ON(!page);
+		BUG_ON(!page);
+		phys = page_to_phys(page) + offset_in_page(addr);
+	} else {
+		return addr;
+	}
 
-	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) +
-					 offset_in_page(addr));
+	return (void *)set_fixmap_offset(fixmap, phys);
 }
 
 static void patch_unmap(int fixmap)
_

Patches currently in -mm which might be from wangruikang@iscas.ac.cn are

riscv-patch-avoid-early-page_to_phys.patch

