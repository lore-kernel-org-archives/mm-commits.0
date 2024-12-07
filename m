Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72217557
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 05:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733551020; cv=none; b=scqr31DYte2PHV3B4dKPLHNI+/9lnW41XCQG6oBP6FQDsWXtBQ+wE4DN63e6iecmQkw2uliDrwxWhPlCnxD78mLycEgseFSHUJXT05en16GQjVcCGAMW9G9At3jZhb0apUl5RVMvMsDZcHEWbbUBelG3RXHuVAEr81Jwu1R8O0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733551020; c=relaxed/simple;
	bh=QEZwiQNFDGIors93vyxvGdAMNoEzUJC+9S6cNf53nWY=;
	h=Date:To:From:Subject:Message-Id; b=RZZbrs3+hirXkjaCVOwfbf6zNNQIrztRO8ZfqkbsilTykXdwf5ArFJ33uOXcOuq0s9Dm2Q4jamdJwI4fktIZYXKurGK5u6bsG3kskTA42MhKX6DDGpOV0TGS87BCsqSP9wU2+2IWQc+o3mJppH2i0pwysiUvESKiJMR+AdvWdeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J93Rwg3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J93Rwg3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BD8C4CECD;
	Sat,  7 Dec 2024 05:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733551019;
	bh=QEZwiQNFDGIors93vyxvGdAMNoEzUJC+9S6cNf53nWY=;
	h=Date:To:From:Subject:From;
	b=J93Rwg3WEVTS+QbnUWs/cLnP6biu9zLoswVJ/0OksyNB651tqsaB2QlWF0EGcy+9a
	 xhd86A+KsBTLZ+Mvnn9B6Bcx8LHgs6oWKvyzPeFJG7Nf9517PL6yEYql1ASNVvltjF
	 d+calkbe2zHJiD0xTFxzSOyWYNc/tiYQXLX88+Rk=
Date: Fri, 06 Dec 2024 21:56:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,vgupta@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,mathieu.desnoyers@efficios.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,geert+renesas@glider.be,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20241207055659.A4BD8C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use clear_user_(high)page() for arch with special user folio handling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: use clear_user_(high)page() for arch with special user folio handling
Date: Fri, 6 Dec 2024 12:42:46 -0500

For architectures setting cpu_dcache_is_aliasing() to true, which require
flushing cache, and arc, which changes folio->flags after clearing a user
folio, __GFP_ZERO using only clear_page() is not enough to zero user
folios and clear_user_(high)page() must be used.  Otherwise, user data
will be corrupted.

Fix it by always clearing user folios with clear_user_(high)page() when
cpu_dcache_is_aliasing() is true or architecture is arc.  Rename
alloc_zeroed() to alloc_need_zeroing() and invert the logic to clarify its
intend.

Link: https://lkml.kernel.org/r/20241206174246.2799715-1-ziy@nvidia.com
Fixes: 5708d96da20b ("mm: avoid zeroing user movable page twice with init_on_alloc=1")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdV1hRp_NtR5YnJo=HsfgKQeH91J537Gh4gKk3PFZhSkbA@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    8 +++++++-
 include/linux/mm.h      |   17 +++++++++++++++++
 mm/huge_memory.c        |    9 +++++----
 mm/internal.h           |    6 ------
 mm/memory.c             |   10 +++++-----
 5 files changed, 34 insertions(+), 16 deletions(-)

--- a/include/linux/highmem.h~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
+++ a/include/linux/highmem.h
@@ -224,7 +224,13 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr);
+	struct folio *folio;
+
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
+	if (folio && alloc_need_zeroing())
+		clear_user_highpage(&folio->page, vaddr);
+
+	return folio;
 }
 #endif
 
--- a/include/linux/mm.h~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
+++ a/include/linux/mm.h
@@ -31,6 +31,7 @@
 #include <linux/kasan.h>
 #include <linux/memremap.h>
 #include <linux/slab.h>
+#include <linux/cacheinfo.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -4197,6 +4198,22 @@ static inline int do_mseal(unsigned long
 }
 #endif
 
+/*
+ * alloc_need_zeroing checks if a user folio from page allocator needs to be
+ * zeroed or not.
+ */
+static inline bool alloc_need_zeroing(void)
+{
+	/*
+	 * for user folios, arch with cache aliasing requires cache flush and
+	 * arc changes folio->flags, so always return false to make caller use
+	 * clear_user_page()/clear_user_highpage()
+	 */
+	return (cpu_dcache_is_aliasing() || IS_ENABLED(CONFIG_ARC)) ||
+	       !static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				   &init_on_alloc);
+}
+
 int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status);
 int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status);
 int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
--- a/mm/huge_memory.c~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
+++ a/mm/huge_memory.c
@@ -1176,11 +1176,12 @@ static struct folio *vma_alloc_anon_foli
 	folio_throttle_swaprate(folio, gfp);
 
        /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used),
-	* folio_zero_user() is used to make sure that the page corresponding
-	* to the faulting address will be hot in the cache after zeroing.
+	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
+	* or user folios require special handling, folio_zero_user() is used to
+	* make sure that the page corresponding to the faulting address will be
+	* hot in the cache after zeroing.
 	*/
-	if (!alloc_zeroed())
+	if (alloc_need_zeroing())
 		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
--- a/mm/internal.h~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
+++ a/mm/internal.h
@@ -1285,12 +1285,6 @@ void touch_pud(struct vm_area_struct *vm
 void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	       pmd_t *pmd, bool write);
 
-static inline bool alloc_zeroed(void)
-{
-	return static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
-			&init_on_alloc);
-}
-
 /*
  * Parses a string with mem suffixes into its order. Useful to parse kernel
  * parameters.
--- a/mm/memory.c~mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling
+++ a/mm/memory.c
@@ -4733,12 +4733,12 @@ static struct folio *alloc_anon_folio(st
 			folio_throttle_swaprate(folio, gfp);
 			/*
 			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used), folio_zero_user() is used
-			 * to make sure that the page corresponding to the
-			 * faulting address will be hot in the cache after
-			 * zeroing.
+			 * (__GFP_ZERO not used) or user folios require special
+			 * handling, folio_zero_user() is used to make sure
+			 * that the page corresponding to the faulting address
+			 * will be hot in the cache after zeroing.
 			 */
-			if (!alloc_zeroed())
+			if (alloc_need_zeroing())
 				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch

