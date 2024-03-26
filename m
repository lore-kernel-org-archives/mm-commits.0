Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67998127B4D
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477818; cv=none; b=IwRClPEUAy72HGBF4JSkiGVy26A8OHFqMSa5ftzhFGABKY72oSiSCgxn95i8+b8AbpCNyprzLeGkiXhge1odQdBuvMNsTstMRUczRZ8Pu69n4zWt6Mfy9RCEA8IlauW07QWrl7Z9ioDoW6AX1NXk8OJP2pz7N7BbZJw9PnqleaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477818; c=relaxed/simple;
	bh=z/p5bhulQh2E8tNtZiiWeMdFfzVj2o/3sF0Badkrw3Y=;
	h=Date:To:From:Subject:Message-Id; b=CwBukgZa9uwV043WkGfhk1kdSQPn+1lv15CDUp4hmIN0lBQCyKB8wV71ZUabEgiaJrmJfWJhl213iaDnmblsN9ZPox7wOumK2nEsobYDWlTFKvftDEyJYyRvL6+8Lu/ax0MI9CfOYJT/FROsJ69cYyXl6EMeK57JO7rOP62s8yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ipSfJPD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ipSfJPD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B1EC433C7;
	Tue, 26 Mar 2024 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477818;
	bh=z/p5bhulQh2E8tNtZiiWeMdFfzVj2o/3sF0Badkrw3Y=;
	h=Date:To:From:Subject:From;
	b=ipSfJPD70lxYK8yT3N7ykuolw4BQOCr/lx9XBksQQZeTD6/7Q/g2G+HViYtx6jbgv
	 k1HHmxsdO6JbAw+nbYfSyyuV2ZE5mYz5nEwHHVvtM3AvVijunjGZbS6NPgeSOkb+21
	 NVYaKMkxpgXoKXZYAtjCjyb1j3r3wE3NBkUl8BJo=
Date: Tue, 26 Mar 2024 11:30:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-is_free_buddy_page-take-a-const-argument.patch added to mm-unstable branch
Message-Id: <20240326183017.E4B1EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make is_free_buddy_page() take a const argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-is_free_buddy_page-take-a-const-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-is_free_buddy_page-take-a-const-argument.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make is_free_buddy_page() take a const argument
Date: Tue, 26 Mar 2024 17:10:27 +0000

This function does not modify its argument; let the callers know that so
they can make better optimisation decisions.

Link: https://lkml.kernel.org/r/20240326171045.410737-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 mm/page_alloc.c            |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/page-flags.h~mm-make-is_free_buddy_page-take-a-const-argument
+++ a/include/linux/page-flags.h
@@ -1088,7 +1088,7 @@ static inline bool is_page_hwpoison(cons
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-extern bool is_free_buddy_page(struct page *page);
+bool is_free_buddy_page(const struct page *page);
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
 
--- a/mm/page_alloc.c~mm-make-is_free_buddy_page-take-a-const-argument
+++ a/mm/page_alloc.c
@@ -6750,16 +6750,16 @@ void __offline_isolated_pages(unsigned l
 /*
  * This function returns a stable result only if called under zone lock.
  */
-bool is_free_buddy_page(struct page *page)
+bool is_free_buddy_page(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	unsigned int order;
 
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
-		struct page *page_head = page - (pfn & ((1 << order) - 1));
+		const struct page *head = page - (pfn & ((1 << order) - 1));
 
-		if (PageBuddy(page_head) &&
-		    buddy_order_unsafe(page_head) >= order)
+		if (PageBuddy(head) &&
+		    buddy_order_unsafe(head) >= order)
 			break;
 	}
 
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
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch

