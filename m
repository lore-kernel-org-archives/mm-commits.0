Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE8F2153EA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188222; cv=none; b=BRiIjgaf6irmbI7xNAVqv6VXugQgbWI0Thndx49nIiCeXbdHL3J2VbWqDDzKgffxI5HbNGCzuOnR6ENz9liL0MdTdKYh0TGLb9b9jnupnxXsS67dmndVw16MGdRRB+3V0/fPqirymU/jzh6Z7WmuWzRCMUzmAxiKptv3+CkOifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188222; c=relaxed/simple;
	bh=VrGPQQJUJl9fv07lerz6VULRA+k+ol9L9gt694rfaBo=;
	h=Date:To:From:Subject:Message-Id; b=YCX+vwEaw+HB7HO2u16BRNSE5HZwYY+gwTiYzPiGOKw93+y3SkMBDFEPFZAeqtcEM21KvsthGl3Ng+Hdd/hTpItFaWH9aZyObydNxf9YHcM0FR9ZmVImsyNUq+x/fRJFzxZHcejJ2StpIchRob719oAjCEwqKOIMon8/zO5MfZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XALxfHeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XALxfHeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF66C4CEEC;
	Mon, 17 Mar 2025 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188222;
	bh=VrGPQQJUJl9fv07lerz6VULRA+k+ol9L9gt694rfaBo=;
	h=Date:To:From:Subject:From;
	b=XALxfHeqVRSRNu4/x+Q9wiVHvUItN1/NrzLcKfvFHzOa3/a+RzejmxmRmgPCQ3Rnt
	 bZi1nbfyOwscWO9nbLBrY/Eh/VcNjZacO2jG7jkGrloRvWHan3whP3kNLOhey3Qv8n
	 RmeyMnWiXE4PpH1q3OaQvIt0SbNWjOuu7O+NKdc8=
Date: Sun, 16 Mar 2025 22:10:21 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,quic_zhenhuah@quicinc.com,peterz@infradead.org,pasha.tatashin@soleen.com,minchan@google.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch removed from -mm tree
Message-Id: <20250317051021.EDF66C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid extra mem_alloc_profiling_enabled() checks
has been removed from the -mm tree.  Its filename was
     mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: avoid extra mem_alloc_profiling_enabled() checks
Date: Sat, 1 Feb 2025 15:18:00 -0800

Refactor code to avoid extra mem_alloc_profiling_enabled() checks inside
pgalloc_tag_get() function which is often called after that check was
already done.

Link: https://lkml.kernel.org/r/20250201231803.2661189-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Wang <00107082@163.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Minchan Kim <minchan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |   33 ++++++++++++++++++---------------
 lib/alloc_tag.c             |    6 +++---
 mm/page_alloc.c             |    3 +--
 3 files changed, 22 insertions(+), 20 deletions(-)

--- a/include/linux/pgalloc_tag.h~mm-avoid-extra-mem_alloc_profiling_enabled-checks
+++ a/include/linux/pgalloc_tag.h
@@ -205,28 +205,32 @@ static inline void pgalloc_tag_sub(struc
 	}
 }
 
-static inline struct alloc_tag *pgalloc_tag_get(struct page *page)
+/* Should be called only if mem_alloc_profiling_enabled() */
+static inline struct alloc_tag *__pgalloc_tag_get(struct page *page)
 {
 	struct alloc_tag *tag = NULL;
+	union pgtag_ref_handle handle;
+	union codetag_ref ref;
 
-	if (mem_alloc_profiling_enabled()) {
-		union pgtag_ref_handle handle;
-		union codetag_ref ref;
-
-		if (get_page_tag_ref(page, &ref, &handle)) {
-			alloc_tag_sub_check(&ref);
-			if (ref.ct)
-				tag = ct_to_alloc_tag(ref.ct);
-			put_page_tag_ref(handle);
-		}
+	if (get_page_tag_ref(page, &ref, &handle)) {
+		alloc_tag_sub_check(&ref);
+		if (ref.ct)
+			tag = ct_to_alloc_tag(ref.ct);
+		put_page_tag_ref(handle);
 	}
 
 	return tag;
 }
 
-static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
+static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr)
 {
-	if (mem_alloc_profiling_enabled() && tag)
+	struct alloc_tag *tag;
+
+	if (!mem_alloc_profiling_enabled())
+		return;
+
+	tag = __pgalloc_tag_get(page);
+	if (tag)
 		this_cpu_sub(tag->counters->bytes, PAGE_SIZE * nr);
 }
 
@@ -241,8 +245,7 @@ static inline void clear_page_tag_ref(st
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
-static inline struct alloc_tag *pgalloc_tag_get(struct page *page) { return NULL; }
-static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
+static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr) {}
 static inline void alloc_tag_sec_init(void) {}
 static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order) {}
 static inline void pgalloc_tag_swap(struct folio *new, struct folio *old) {}
--- a/lib/alloc_tag.c~mm-avoid-extra-mem_alloc_profiling_enabled-checks
+++ a/lib/alloc_tag.c
@@ -174,7 +174,7 @@ void pgalloc_tag_split(struct folio *fol
 	if (!mem_alloc_profiling_enabled())
 		return;
 
-	tag = pgalloc_tag_get(&folio->page);
+	tag = __pgalloc_tag_get(&folio->page);
 	if (!tag)
 		return;
 
@@ -200,10 +200,10 @@ void pgalloc_tag_swap(struct folio *new,
 	if (!mem_alloc_profiling_enabled())
 		return;
 
-	tag_old = pgalloc_tag_get(&old->page);
+	tag_old = __pgalloc_tag_get(&old->page);
 	if (!tag_old)
 		return;
-	tag_new = pgalloc_tag_get(&new->page);
+	tag_new = __pgalloc_tag_get(&new->page);
 	if (!tag_new)
 		return;
 
--- a/mm/page_alloc.c~mm-avoid-extra-mem_alloc_profiling_enabled-checks
+++ a/mm/page_alloc.c
@@ -4833,12 +4833,11 @@ void __free_pages(struct page *page, uns
 {
 	/* get PageHead before we drop reference */
 	int head = PageHead(page);
-	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
 		free_frozen_pages(page, order);
 	else if (!head) {
-		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
+		pgalloc_tag_sub_pages(page, (1 << order) - 1);
 		while (order-- > 0)
 			free_frozen_pages(page + (1 << order), order);
 	}
_

Patches currently in -mm which might be from surenb@google.com are


