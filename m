Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6C1E48A
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854860; cv=none; b=lYefrRGhNnYp6zyqMwhpoteNm6AhsTAp3MNxODFHifEVzpv/fAIRJFSUd4IWj4y0/UoMIi+eiid7g2roSDHJet9HeFKEktbT22yOOfD6AsEX/qzxpjV4pDMKA96dB5wdXzGnxMY3coSmpSRBieDQKiAvh/SYFAshncU+dOtpj78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854860; c=relaxed/simple;
	bh=N6FIHkMnNXnYYEpOY2auJ9/TID2nJEuET4u2nZGiV6Y=;
	h=Date:To:From:Subject:Message-Id; b=dBDH7O0jT6ffoGPkJwT1vqCwywN4dMhQ09VpdIM1jAYlBcjDVT00OA0tDYqzXOBAT3dwKDvP5QVCdquTsyYElSCxSOGXObI1u77M4tz1hD73G+bkODRMt5Jc9f+SuKS/PL+4eQfq1PJp7EIYRhGlv/oLIauKtSnXyW33V2xJkQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXADdXzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXADdXzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21A9C4CECF;
	Wed,  6 Nov 2024 01:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854859;
	bh=N6FIHkMnNXnYYEpOY2auJ9/TID2nJEuET4u2nZGiV6Y=;
	h=Date:To:From:Subject:From;
	b=qXADdXzGm67iGX6Raw94HRtnqpzzDXrp/lOEk+0bARQATjGN19q1xmlMoIgFENN3a
	 jkBM1339jcOHJavPelgCU2+ULXyC0rojcM50VpwC80qfoZa0ps10MfgGqEIBiX6EFt
	 RNrBkjan2nXqdXMGSvFKT78dbiSk7+pG9EBUi99k=
Date: Tue, 05 Nov 2024 17:00:59 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch removed from -mm tree
Message-Id: <20241106010059.D21A9C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: introduce pgtag_ref_handle to abstract page tag references
has been removed from the -mm tree.  Its filename was
     alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4181,37 +4181,38 @@ static inline void pgalloc_tag_split(str
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

mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

