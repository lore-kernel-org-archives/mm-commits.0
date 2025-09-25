Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43262ECE8F
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 23:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841872; cv=none; b=GNvqlJw4vJEWSxUg+TfWoZmR6fdo0A7CtVmAH2XTqvYNgbKcKcQov/cZXKxFSW7Um7cA6+BF8TntlQmWnFQ3LlEnbHZhA7phpOTojV3e4sLMLCLUPuAldLZDbkmGr7G41BMLymQzqSzOgyJQGyjpMpjfuTEwh9cisgFCQeUDvXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841872; c=relaxed/simple;
	bh=hFkkz45Fn7D9MO8wt2RWe0NKozAeWkQhBniutNyUnPE=;
	h=Date:To:From:Subject:Message-Id; b=jCYNuW1RvGkIq6KotZu1K1aLfE4X6GDNfmEKOldIiABPjC3104+WRuOFv58Xq8b63+CHr5eNnBButpfT3tUZU4es9xzODhMBSHgw/HX8EMMrPeYtw+dYkFmgp8EJYVbqOZsXqgUzEEKNzIEcYBGBdRB1MGXo2qrXCQz0M98VtME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JkiJimJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JkiJimJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7FDC4CEF0;
	Thu, 25 Sep 2025 23:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841872;
	bh=hFkkz45Fn7D9MO8wt2RWe0NKozAeWkQhBniutNyUnPE=;
	h=Date:To:From:Subject:From;
	b=2JkiJimJhNQfXYJ9KfOtSm/T6ID0trUfXkKDj5hOosRpEmxg5dQVf7FwXvKMc7IlL
	 2ZgiNBp/3P8g033c24f6ELXKopiodu0tKl1jYqx6r5sWAhckdjM5ZfWH5GoAtu1N+W
	 X47W3+e3PKohAhqmsH5YdP10yn3teXaohL75IBGs=
Date: Thu, 25 Sep 2025 16:11:12 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,balbirs@nvidia.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch removed from -mm tree
Message-Id: <20250925231112.7F7FDC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
has been removed from the -mm tree.  Its filename was
     include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
Date: Sat Sep 13 05:03:39 PM PDT 2025

commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
the use of arch_enter_lazy_mmu_mode(), which results in the compiler
complaining about "statement has no effect", when
__HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h

The exact warning/error is:

In file included from ./include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function kasan_populate_vmalloc_pte:
./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro arch_enter_lazy_mmu_mode>   322 |         arch_enter_lazy_mmu_mode();
     |         ^~~~~~~~~~~~~~~~~~~~~~~~

switching these "functions" to static inlines fixes this up.

Fixes: c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") 
Reported-by: Balbir Singh <balbirs@nvidia.com>
Closes: https://lkml.kernel.org/r/20250912235515.367061-1-balbirs@nvidia.com
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines
+++ a/include/linux/pgtable.h
@@ -232,9 +232,9 @@ static inline int pmd_dirty(pmd_t pmd)
  * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
+static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_leave_lazy_mmu_mode(void) {}
+static inline void arch_flush_lazy_mmu_mode(void) {}
 #endif
 
 #ifndef pte_batch_hint
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

