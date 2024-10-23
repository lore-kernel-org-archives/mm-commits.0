Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C533155741
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729717545; cv=none; b=MEi7dNUwN+rmRqRfsobmIXugQb5oEsiAo4Y7wl1yYHzO6Xx9+1d6WU7pMBjEj1pqd8T29Ax6MiIgfQY6Qb0kcXiCrlKpWwSTHXlcQcO0XgscuL5gvHWUAw57eu2eFkJUqHQs+4RvBozb/uoG0NfTRbrl3brloATxvEafP1NUqn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729717545; c=relaxed/simple;
	bh=7tDvOVzHA7MYBAqll70kZDrHjphzTyAc/T4WWfT2CFE=;
	h=Date:To:From:Subject:Message-Id; b=EZso6vxEw402n/euJcoYS/HeP9FHv3uqs5oJQ9PlAl/+Kks4gc0h0DGjOMEuhYC1n89x7OntjKbJ0H2GbDgzxN07+M46fmGP2jNb6mLJmwH1ZteWgbwRlNgDBPAJWlIET4AaFhI4BoyvmQEPJ83I4aU9XIx8jD9DBXZOVVlxHjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FbD1oukO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FbD1oukO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A5C4CEC6;
	Wed, 23 Oct 2024 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729717544;
	bh=7tDvOVzHA7MYBAqll70kZDrHjphzTyAc/T4WWfT2CFE=;
	h=Date:To:From:Subject:From;
	b=FbD1oukOO7zJZx63PM1FUkNCHlZU9O9gspDXcGKlikyUeotR0QoL9+WGrFct6f5/Y
	 axjMwduVJUeZvk+kKR6QWhKpyuFuatb3yvvqI6x7i4ZT2SoD8cYfiUEb2HTs1OXh6B
	 DqlFL+OPIA9qT5sJ4Wlb7LWe0UmtzYSpk6hamjgc=
Date: Wed, 23 Oct 2024 14:05:44 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch added to mm-unstable branch
Message-Id: <20241023210544.901A5C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: introduce pgtag_ref_handle to abstract page tag references
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: introduce pgtag_ref_handle to abstract page tag references
Date: Wed, 23 Oct 2024 10:07:58 -0700

To simplify later changes to page tag references, introduce new
pgtag_ref_handle type.  This allows easy replacement of page_ext as a
storage of page allocation tags.

Link: https://lkml.kernel.org/r/20241023170759.999909-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiongwei Song <xiongwei.song@windriver.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h          |   25 ++++-----
 include/linux/pgalloc_tag.h |   90 ++++++++++++++++++++--------------
 2 files changed, 66 insertions(+), 49 deletions(-)

