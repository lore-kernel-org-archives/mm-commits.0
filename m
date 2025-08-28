Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E718713DDAA
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 05:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359980; cv=none; b=DwCKUZG9E6mC+PqH10Aexdv/PiESPkXKmmSGtERXHc5vCBsUjk9m7QpSxthRGEKWYVImEIsC/RZsms8sE0WG6hYIE3WC46Mmj5AWE5Bap0rW7VjDjHfeHlpYqSI60/SxjVqFEr5GEg4onmoA0Jnj3yTpDX9SozVRbT4+b2x37Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359980; c=relaxed/simple;
	bh=sB090COv+fET80TtdIjwybJePGRH6bWtIIniF9YyX0A=;
	h=Date:To:From:Subject:Message-Id; b=Nmfp61XmTnaiAmre9oW3wdluy68VLak1a02oDbW4PY2RubnB15d+YHyELZ7AR2wQnL0GNLRYKAIMvUQv0eWyXNJZYlOyq4NHY4Jy7fzCoEqQuOKyHHLgK8hl0zLO3xk0FCOf++LOSqHHFV8Totv3VmETpV5FpQVdRNBgYJWcvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bLcSQ80o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bLcSQ80o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0060C4CEEB;
	Thu, 28 Aug 2025 05:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359979;
	bh=sB090COv+fET80TtdIjwybJePGRH6bWtIIniF9YyX0A=;
	h=Date:To:From:Subject:From;
	b=bLcSQ80o7W9dj+GwfivHHfV7iKT/9oNkQK4jTWl6vemDX4BtkQPZXo+8MwczWi0OL
	 RAJ3YSLfmgymPyygrFLrIbAEa7rgvgyEMP8L10jdi3mvY89fx6mGDVUvYWVUmoEXl4
	 k8/a0BmdE++jrZGOa+9TAfsRpDG20PggxIXFUm9Y=
Date: Wed, 27 Aug 2025 22:46:18 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,dja@axtens.net,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kasan-avoid-lazy-mmu-mode-hazards.patch removed from -mm tree
Message-Id: <20250828054619.A0060C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan: avoid lazy MMU mode hazards
has been removed from the -mm tree.  Its filename was
     mm-kasan-avoid-lazy-mmu-mode-hazards.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/kasan: avoid lazy MMU mode hazards
Date: Mon, 18 Aug 2025 18:39:13 +0200

Functions __kasan_populate_vmalloc() and __kasan_depopulate_vmalloc() use
apply_to_pte_range(), which enters lazy MMU mode.  In that mode updating
PTEs may not be observed until the mode is left.

That may lead to a situation in which otherwise correct reads and writes
to a PTE using ptep_get(), set_pte(), pte_clear() and other access
primitives bring wrong results when the vmalloc shadow memory is being
(de-)populated.

To avoid these hazards leave the lazy MMU mode before and re-enter it
after each PTE manipulation.

Link: https://lkml.kernel.org/r/0d2efb7ddddbff6b288fbffeeb10166e90771718.1755528662.git.agordeev@linux.ibm.com
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/kasan/shadow.c~mm-kasan-avoid-lazy-mmu-mode-hazards
+++ a/mm/kasan/shadow.c
@@ -305,6 +305,8 @@ static int kasan_populate_vmalloc_pte(pt
 	pte_t pte;
 	int index;
 
+	arch_leave_lazy_mmu_mode();
+
 	index = PFN_DOWN(addr - data->start);
 	page = data->pages[index];
 	__memset(page_to_virt(page), KASAN_VMALLOC_INVALID, PAGE_SIZE);
@@ -317,6 +319,8 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
+	arch_enter_lazy_mmu_mode();
+
 	return 0;
 }
 
@@ -461,6 +465,8 @@ static int kasan_depopulate_vmalloc_pte(
 	pte_t pte;
 	int none;
 
+	arch_leave_lazy_mmu_mode();
+
 	spin_lock(&init_mm.page_table_lock);
 	pte = ptep_get(ptep);
 	none = pte_none(pte);
@@ -471,6 +477,8 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
+	arch_enter_lazy_mmu_mode();
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


