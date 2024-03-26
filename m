Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0865E1272DC
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477814; cv=none; b=IfmdK4o/Y6OSTIzuCYsRm0ekgpslt17+oXVMPoUAnPBrOmrYhSC5I66T1uvymlKlyc1sYIc7IYp6x6A023z+A8C5GoWJVOTSb0Swo+PVrh1RtP43/pvmerZK6IIc/vBVWDnS3i0s1WH19QcuIkVWoZl3YwyeLEj7LaAP6b+tCu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477814; c=relaxed/simple;
	bh=GHk1kSd9QtpH0V1nCVjDHwFz2cqrb3e2AEjU0VP0npA=;
	h=Date:To:From:Subject:Message-Id; b=l0i98BVhtK5gi9+nMzWooUNyYZrngYsDg5c9F0/e2Ld00vENAsd01U9zdLN65KmVsrksWqfh7xYNiFe0TB6JfUe6wF8X/gtyZnyjJ2dX5FHxDEQ+VtdoSxQroQSFfghq1ZGqxbudjZ9MqJ2kis9UCRKhdExOwHTQ25rXcn02yp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fogYBGg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fogYBGg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B293EC433F1;
	Tue, 26 Mar 2024 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477813;
	bh=GHk1kSd9QtpH0V1nCVjDHwFz2cqrb3e2AEjU0VP0npA=;
	h=Date:To:From:Subject:From;
	b=fogYBGg4/JkZ/mb3W32Zx70Zz0kIAZB6xuCaIaUtROUjubebl7Rw0x9xHN1W9zrtm
	 4BBGFXWqgxpC3Do6bflwqJLeBcNiwUWTYmF3pVX+6Rt/bpFAyX0jpU7oa7LzhS6SF+
	 71VEdmKjAyPXLLOA9E1UIc4Hcv8VsCh7uArZmb5g=
Date: Tue, 26 Mar 2024 11:30:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-page_ext_get-take-a-const-argument.patch added to mm-unstable branch
Message-Id: <20240326183013.B293EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make page_ext_get() take a const argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-page_ext_get-take-a-const-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-page_ext_get-take-a-const-argument.patch

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
Subject: mm: make page_ext_get() take a const argument
Date: Tue, 26 Mar 2024 17:10:25 +0000

In order to constify other functions, we need page_ext_get() to be const. 
This is no problem as lookup_page_ext() already takes a const argument.

Link: https://lkml.kernel.org/r/20240326171045.410737-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h    |    4 ++--
 include/linux/pgalloc_tag.h |    2 --
 mm/page_ext.c               |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/page_ext.h~mm-make-page_ext_get-take-a-const-argument
+++ a/include/linux/page_ext.h
@@ -77,7 +77,7 @@ static inline void page_ext_init(void)
 }
 #endif
 
-extern struct page_ext *page_ext_get(struct page *page);
+extern struct page_ext *page_ext_get(const struct page *page);
 extern void page_ext_put(struct page_ext *page_ext);
 
 static inline void *page_ext_data(struct page_ext *page_ext,
@@ -117,7 +117,7 @@ static inline void page_ext_init_flatmem
 {
 }
 
-static inline struct page_ext *page_ext_get(struct page *page)
+static inline struct page_ext *page_ext_get(const struct page *page)
 {
 	return NULL;
 }
--- a/include/linux/pgalloc_tag.h~mm-make-page_ext_get-take-a-const-argument
+++ a/include/linux/pgalloc_tag.h
@@ -12,8 +12,6 @@
 #include <linux/page_ext.h>
 
 extern struct page_ext_operations page_alloc_tagging_ops;
-extern struct page_ext *page_ext_get(struct page *page);
-extern void page_ext_put(struct page_ext *page_ext);
 
 static inline union codetag_ref *codetag_ref_from_page_ext(struct page_ext *page_ext)
 {
--- a/mm/page_ext.c~mm-make-page_ext_get-take-a-const-argument
+++ a/mm/page_ext.c
@@ -514,7 +514,7 @@ void __meminit pgdat_page_ext_init(struc
  * Context: Any context.  Caller may not sleep until they have called
  * page_ext_put().
  */
-struct page_ext *page_ext_get(struct page *page)
+struct page_ext *page_ext_get(const struct page *page)
 {
 	struct page_ext *page_ext;
 
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