--- a/include/linux/mm.h~alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references
+++ a/include/linux/mm.h
@@ -4180,37 +4180,38 @@ static inline void pgalloc_tag_split(str
 		return;
 
 	for (i = nr_pages; i < (1 << old_order); i += nr_pages) {
-		union codetag_ref *ref = get_page_tag_ref(folio_page(folio, i));
+		union pgtag_ref_handle handle;
+		union codetag_ref ref;
 
-		if (ref) {
+		if (get_page_tag_ref(folio_page(folio, i), &ref, &handle)) {
 			/* Set new reference to point to the original tag */
-			alloc_tag_ref_set(ref, tag);
-			put_page_tag_ref(ref);
+			alloc_tag_ref_set(&ref, tag);
+			update_page_tag_ref(handle, &ref);
+			put_page_tag_ref(handle);
 		}
 	}
 }
 
 static inline void pgalloc_tag_copy(struct folio *new, struct folio *old)
 {
+	union pgtag_ref_handle handle;
+	union codetag_ref ref;
 	struct alloc_tag *tag;
-	union codetag_ref *ref;
 
 	tag = pgalloc_tag_get(&old->page);
 	if (!tag)
 		return;
 
-	ref = get_page_tag_ref(&new->page);
-	if (!ref)
+	if (!get_page_tag_ref(&new->page, &ref, &handle))
 		return;
 
 	/* Clear the old ref to the original allocation tag. */
 	clear_page_tag_ref(&old->page);
 	/* Decrement the counters of the tag on get_new_folio. */
-	alloc_tag_sub(ref, folio_size(new));
-
-	__alloc_tag_ref_set(ref, tag);
-
-	put_page_tag_ref(ref);
+	alloc_tag_sub(&ref, folio_size(new));
+	__alloc_tag_ref_set(&ref, tag);
+	update_page_tag_ref(handle, &ref);
+	put_page_tag_ref(handle);
 }
 #else /* !CONFIG_MEM_ALLOC_PROFILING */
 static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
--- a/include/linux/pgalloc_tag.h~alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references
+++ a/include/linux/pgalloc_tag.h
@@ -11,46 +11,59 @@
 
 #include <linux/page_ext.h>
 
+union pgtag_ref_handle {
+	union codetag_ref *ref;	/* reference in page extension */
+};
+
 extern struct page_ext_operations page_alloc_tagging_ops;
 
-static inline union codetag_ref *codetag_ref_from_page_ext(struct page_ext *page_ext)
+/* Should be called only if mem_alloc_profiling_enabled() */
+static inline bool get_page_tag_ref(struct page *page, union codetag_ref *ref,
+				    union pgtag_ref_handle *handle)
 {
-	return (union codetag_ref *)page_ext_data(page_ext, &page_alloc_tagging_ops);
-}
+	struct page_ext *page_ext;
+	union codetag_ref *tmp;
 
-static inline struct page_ext *page_ext_from_codetag_ref(union codetag_ref *ref)
-{
-	return (void *)ref - page_alloc_tagging_ops.offset;
+	if (!page)
+		return false;
+
+	page_ext = page_ext_get(page);
+	if (!page_ext)
+		return false;
+
+	tmp = (union codetag_ref *)page_ext_data(page_ext, &page_alloc_tagging_ops);
+	ref->ct = tmp->ct;
+	handle->ref = tmp;
+	return true;
 }
 
-/* Should be called only if mem_alloc_profiling_enabled() */
-static inline union codetag_ref *get_page_tag_ref(struct page *page)
+static inline void put_page_tag_ref(union pgtag_ref_handle handle)
 {
-	if (page) {
-		struct page_ext *page_ext = page_ext_get(page);
+	if (WARN_ON(!handle.ref))
+		return;
 
-		if (page_ext)
-			return codetag_ref_from_page_ext(page_ext);
-	}
-	return NULL;
+	page_ext_put((void *)handle.ref - page_alloc_tagging_ops.offset);
 }
 
-static inline void put_page_tag_ref(union codetag_ref *ref)
+static inline void update_page_tag_ref(union pgtag_ref_handle handle,
+				       union codetag_ref *ref)
 {
-	if (WARN_ON(!ref))
+	if (WARN_ON(!handle.ref || !ref))
 		return;
 
-	page_ext_put(page_ext_from_codetag_ref(ref));
+	handle.ref->ct = ref->ct;
 }
 
 static inline void clear_page_tag_ref(struct page *page)
 {
 	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
+		union pgtag_ref_handle handle;
+		union codetag_ref ref;
 
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
+		if (get_page_tag_ref(page, &ref, &handle)) {
+			set_codetag_empty(&ref);
+			update_page_tag_ref(handle, &ref);
+			put_page_tag_ref(handle);
 		}
 	}
 }
@@ -59,11 +72,13 @@ static inline void pgalloc_tag_add(struc
 				   unsigned int nr)
 {
 	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
+		union pgtag_ref_handle handle;
+		union codetag_ref ref;
 
-		if (ref) {
-			alloc_tag_add(ref, task->alloc_tag, PAGE_SIZE * nr);
-			put_page_tag_ref(ref);
+		if (get_page_tag_ref(page, &ref, &handle)) {
+			alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
+			update_page_tag_ref(handle, &ref);
+			put_page_tag_ref(handle);
 		}
 	}
 }
@@ -71,11 +86,13 @@ static inline void pgalloc_tag_add(struc
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr)
 {
 	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
+		union pgtag_ref_handle handle;
+		union codetag_ref ref;
 
-		if (ref) {
-			alloc_tag_sub(ref, PAGE_SIZE * nr);
-			put_page_tag_ref(ref);
+		if (get_page_tag_ref(page, &ref, &handle)) {
+			alloc_tag_sub(&ref, PAGE_SIZE * nr);
+			update_page_tag_ref(handle, &ref);
+			put_page_tag_ref(handle);
 		}
 	}
 }
@@ -85,13 +102,14 @@ static inline struct alloc_tag *pgalloc_
 	struct alloc_tag *tag = NULL;
 
 	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
+		union pgtag_ref_handle handle;
+		union codetag_ref ref;
 
-		alloc_tag_sub_check(ref);
-		if (ref) {
-			if (ref->ct)
-				tag = ct_to_alloc_tag(ref->ct);
-			put_page_tag_ref(ref);
+		if (get_page_tag_ref(page, &ref, &handle)) {
+			alloc_tag_sub_check(&ref);
+			if (ref.ct)
+				tag = ct_to_alloc_tag(ref.ct);
+			put_page_tag_ref(handle);
 		}
 	}
 
@@ -106,8 +124,6 @@ static inline void pgalloc_tag_sub_pages
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
-static inline union codetag_ref *get_page_tag_ref(struct page *page) { return NULL; }
-static inline void put_page_tag_ref(union codetag_ref *ref) {}
 static inline void clear_page_tag_ref(struct page *page) {}
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
_

Patches currently in -mm which might be from surenb@google.com are

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch

