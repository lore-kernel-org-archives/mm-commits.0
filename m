Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7246F282E5;
	Tue, 13 Aug 2024 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574402; cv=none; b=ltCznQwHTDXLBQJJU/RranxhhJ6ax/MvtRyNpC9aUhWDYhnb8l2OYsh2jffWFtTIyr8RPMMlXtYBZZEtU1d2ooyX5ekai2/HTF+KMYCzov4lm4REOrnVNv0tEqZHHcotF6dKiFiBvKaH+MWDG+QZFhfXW+Z1s8NCKuIQHfvIxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574402; c=relaxed/simple;
	bh=v/TW6f1k3Ldsvi4N6VGGYGUfNGU1IEq4UwmGknqthzU=;
	h=Date:To:From:Subject:Message-Id; b=ZnlAgBukMV5t3ajbH5Ct/WzE37teRRTgvnL8LspmlOyd1fF2mGLoV7SjlM4AaIajyDhmm01Nd3xl7AWyunngnMRdru1ZQWpfvFAxteqrWFLsvf6a/x6uH44WlP5tO2qN4r6eAa+GakbySy321McX9YYBToYD+36iP3Kpi3jxLi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BVW68rCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BVW68rCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27C8C32782;
	Tue, 13 Aug 2024 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723574402;
	bh=v/TW6f1k3Ldsvi4N6VGGYGUfNGU1IEq4UwmGknqthzU=;
	h=Date:To:From:Subject:From;
	b=BVW68rCqTTzn0qhErHm4EVWQfwD9/+OPiGJQi3hxOJW9xCQphkSbrZbiKM4WEhj90
	 r8xIkUtE/G1iB1VWymqPs8hTb8EFTZUtsewj9/UVNWrJt/9V+AlhJ6gpquEHiKAcBu
	 UAeeNKqnp9y/MdfH4fkiM4NemFaWLRJ2DJIvWDpw=
Date: Tue, 13 Aug 2024 11:40:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-introduce-clear_page_tag_ref-helper-function.patch added to mm-hotfixes-unstable branch
Message-Id: <20240813184001.E27C8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: introduce clear_page_tag_ref() helper function
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-introduce-clear_page_tag_ref-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-introduce-clear_page_tag_ref-helper-function.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: introduce clear_page_tag_ref() helper function
Date: Tue, 13 Aug 2024 08:07:56 -0700

In several cases we are freeing pages which were not allocated using
common page allocators.  For such cases, in order to keep allocation
accounting correct, we should clear the page tag to indicate that the page
being freed is expected to not have a valid allocation tag.  Introduce
clear_page_tag_ref() helper function to be used for this.

Link: https://lkml.kernel.org/r/20240813150758.855881-1-surenb@google.com
Fixes: d224eb0287fb ("codetag: debug: mark codetags for reserved pages as empty")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |   13 +++++++++++++
 mm/mm_init.c                |   10 +---------
 mm/page_alloc.c             |    9 +--------
 3 files changed, 15 insertions(+), 17 deletions(-)

--- a/include/linux/pgalloc_tag.h~alloc_tag-introduce-clear_page_tag_ref-helper-function
+++ a/include/linux/pgalloc_tag.h
@@ -43,6 +43,18 @@ static inline void put_page_tag_ref(unio
 	page_ext_put(page_ext_from_codetag_ref(ref));
 }
 
+static inline void clear_page_tag_ref(struct page *page)
+{
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			set_codetag_empty(ref);
+			put_page_tag_ref(ref);
+		}
+	}
+}
+
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr)
 {
@@ -126,6 +138,7 @@ static inline void pgalloc_tag_sub_pages
 
 static inline union codetag_ref *get_page_tag_ref(struct page *page) { return NULL; }
 static inline void put_page_tag_ref(union codetag_ref *ref) {}
+static inline void clear_page_tag_ref(struct page *page) {}
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
--- a/mm/mm_init.c~alloc_tag-introduce-clear_page_tag_ref-helper-function
+++ a/mm/mm_init.c
@@ -2459,15 +2459,7 @@ void __init memblock_free_pages(struct p
 	}
 
 	/* pages were reserved and not allocated */
-	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
-
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
-		}
-	}
-
+	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
 }
 
--- a/mm/page_alloc.c~alloc_tag-introduce-clear_page_tag_ref-helper-function
+++ a/mm/page_alloc.c
@@ -5815,14 +5815,7 @@ unsigned long free_reserved_area(void *s
 
 void free_reserved_page(struct page *page)
 {
-	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
-
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
-		}
-	}
+	clear_page_tag_ref(page);
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-introduce-clear_page_tag_ref-helper-function.patch
alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch

