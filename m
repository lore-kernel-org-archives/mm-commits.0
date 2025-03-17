Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0836A21518D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188225; cv=none; b=BV/LFKCeBbXK0sqmQaZrgh82eYWchrZSbnewfx0i/QxYSocfeMlkhscj6AkOsCkfwhij8JbUEwpKhjpw7azHATvPlM8P/BDgaYHkBfqFHqyg3xFVFOEzsA2cVdiPPtoRGCSWYqL3r1V/2k96kZLoeZS75KBvErj606rqH3WaWrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188225; c=relaxed/simple;
	bh=hZLIc8GfJo9ePQDUFOdGmyyt30vnA6PA458c8QrgwhU=;
	h=Date:To:From:Subject:Message-Id; b=ISiRdHHDkK/qgGq2KQnVOODeN0CDmDjEqxbRNhoMfnnFSWbHvc27rvKfeiKxB3diXbTlt15mVNl3EgB65LKk2yoVhzTptm2aJYnwyq3r3aUVfZqIcQ/g5O76pnYrcKbhDtAWRYUGgGYfAPWK+Ye9Cp+0JLW+EXnYuWanYCAT87o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJ16Hdvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJ16Hdvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7475AC4CEEC;
	Mon, 17 Mar 2025 05:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188224;
	bh=hZLIc8GfJo9ePQDUFOdGmyyt30vnA6PA458c8QrgwhU=;
	h=Date:To:From:Subject:From;
	b=cJ16HdvzjCPmBi/v6vnihA9KxvoL6a+04nzCaMfpaEoKfI2jWXGz5023+qkDUWioD
	 qGmeVirL2aQcxk9qvNWjXhhCtNcg9QRypFw0YADVV4i7glGCgyyJ0GvoL6EDeOv/9M
	 avRRsHrcyfZiYwsJfBGcTC0LxQgvGqQKWr1nCYV0=
Date: Sun, 16 Mar 2025 22:10:23 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,quic_zhenhuah@quicinc.com,peterz@infradead.org,pasha.tatashin@soleen.com,minchan@google.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch removed from -mm tree
Message-Id: <20250317051024.7475AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: uninline code gated by mem_alloc_profiling_key in page allocator
has been removed from the -mm tree.  Its filename was
     alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: uninline code gated by mem_alloc_profiling_key in page allocator
Date: Sat, 1 Feb 2025 15:18:02 -0800

When a sizable code section is protected by a disabled static key, that
code gets into the instruction cache even though it's not executed and
consumes the cache, increasing cache misses. This can be remedied by
moving such code into a separate uninlined function.
On a Pixel6 phone, page allocation profiling overhead measured with
CONFIG_MEM_ALLOC_PROFILING=y and profiling disabled is:

             baseline             modified
Big core     4.93%                1.53%
Medium core  4.39%                1.41%
Little core  1.02%                0.36%

This improvement comes at the expense of the configuration when profiling
gets enabled, since there is now an additional function call. The overhead
from this additional call on Pixel6 is:

Big core     0.24%
Middle core  0.63%
Little core  1.1%

However this is negligible when compared with the overall overhead of the
memory allocation profiling when it is enabled.
On x86 this patch does not make noticeable difference because the overhead
with mem_alloc_profiling_key disabled is much lower (under 1%) to start
with, so any improvement is less visible and hard to distinguish from the
noise. The overhead from additional call when profiling is enabled is also
within noise levels.

Link: https://lkml.kernel.org/r/20250201231803.2661189-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Minchan Kim <minchan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |   60 ++------------------------
 mm/page_alloc.c             |   78 ++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 55 deletions(-)

--- a/include/linux/pgalloc_tag.h~alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator
+++ a/include/linux/pgalloc_tag.h
@@ -162,47 +162,13 @@ static inline void update_page_tag_ref(u
 	}
 }
 
-static inline void clear_page_tag_ref(struct page *page)
-{
-	if (mem_alloc_profiling_enabled()) {
-		union pgtag_ref_handle handle;
-		union codetag_ref ref;
-
-		if (get_page_tag_ref(page, &ref, &handle)) {
-			set_codetag_empty(&ref);
-			update_page_tag_ref(handle, &ref);
-			put_page_tag_ref(handle);
-		}
-	}
-}
-
-static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr)
-{
-	if (mem_alloc_profiling_enabled()) {
-		union pgtag_ref_handle handle;
-		union codetag_ref ref;
-
-		if (get_page_tag_ref(page, &ref, &handle)) {
-			alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
-			update_page_tag_ref(handle, &ref);
-			put_page_tag_ref(handle);
-		}
-	}
-}
+/* Should be called only if mem_alloc_profiling_enabled() */
+void __clear_page_tag_ref(struct page *page);
 
