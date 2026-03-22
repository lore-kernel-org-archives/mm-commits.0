Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0085B2E9EC7
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 00:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139853; cv=none; b=J1D8XLkhTEyYrbfGwrogWyekVmrRftUZ/OkuecgVn4qyVyi4KxW0mCbQcDDJLXzoY6CFMIwr4SiwZRYauctf5iLw1wbHsClwKRHbLMPdSKyJnpPdgF2jpyb1Xol963pXKmQJnoSDVZgVjjVRUem4LnKtNxfwMy3qbjCv9UuoBHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139853; c=relaxed/simple;
	bh=Qwo29qbQaWopKQnJjGg4y3zoXAi0n3wB05lghJbKIdY=;
	h=Date:To:From:Subject:Message-Id; b=dHKykEYrXpiXHFIfBE5UQSsZLwdLobfFLOA2DZ1gFBL7zU9UJdrYY+nhF3voGTXAa9o8QI9uxk1fd7U7kcM3B/IuhlcxuHQ9mIgLIqfkZfPeTsWvX2p9MMEYFt6xWXGXJq4usdxxlFIXIvbSs3WD3oJM9sZVTFtbPkJ8KTJncFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qYTe42ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qYTe42ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E1CC19421;
	Sun, 22 Mar 2026 00:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139852;
	bh=Qwo29qbQaWopKQnJjGg4y3zoXAi0n3wB05lghJbKIdY=;
	h=Date:To:From:Subject:From;
	b=qYTe42ssXSGFcsXDA12YjjHPuNR/v2rzO75bop2K1re5Mpg433uCyDD5qE4tj6I24
	 Bfra8KHoLXzCQ4BGxsovYRh1PUvifjUSKjwKem/c8TTPV7YoJvlxTke7m/qG+1k8ap
	 s6dySI26/KV06GWka+H+b521VLp0cNE6JBM+6qcI=
Date: Sat, 21 Mar 2026 17:37:31 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,rppt@kernel.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,wangruikang@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-patch-avoid-early-page_to_phys.patch removed from -mm tree
Message-Id: <20260322003732.85E1CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: avoid early page_to_phys()
has been removed from the -mm tree.  Its filename was
     riscv-patch-avoid-early-page_to_phys.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reported-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Closes: https://lore.kernel.org/r/20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de/
Suggested-by: Mike Rapoport <rppt@kernel.org>
Tested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
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


