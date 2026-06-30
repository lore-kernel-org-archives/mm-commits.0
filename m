Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B64347B41D
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782852939; cv=none; b=I2seLIm5xsrUTiF0Tj2xg1nBxP1hwgM9aZNtiPTQieguNctzGOXhXJYc74UGJTnd61mMBAswXxZEsI2/8xyQ6ZVGAbjTa5FgYGFCQeF4t0ooxXoq6aULyMpX4pXVC3W33iV1krOUBDb8QDen6WXcQkTE9vIa0ZIKRXhLrubyBAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782852939; c=relaxed/simple;
	bh=TgMEW/+OwGfprjv7jFt3yve8nyOhZMBLZvFYtKhET/M=;
	h=Date:To:From:Subject:Message-Id; b=eIR7SjwClWa+en407yMc9Q5QCUMmYN+OGqQ3j3cTdzucwJlZK/jmHY6OMiUAbY9ddlmXliGTLGdf7oRtz+6zepMDkY767SFRA8ZT7Kvz/McpxeyJCHhMGL7fa/caltVXnmFzCeWFUd4liME2nZ9C7O9KXnNGX//m/vj8mIHUdI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lyAru1qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lyAru1qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAC61F000E9;
	Tue, 30 Jun 2026 20:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852938;
	bh=VwQViRsov/BuWos68gRb5al/u4HGHffPoW6VdPd7iFY=;
	h=Date:To:From:Subject;
	b=lyAru1qi5U83xlOV1SRqsvNvQFdd80Aogj/F8QBIa2wzi5byDEOmNJXgRUSfrEU9i
	 hDxVr1ZJ4zWycwOSJHzjt3wSlWTHnFk/91bdL/JGZ7qr189LkHIRHkQwWIynNEWqkG
	 dK5tQwPJT3IlK5HZ8BUV0dK51t05yAUqfyZNmuVc=
Date: Tue, 30 Jun 2026 13:55:37 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch added to mm-unstable branch
Message-Id: <20260630205537.EFAC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: surface unhandlable kernel pages as -ENOTRECOVERABLE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: surface unhandlable kernel pages as -ENOTRECOVERABLE
Date: Tue, 30 Jun 2026 05:46:05 -0700

get_any_page() collapses every HWPoisonHandlable() rejection into a
single -EIO via the __get_hwpoison_page() -> -EBUSY -> shake_page()
-> retry path.  That is correct for the transient case (a userspace
folio briefly off LRU during migration or compaction, which a later
shake can drag back), but wrong for stable kernel-owned pages: slab,
page-table, large-kmalloc and PG_reserved pages will never become
HWPoisonHandlable(), so the retry loop is wasted work and the final
-EIO loses the "this is structurally unrecoverable" information.
memory_failure() then maps -EIO into MF_MSG_GET_HWPOISON, which the
panic-on-unrecoverable sysctl deliberately does not act on.

Introduce is_kernel_owned_page(), a small predicate that positively
identifies pages the hwpoison handler cannot recover from:

  is_kernel_owned_page(p) :=
      PageReserved(p) ||
      PageSlab(head) || PageTable(head) || PageLargeKmalloc(head)

  where head = compound_head(p).

PG_reserved is a per-page flag (PF_NO_COMPOUND) and is tested on the
page directly.  The slab, page-table and large-kmalloc page-type bits
are only stored on the head page, so those tests resolve the compound
head first, then re-read compound_head(page) afterwards: a concurrent
split or compound free that moves head invalidates the just-read flags
and the loop retries.  The lookup still takes no refcount, mirroring
the rest of get_any_page(); the recheck closes the common split race,
and a residual free->alloc->free in the same window can only mis-tag
a genuinely poisoned page, never reclassify a handlable one.

No MF_SOFT_OFFLINE / page_has_movable_ops() opt-out is needed: a
movable_ops page is always PageOffline or PageZsmalloc, whose page_type is
mutually exclusive with slab, page-table and large-kmalloc, and it never
carries PG_reserved, so it can never match any of the checks above.

The list is intentionally not exhaustive.  vmalloc and kernel-stack pages,
for example, do not carry a page_type bit and would need a different
oracle; they keep going through the existing retry path unchanged.  This
is the smallest set we can identify with certainty by page type.

Wire the helper into the top of get_any_page() to short-circuit those
pages before the retry loop runs.  On a hit, drop the caller's
MF_COUNT_INCREASED reference (if any) and return -ENOTRECOVERABLE straight
away.  Pages outside the helper's positive list still take the existing
retry path and return -EIO, leaving operator-visible behaviour for those
cases unchanged.

Extend the unhandlable-page pr_err() to fire for either errno and update
the get_hwpoison_page() kerneldoc to document the new return.

memory_failure() still folds every negative return into
MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so this
patch on its own only changes the errno that soft_offline_page() can
propagate to its callers.  A follow-up wires -ENOTRECOVERABLE through
memory_failure() and reports MF_MSG_KERNEL for the unrecoverable cases,
which is what the panic_on_unrecoverable_memory_failure sysctl observes.

Link: https://lore.kernel.org/20260630-ecc_panic-v10-2-c6ed5b62eea2@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   52 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable
+++ a/mm/memory-failure.c
@@ -1325,6 +1325,38 @@ static inline bool HWPoisonHandlable(str
 	return PageLRU(page) || is_free_buddy_page(page);
 }
 
+/*
+ * Positive identification of pages the hwpoison handler cannot recover:
+ * pages owned by kernel internals with no userspace mapping to unmap, no
+ * file mapping to invalidate, and no migration target.
+ */
+static inline bool is_kernel_owned_page(struct page *page)
+{
+	struct page *head;
+	bool kernel_owned;
+
+	/* PG_reserved is a per-page flag, never set on a compound page. */
+	if (PageReserved(page))
+		return true;
+
+	/*
+	 * Page-type bits live only on the head page, so resolve any tail
+	 * first.  The check takes no refcount; recheck the head afterwards
+	 * so a concurrent split or compound free cannot leave us trusting
+	 * a stale view.  A residual free->alloc->free cannot be closed here
+	 * (frozen slab and large-kmalloc pages cannot be pinned), but is
+	 * harmless: where a wrong verdict could panic, memory_failure() has
+	 * already set PageHWPoison, which bars the page from the allocator.
+	 */
+retry:
+	head = compound_head(page);
+	kernel_owned = PageSlab(head) || PageTable(head) ||
+		       PageLargeKmalloc(head);
+	if (head != compound_head(page))
+		goto retry;
+	return kernel_owned;
+}
+
 static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
 	struct folio *folio = page_folio(page);
@@ -1371,6 +1403,19 @@ static int get_any_page(struct page *p,
 	if (flags & MF_COUNT_INCREASED)
 		count_increased = true;
 
+	/*
+	 * Page types we know are kernel-owned and cannot be recovered.
+	 * Short-circuit before the shake_page() / retry loop, which
+	 * cannot turn any of these into something HWPoisonHandlable().
+	 * Drop the caller's reference if MF_COUNT_INCREASED took one.
+	 */
+	if (is_kernel_owned_page(p)) {
+		if (count_increased)
+			put_page(p);
+		ret = -ENOTRECOVERABLE;
+		goto out;
+	}
+
 try_again:
 	if (!count_increased) {
 		ret = __get_hwpoison_page(p, flags);
@@ -1418,7 +1463,7 @@ try_again:
 		ret = -EIO;
 	}
 out:
-	if (ret == -EIO)
+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
@@ -1475,7 +1520,10 @@ static int __get_unpoison_page(struct pa
  *         -EIO for pages on which we can not handle memory errors,
  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
  *         operations like allocation and free,
- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
+ *         -ENOTRECOVERABLE for kernel-owned pages identified by
+ *         is_kernel_owned_page() (PG_reserved, slab,
+ *         page-table, large-kmalloc) that the handler cannot recover.
  */
 static int get_hwpoison_page(struct page *p, unsigned long flags)
 {
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