-static inline void pgalloc_tag_sub(struct page *page, unsigned int nr)
+static inline void clear_page_tag_ref(struct page *page)
 {
-	if (mem_alloc_profiling_enabled()) {
-		union pgtag_ref_handle handle;
-		union codetag_ref ref;
-
-		if (get_page_tag_ref(page, &ref, &handle)) {
-			alloc_tag_sub(&ref, PAGE_SIZE * nr);
-			update_page_tag_ref(handle, &ref);
-			put_page_tag_ref(handle);
-		}
-	}
+	if (mem_alloc_profiling_enabled())
+		__clear_page_tag_ref(page);
 }
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -222,18 +188,6 @@ static inline struct alloc_tag *__pgallo
 	return tag;
 }
 
-static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr)
-{
-	struct alloc_tag *tag;
-
-	if (!mem_alloc_profiling_enabled())
-		return;
-
-	tag = __pgalloc_tag_get(page);
-	if (tag)
-		this_cpu_sub(tag->counters->bytes, PAGE_SIZE * nr);
-}
-
 void pgalloc_tag_split(struct folio *folio, int old_order, int new_order);
 void pgalloc_tag_swap(struct folio *new, struct folio *old);
 
@@ -242,10 +196,6 @@ void __init alloc_tag_sec_init(void);
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void clear_page_tag_ref(struct page *page) {}
-static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr) {}
-static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
-static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr) {}
 static inline void alloc_tag_sec_init(void) {}
 static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order) {}
 static inline void pgalloc_tag_swap(struct folio *new, struct folio *old) {}
--- a/mm/page_alloc.c~alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator
+++ a/mm/page_alloc.c
@@ -1041,6 +1041,84 @@ static void kernel_init_pages(struct pag
 	kasan_enable_current();
 }
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+
+/* Should be called only if mem_alloc_profiling_enabled() */
+void __clear_page_tag_ref(struct page *page)
+{
+	union pgtag_ref_handle handle;
+	union codetag_ref ref;
+
+	if (get_page_tag_ref(page, &ref, &handle)) {
+		set_codetag_empty(&ref);
+		update_page_tag_ref(handle, &ref);
+		put_page_tag_ref(handle);
+	}
+}
+
+/* Should be called only if mem_alloc_profiling_enabled() */
+static noinline
+void __pgalloc_tag_add(struct page *page, struct task_struct *task,
+		       unsigned int nr)
+{
+	union pgtag_ref_handle handle;
+	union codetag_ref ref;
+
+	if (get_page_tag_ref(page, &ref, &handle)) {
+		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
+		update_page_tag_ref(handle, &ref);
+		put_page_tag_ref(handle);
+	}
+}
+
+static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
+				   unsigned int nr)
+{
+	if (mem_alloc_profiling_enabled())
+		__pgalloc_tag_add(page, task, nr);
+}
+
+/* Should be called only if mem_alloc_profiling_enabled() */
+static noinline
+void __pgalloc_tag_sub(struct page *page, unsigned int nr)
+{
+	union pgtag_ref_handle handle;
+	union codetag_ref ref;
+
+	if (get_page_tag_ref(page, &ref, &handle)) {
+		alloc_tag_sub(&ref, PAGE_SIZE * nr);
+		update_page_tag_ref(handle, &ref);
+		put_page_tag_ref(handle);
+	}
+}
+
+static inline void pgalloc_tag_sub(struct page *page, unsigned int nr)
+{
+	if (mem_alloc_profiling_enabled())
+		__pgalloc_tag_sub(page, nr);
+}
+
+static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr)
+{
+	struct alloc_tag *tag;
+
+	if (!mem_alloc_profiling_enabled())
+		return;
+
+	tag = __pgalloc_tag_get(page);
+	if (tag)
+		this_cpu_sub(tag->counters->bytes, PAGE_SIZE * nr);
+}
+
+#else /* CONFIG_MEM_ALLOC_PROFILING */
+
+static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
+				   unsigned int nr) {}
+static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
+static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr) {}
+
+#endif /* CONFIG_MEM_ALLOC_PROFILING */
+
 __always_inline bool free_pages_prepare(struct page *page,
 			unsigned int order)
 {
_

Patches currently in -mm which might be from surenb@google.com are


