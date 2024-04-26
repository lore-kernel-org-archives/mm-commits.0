Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8957A140
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103904; cv=none; b=RnPmbdaEfHPZ+FBQfLCVYQ2wEFFsRS1SiSs8Du/lKZIytKANeng3L4zdgf62K1dUc/4/xCS4b97XNH5mgu5WeJIFrF4388Qd/xJheOS0akNCXBwPfD9IKUMK7FQBW/mPLXERz6XmkI8XH39ailwrKdp/TQ7y7L/18dFyeNeLMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103904; c=relaxed/simple;
	bh=KBiu8EifaenNt+KjIDlYc4pzMeNPMQy6dhfc/WR5JvQ=;
	h=Date:To:From:Subject:Message-Id; b=WTVl3js26l+/T2urjsvMBrO13C5uoScY5UUuffvzPzKk0t3cvOVYh010zEbm6ge/7I11f+Y7py9/pbJ3rkbupHk2i7UUPckhU/ZWBWrWaTp3G6Uu9fmdP7l7qKcAC/wLhJqqr6cmQKSPttzidSPRToP0qHeL0+/i/YDrI/Rm9vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v8sz6ZMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v8sz6ZMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31414C113CD;
	Fri, 26 Apr 2024 03:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103904;
	bh=KBiu8EifaenNt+KjIDlYc4pzMeNPMQy6dhfc/WR5JvQ=;
	h=Date:To:From:Subject:From;
	b=v8sz6ZMXDaUyJdwfhr/MT3uIr5wL0DCIvFIGcunKlh3xHYde7KtOHImxCZJ8nKBSS
	 LrP0tmd1SZhplUy3iKal5vxqDLCaTZUxYvZO7Zzk5tkL7S4PUDhkJcyE3zlbDMh74d
	 q7ICCAQEJTx3K2vFdKHtwUS04y3LthlHeY7ftZ48=
Date: Thu, 25 Apr 2024 20:58:23 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch removed from -mm tree
Message-Id: <20240426035824.31414C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix non-compound multi-order memory accounting in __free_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix non-compound multi-order memory accounting in __free_pages
Date: Thu, 21 Mar 2024 09:36:42 -0700

When a non-compound multi-order page is freed, it is possible that a
speculative reference keeps the page pinned.  In this case we free all
pages except for the first page, which will be freed later by the last
put_page().  However the page passed to put_page() is indistinguishable
from an order-0 page, so it cannot do the accounting, just as it cannot
free the subsequent pages.  Do the accounting here, where we free the
pages.

Link: https://lkml.kernel.org/r/20240321163705.3067592-21-surenb@google.com
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |   24 ++++++++++++++++++++++++
 mm/page_alloc.c             |    5 ++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

--- a/include/linux/pgalloc_tag.h~mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages
+++ a/include/linux/pgalloc_tag.h
@@ -96,12 +96,36 @@ out:
 	page_ext_put(page_ext);
 }
 
+static inline struct alloc_tag *pgalloc_tag_get(struct page *page)
+{
+	struct alloc_tag *tag = NULL;
+
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		alloc_tag_sub_check(ref);
+		if (ref && ref->ct)
+			tag = ct_to_alloc_tag(ref->ct);
+		put_page_tag_ref(ref);
+	}
+
+	return tag;
+}
+
+static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
+{
+	if (mem_alloc_profiling_enabled() && tag)
+		this_cpu_sub(tag->counters->bytes, PAGE_SIZE * nr);
+}
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_split(struct page *page, unsigned int nr) {}
+static inline struct alloc_tag *pgalloc_tag_get(struct page *page) { return NULL; }
+static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
--- a/mm/page_alloc.c~mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages
+++ a/mm/page_alloc.c
@@ -4664,12 +4664,15 @@ void __free_pages(struct page *page, uns
 {
 	/* get PageHead before we drop reference */
 	int head = PageHead(page);
+	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
 		free_the_page(page, order);
-	else if (!head)
+	else if (!head) {
+		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
+	}
 }
 EXPORT_SYMBOL(__free_pages);
 
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

