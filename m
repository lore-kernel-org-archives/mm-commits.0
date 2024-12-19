Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E0D12B169
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577528; cv=none; b=MuPz02nD53V5Xn9n/yLn6QA6ZzXBS1ot64DBBqoUqAgNcGJ/YoB97fzEpZcy0Vek8/o2WZgHyf6rpahJdHKgA1MkkZQfWSE+8DEjcAoBDajO+mbYHr0/SAt6UfmmiO72B4PswnunFgvCt+0lYsN1GstwrG7EeXLT5NC2NvhI6Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577528; c=relaxed/simple;
	bh=vIpw+WY8LWpXQaj2nt4kpLVr9Vj65D4qvdo03bcVo6Y=;
	h=Date:To:From:Subject:Message-Id; b=U9yABZWT3NLchx0KcUfE0CP55s2yMU9yZahSipllPXi0z9ALtzHuXEkFjkRehFrBUw61FHUDCoE5bd1/XuHsPpWs30AuDAmCt0bxotI8gYDolMU+GPWC31i9thR12ZkFaEXhjRpopX0xWWaHhUbeU5k1pWoV67vt3TRxrwgL/fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyYZ7+5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyYZ7+5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F1AC4CECD;
	Thu, 19 Dec 2024 03:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577528;
	bh=vIpw+WY8LWpXQaj2nt4kpLVr9Vj65D4qvdo03bcVo6Y=;
	h=Date:To:From:Subject:From;
	b=iyYZ7+5iwhGSi6mFn6PZpTfRFBLl85geqOnttAkbkXAmoFMZuN3AzbDjruTnfr4Ir
	 72pl4zGPgecHqnpK61GxmJ/NFSMIRsSk3FvIWgJ+TXup4t6k0XLHdgNQf/n7+NNdKG
	 CbNy0SiC2/a6UyYr/mlM+TbMCCWabZC/WDiIYYbU=
Date: Wed, 18 Dec 2024 19:05:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,vgupta@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,mathieu.desnoyers@efficios.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,geert+renesas@glider.be,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch removed from -mm tree
Message-Id: <20241219030528.05F1AC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use clear_user_(high)page() for arch with special user folio handling
has been removed from the -mm tree.  Its filename was
     mm-use-clear_user_highpage-for-arch-with-special-user-folio-handling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: use clear_user_(high)page() for arch with special user folio handling
Date: Mon, 9 Dec 2024 13:23:26 -0500

Some architectures have special handling after clearing user folios:
architectures, which set cpu_dcache_is_aliasing() to true, require
flushing dcache; arc, which sets cpu_icache_is_aliasing() to true, changes
folio->flags to make icache coherent to dcache.  So __GFP_ZERO using only
clear_page() is not enough to zero user folios and clear_user_(high)page()
must be used.  Otherwise, user data will be corrupted.

Fix it by always clearing user folios with clear_user_(high)page() when
cpu_dcache_is_aliasing() is true or cpu_icache_is_aliasing() is true. 
Rename alloc_zeroed() to user_alloc_needs_zeroing() and invert the logic
to clarify its intend.

Link: https://lkml.kernel.org/r/20241209182326.2955963-2-ziy@nvidia.com
Fixes: 5708d96da20b ("mm: avoid zeroing user movable page twice with init_on_alloc=1")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdV1hRp_NtR5YnJo=HsfgKQeH91J537Gh4gKk3PFZhSkbA@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    8 +++++++-
 include/linux/mm.h      |   18 ++++++++++++++++++
 mm/huge_memory.c        |    9 +++++----
 mm/internal.h           |    6 ------
 mm/memory.c             |   10 +++++-----
 5 files changed, 35 insertions(+), 16 deletions(-)

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
+	if (folio && user_alloc_needs_zeroing())
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
@@ -4184,6 +4185,23 @@ static inline int do_mseal(unsigned long
 }
 #endif
 
+/*
+ * user_alloc_needs_zeroing checks if a user folio from page allocator needs to
+ * be zeroed or not.
+ */
+static inline bool user_alloc_needs_zeroing(void)
+{
+	/*
+	 * for user folios, arch with cache aliasing requires cache flush and
+	 * arc changes folio->flags to make icache coherent with dcache, so
+	 * always return false to make caller use
+	 * clear_user_page()/clear_user_highpage().
+	 */
+	return cpu_dcache_is_aliasing() || cpu_icache_is_aliasing() ||
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
+	if (user_alloc_needs_zeroing())
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
+			if (user_alloc_needs_zeroing())
 				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are


