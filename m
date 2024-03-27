Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D215250C
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567556; cv=none; b=s0HLeZ9X6n7VQhQst/kMKggNRIdLTYXmv447wTeQ82lJJqx0vL8ryJtOMY1zD0+soYR7YNZPmZ70JJ9wOGMXpKQRioPDgnGZr0SefDsBRrSuiwPin4S0FCwKbvWGAr2OIaMiEkkEolpuMgyUCInzqD5hWTsBI/kzVQpsPBr6J2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567556; c=relaxed/simple;
	bh=wm07lY0dXY9CGrRD96La/RsGigoBz4kKT4IjS0pk5pc=;
	h=Date:To:From:Subject:Message-Id; b=OJU5sQQKpo73/RFBU+ddp2PrXtGDeyJqZ9MAdLiIviisZ/WqlQIUOd0ZdFKqDUS7oXeuJPuFamJUsE0LXZPIzyLUn4O9TuFsGFgfnL5cQKzmhPkl3YYgM6cZp/rtdOsyvSeoBx1hKgZYvU1nUAi30d6XugBwND21C51L8sAkhno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axMr3XPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axMr3XPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EF1C43390;
	Wed, 27 Mar 2024 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567555;
	bh=wm07lY0dXY9CGrRD96La/RsGigoBz4kKT4IjS0pk5pc=;
	h=Date:To:From:Subject:From;
	b=axMr3XPmzDQsnetQLrXI2la+Lh52HurvTWtVkEgwTz1QIiYVpO6e8ElXjEoASKeh+
	 rS+MiHlNXK/b6FCXUkru0H3KK+j+1gf/0ToQ6wZDgWevz0j5HJmMYJ9ADDc7A0Cpvn
	 lWsx8fL1FkcBl9Plc1RnHmo4lswGZHyDmAHq9qGA=
Date: Wed, 27 Mar 2024 12:25:54 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20240327192555.75EF1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix
Date: Wed, 27 Mar 2024 14:37:40 +0000

fix arm64 build

Link: https://lkml.kernel.org/r/ZgQvNKGdlDkwhQEX@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix
+++ a/include/linux/hugetlb.h
@@ -836,7 +836,7 @@ static inline int is_hugepage_only_range
 #define is_hugepage_only_range is_hugepage_only_range
 #endif
 
-#ifndef arch_clear_hugepage_flags
+#ifndef arch_clear_hugetlb_flags
 static inline void arch_clear_hugetlb_flags(struct folio *folio) { }
 #define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 #endif
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch

