Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337F779945
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103895; cv=none; b=gzNR7nOMS/xeEIUA1fxeOGSGntFrClai/dGLM6atek1uE3DKKUtOiMPh716B/gAMGAjX1kKe/+aMZ+Gwa/Gi/NIvRiAJRhKs2YAhAT5+Ic19htQ7O8imkJxZI2yVJmumSGzUh5O8IqtA4CAII1AYWh15SCtQU2CBRECcoAJ7e7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103895; c=relaxed/simple;
	bh=Qmlw/tSlwUeONZj0QzhvjgzoQR2/AjbVjzlFrBzyr1E=;
	h=Date:To:From:Subject:Message-Id; b=G+O2srMxaLTvdQP/oLo5SWaEcV0EGw/j3nQ2kZa2epgx3ti2B8UlbNmu9+lNKWtC8D1GdDjlymXiYyzRA11abjSDtSu9GRsCwWkAqR0VZUA3gQHqf6Vk67fHLtY0Bvp5+Jvbij8ylbZMRNH4wLuO5VLBuSkwIqsPYaKhHg7B1Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IZzsf5ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IZzsf5ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EEAC113CD;
	Fri, 26 Apr 2024 03:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103895;
	bh=Qmlw/tSlwUeONZj0QzhvjgzoQR2/AjbVjzlFrBzyr1E=;
	h=Date:To:From:Subject:From;
	b=IZzsf5uebT+iIGmlOBXgc4n2hoQE4aYKUTGHkxPrV7/Gf+Zm7SqvbtRaIp3zXVW55
	 4nr032YWmcqdEKHM1Q1D97BKgyV8VN+vmrsJw8tVxmJqe4A+dMWEiZ+a2HP7YYfAcu
	 Pn9BcmLwXGQX5dMNmq4M4OAeuqdJVUKj1AgFKlmY=
Date: Thu, 25 Apr 2024 20:58:14 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-introduce-support-for-page-allocation-tagging.patch removed from -mm tree
Message-Id: <20240426035815.08EEAC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: introduce support for page allocation tagging
has been removed from the -mm tree.  Its filename was
     lib-introduce-support-for-page-allocation-tagging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: introduce support for page allocation tagging
Date: Thu, 21 Mar 2024 09:36:36 -0700

Introduce helper functions to easily instrument page allocators by storing
a pointer to the allocation tag associated with the code that allocated
the page in a page_ext field.

Link: https://lkml.kernel.org/r/20240321163705.3067592-15-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Co-developed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h    |    1 
 include/linux/pgalloc_tag.h |   78 ++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug           |    1 
 lib/alloc_tag.c             |   17 +++++++
 mm/mm_init.c                |    1 
 mm/page_alloc.c             |    4 +
 mm/page_ext.c               |    4 +
 7 files changed, 105 insertions(+), 1 deletion(-)

--- a/include/linux/page_ext.h~lib-introduce-support-for-page-allocation-tagging
+++ a/include/linux/page_ext.h
@@ -4,7 +4,6 @@
 
 #include <linux/types.h>
 #include <linux/stacktrace.h>
-#include <linux/stackdepot.h>
 
 struct pglist_data;
 
--- /dev/null
+++ a/include/linux/pgalloc_tag.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * page allocation tagging
+ */
+#ifndef _LINUX_PGALLOC_TAG_H
+#define _LINUX_PGALLOC_TAG_H
+
+#include <linux/alloc_tag.h>
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+
+#include <linux/page_ext.h>
+
+extern struct page_ext_operations page_alloc_tagging_ops;
+extern struct page_ext *page_ext_get(struct page *page);
+extern void page_ext_put(struct page_ext *page_ext);
+
+static inline union codetag_ref *codetag_ref_from_page_ext(struct page_ext *page_ext)
+{
+	return (void *)page_ext + page_alloc_tagging_ops.offset;
+}
+
+static inline struct page_ext *page_ext_from_codetag_ref(union codetag_ref *ref)
+{
+	return (void *)ref - page_alloc_tagging_ops.offset;
+}
+
+/* Should be called only if mem_alloc_profiling_enabled() */
+static inline union codetag_ref *get_page_tag_ref(struct page *page)
+{
+	if (page) {
+		struct page_ext *page_ext = page_ext_get(page);
+
+		if (page_ext)
+			return codetag_ref_from_page_ext(page_ext);
+	}
+	return NULL;
+}
+
+static inline void put_page_tag_ref(union codetag_ref *ref)
+{
+	page_ext_put(page_ext_from_codetag_ref(ref));
+}
+
+static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
+				   unsigned int nr)
+{
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			alloc_tag_add(ref, task->alloc_tag, PAGE_SIZE * nr);
+			put_page_tag_ref(ref);
+		}
+	}
+}
+
+static inline void pgalloc_tag_sub(struct page *page, unsigned int nr)
+{
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			alloc_tag_sub(ref, PAGE_SIZE * nr);
+			put_page_tag_ref(ref);
+		}
+	}
+}
+
+#else /* CONFIG_MEM_ALLOC_PROFILING */
+
+static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
+				   unsigned int nr) {}
+static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
+
+#endif /* CONFIG_MEM_ALLOC_PROFILING */
+
+#endif /* _LINUX_PGALLOC_TAG_H */
--- a/lib/alloc_tag.c~lib-introduce-support-for-page-allocation-tagging
+++ a/lib/alloc_tag.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/page_ext.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
@@ -118,6 +119,22 @@ static bool alloc_tag_module_unload(stru
 	return module_unused;
 }
 
+static __init bool need_page_alloc_tagging(void)
+{
+	return true;
+}
+
+static __init void init_page_alloc_tagging(void)
+{
+}
+
+struct page_ext_operations page_alloc_tagging_ops = {
+	.size = sizeof(union codetag_ref),
+	.need = need_page_alloc_tagging,
+	.init = init_page_alloc_tagging,
+};
+EXPORT_SYMBOL(page_alloc_tagging_ops);
+
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
--- a/lib/Kconfig.debug~lib-introduce-support-for-page-allocation-tagging
+++ a/lib/Kconfig.debug
@@ -978,6 +978,7 @@ config MEM_ALLOC_PROFILING
 	depends on PROC_FS
 	depends on !DEBUG_FORCE_WEAK_PER_CPU
 	select CODE_TAGGING
+	select PAGE_EXTENSION
 	help
 	  Track allocation source code and record total allocation size
 	  initiated at that code location. The mechanism can be used to track
--- a/mm/mm_init.c~lib-introduce-support-for-page-allocation-tagging
+++ a/mm/mm_init.c
@@ -24,6 +24,7 @@
 #include <linux/page_ext.h>
 #include <linux/pti.h>
 #include <linux/pgtable.h>
+#include <linux/stackdepot.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
--- a/mm/page_alloc.c~lib-introduce-support-for-page-allocation-tagging
+++ a/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/khugepaged.h>
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
+#include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -1101,6 +1102,7 @@ __always_inline bool free_pages_prepare(
 		/* Do not let hwpoison pages hit pcplists/buddy */
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
+		pgalloc_tag_sub(page, 1 << order);
 		return false;
 	}
 
@@ -1140,6 +1142,7 @@ __always_inline bool free_pages_prepare(
 	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
+	pgalloc_tag_sub(page, 1 << order);
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),
@@ -1533,6 +1536,7 @@ inline void post_alloc_hook(struct page
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
+	pgalloc_tag_add(page, current, 1 << order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
--- a/mm/page_ext.c~lib-introduce-support-for-page-allocation-tagging
+++ a/mm/page_ext.c
@@ -10,6 +10,7 @@
 #include <linux/page_idle.h>
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
+#include <linux/pgalloc_tag.h>
 
 /*
  * struct page extension
@@ -82,6 +83,9 @@ static struct page_ext_operations *page_
 #if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 	&page_idle_ops,
 #endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	&page_alloc_tagging_ops,
+#endif
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

