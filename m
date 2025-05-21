Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC4922D79F
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846648; cv=none; b=rkP3hP4L2+WEl3eBS0BBpOcidFQNosmPAnwtp+1QhciN1zdW1cfhne6U+lKbkl8vZD/WxE1WpI6p2aGlptwYfOMwaiemMCDi+JGYsL4wfAI5nMDZTdVzYRqfRc3RKQtKV6EanICPYO8fdVSmqjeLSjOqDnZTBB2t9+n2reSuSic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846648; c=relaxed/simple;
	bh=lPZFwoOjl5P8QwSEW3Gv/L0CjVMKeQuHdBqbfls5OmA=;
	h=Date:To:From:Subject:Message-Id; b=Mftxt66ZeNJj6YdkGKMYHCbHdRCRJPsKHagnsgPNrJiYVfB53G4OdfTYgITuS4RHLGFCYaJWvbBrT5SYPR27Am0WyOKbd2KXYgzQnnAe6SObNcLRaJUm0Ql8sMB+NfdqXoPlIwcuJRS7BDbnRffXrTtAyZ9suu+sMVxGrUrQ4pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sH1xAUp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sH1xAUp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF6C4CEE4;
	Wed, 21 May 2025 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846648;
	bh=lPZFwoOjl5P8QwSEW3Gv/L0CjVMKeQuHdBqbfls5OmA=;
	h=Date:To:From:Subject:From;
	b=sH1xAUp/fBrl/npgrxIUckGSEI8aLpkbOWYcHHzr3oH4KD1ovPJEn8m+bD2V8sqW1
	 6iiYjQHV4Ykjh48SP0iZasq/jGD66PZEsM2Cpsp5Uffacw5zRO7O5USz3JOYD8pSRC
	 API3fC4HJzNzgI9Y5vp1MbSECkM91Whoc9C9sYSs=
Date: Wed, 21 May 2025 09:57:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,memxor@gmail.com,harry.yoo@oracle.com,hannes@cmpxchg.org,bigeasy@linutronix.de,andrii@kernel.org,ast@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-try_alloc_pages-to-alloc_pages_nolock.patch removed from -mm tree
Message-Id: <20250521165727.F1DF6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename try_alloc_pages() to alloc_pages_nolock()
has been removed from the -mm tree.  Its filename was
     mm-rename-try_alloc_pages-to-alloc_pages_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexei Starovoitov <ast@kernel.org>
Subject: mm: rename try_alloc_pages() to alloc_pages_nolock()
Date: Fri, 16 May 2025 17:34:46 -0700

The "try_" prefix is confusing, since it made people believe that
try_alloc_pages() is analogous to spin_trylock() and NULL return means
EAGAIN.  This is not the case.  If it returns NULL there is no reason to
call it again.  It will most likely return NULL again.  Hence rename it to
alloc_pages_nolock() to make it symmetrical to free_pages_nolock() and
document that NULL means ENOMEM.

Link: https://lkml.kernel.org/r/20250517003446.60260-1-alexei.starovoitov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h  |    8 ++++----
 kernel/bpf/syscall.c |    2 +-
 mm/page_alloc.c      |   15 ++++++++-------
 mm/page_owner.c      |    2 +-
 4 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/linux/gfp.h~mm-rename-try_alloc_pages-to-alloc_pages_nolock
+++ a/include/linux/gfp.h
@@ -45,13 +45,13 @@ static inline bool gfpflags_allow_spinni
 	 * !__GFP_DIRECT_RECLAIM -> direct claim is not allowed.
 	 * !__GFP_KSWAPD_RECLAIM -> it's not safe to wake up kswapd.
 	 * All GFP_* flags including GFP_NOWAIT use one or both flags.
-	 * try_alloc_pages() is the only API that doesn't specify either flag.
+	 * alloc_pages_nolock() is the only API that doesn't specify either flag.
 	 *
 	 * This is stronger than GFP_NOWAIT or GFP_ATOMIC because
 	 * those are guaranteed to never block on a sleeping lock.
 	 * Here we are enforcing that the allocation doesn't ever spin
 	 * on any locks (i.e. only trylocks). There is no high level
-	 * GFP_$FOO flag for this use in try_alloc_pages() as the
+	 * GFP_$FOO flag for this use in alloc_pages_nolock() as the
 	 * regular page allocator doesn't fully support this
 	 * allocation mode.
 	 */
@@ -354,8 +354,8 @@ static inline struct page *alloc_page_vm
 }
 #define alloc_page_vma(...)			alloc_hooks(alloc_page_vma_noprof(__VA_ARGS__))
 
