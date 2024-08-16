Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF617E0F4;
	Fri, 16 Aug 2024 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785429; cv=none; b=q17G8u6xKCEUSvWLhDQgUwdRV/5ShuptJOGhdoRq2AcLFCwzNs5R26Kd9ELZ6OU7l4ugL3363lTzn+aRcznk7e8HmALGRTQtbzi7LbYFL71yY+DEqUqmAEGbzdnVPyqjDda0HkjHJkf81qRocBzSH+/QlZJ3D6YXOjKP88pWnsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785429; c=relaxed/simple;
	bh=beEouHHVbeVQcALqCOkVV10+okDPN194x9/09a+VkVs=;
	h=Date:To:From:Subject:Message-Id; b=WnddxsO7qVs9nABYnO1UJYO0uXei0J4Z3pt+KDWc65QgVljdZZK4d72f1RTzCVH0Ka3Ya7V94mQMwzOITCDIhB4F/f4yzykvYQqgQ4l8BhAaHMn3KTDwzFCWU+gB1sXz2cq+HuJkDbgTYU+/PVy2jb9GkD8v+MRe0U5RI9svWrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pTHO262V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pTHO262V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D8EC32782;
	Fri, 16 Aug 2024 05:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785427;
	bh=beEouHHVbeVQcALqCOkVV10+okDPN194x9/09a+VkVs=;
	h=Date:To:From:Subject:From;
	b=pTHO262V3HRBlfZ7s7W96vKcu8dNF4H7OQckNh1N/d6fAflBrlXhNR1G/zRsbsSMJ
	 gwqrLaXYAwu7hz9BtHSSMlSxZHpFZt4P+lRTyNcTkeXKhG9ymusVRBadncQfg/09N2
	 BcUq1Kj5+8FEZ8DCNXjmL7HA7ruXLR3P7oIswn9k=
Date: Thu, 15 Aug 2024 22:17:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-introduce-clear_page_tag_ref-helper-function.patch removed from -mm tree
Message-Id: <20240816051707.89D8EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: introduce clear_page_tag_ref() helper function
has been removed from the -mm tree.  Its filename was
     alloc_tag-introduce-clear_page_tag_ref-helper-function.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
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