-struct page *try_alloc_pages_noprof(int nid, unsigned int order);
-#define try_alloc_pages(...)			alloc_hooks(try_alloc_pages_noprof(__VA_ARGS__))
+struct page *alloc_pages_nolock_noprof(int nid, unsigned int order);
+#define alloc_pages_nolock(...)			alloc_hooks(alloc_pages_nolock_noprof(__VA_ARGS__))
 
 extern unsigned long get_free_pages_noprof(gfp_t gfp_mask, unsigned int order);
 #define __get_free_pages(...)			alloc_hooks(get_free_pages_noprof(__VA_ARGS__))
--- a/kernel/bpf/syscall.c~mm-rename-try_alloc_pages-to-alloc_pages_nolock
+++ a/kernel/bpf/syscall.c
@@ -578,7 +578,7 @@ static bool can_alloc_pages(void)
 static struct page *__bpf_alloc_page(int nid)
 {
 	if (!can_alloc_pages())
-		return try_alloc_pages(nid, 0);
+		return alloc_pages_nolock(nid, 0);
 
 	return alloc_pages_node(nid,
 				GFP_KERNEL | __GFP_ZERO | __GFP_ACCOUNT
--- a/mm/page_alloc.c~mm-rename-try_alloc_pages-to-alloc_pages_nolock
+++ a/mm/page_alloc.c
@@ -5070,7 +5070,7 @@ EXPORT_SYMBOL(__free_pages);
 
 /*
  * Can be called while holding raw_spin_lock or from IRQ and NMI for any
- * page type (not only those that came from try_alloc_pages)
+ * page type (not only those that came from alloc_pages_nolock)
  */
 void free_pages_nolock(struct page *page, unsigned int order)
 {
@@ -7311,20 +7311,21 @@ static bool __free_unaccepted(struct pag
 #endif /* CONFIG_UNACCEPTED_MEMORY */
 
 /**
- * try_alloc_pages - opportunistic reentrant allocation from any context
+ * alloc_pages_nolock - opportunistic reentrant allocation from any context
  * @nid: node to allocate from
  * @order: allocation order size
  *
  * Allocates pages of a given order from the given node. This is safe to
  * call from any context (from atomic, NMI, and also reentrant
- * allocator -> tracepoint -> try_alloc_pages_noprof).
+ * allocator -> tracepoint -> alloc_pages_nolock_noprof).
  * Allocation is best effort and to be expected to fail easily so nobody should
  * rely on the success. Failures are not reported via warn_alloc().
  * See always fail conditions below.
  *
- * Return: allocated page or NULL on failure.
+ * Return: allocated page or NULL on failure. NULL does not mean EBUSY or EAGAIN.
+ * It means ENOMEM. There is no reason to call it again and expect !NULL.
  */
-struct page *try_alloc_pages_noprof(int nid, unsigned int order)
+struct page *alloc_pages_nolock_noprof(int nid, unsigned int order)
 {
 	/*
 	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
@@ -7333,7 +7334,7 @@ struct page *try_alloc_pages_noprof(int
 	 *
 	 * These two are the conditions for gfpflags_allow_spinning() being true.
 	 *
-	 * Specify __GFP_NOWARN since failing try_alloc_pages() is not a reason
+	 * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
 	 * to warn. Also warn would trigger printk() which is unsafe from
 	 * various contexts. We cannot use printk_deferred_enter() to mitigate,
 	 * since the running context is unknown.
@@ -7343,7 +7344,7 @@ struct page *try_alloc_pages_noprof(int
 	 * BPF use cases.
 	 *
 	 * Though __GFP_NOMEMALLOC is not checked in the code path below,
-	 * specify it here to highlight that try_alloc_pages()
+	 * specify it here to highlight that alloc_pages_nolock()
 	 * doesn't want to deplete reserves.
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC
--- a/mm/page_owner.c~mm-rename-try_alloc_pages-to-alloc_pages_nolock
+++ a/mm/page_owner.c
@@ -302,7 +302,7 @@ void __reset_page_owner(struct page *pag
 	/*
 	 * Do not specify GFP_NOWAIT to make gfpflags_allow_spinning() == false
 	 * to prevent issues in stack_depot_save().
-	 * This is similar to try_alloc_pages() gfp flags, but only used
+	 * This is similar to alloc_pages_nolock() gfp flags, but only used
 	 * to signal stack_depot to avoid spin_locks.
 	 */
 	handle = save_stack(__GFP_NOWARN);
_

Patches currently in -mm which might be from ast@kernel.org are


