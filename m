Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E52434DCC7
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 20:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782852613; cv=none; b=uEtHQUqVMwC8pjEtTzi+BYo0ONgbAD8ynJQOM4z3sf1rB3ptmkaf5tg7uDpFXXhelsqmHPM9FyoEMKOML0PnoL8VQSTVQvzPc9JkfXUF0fV8QYEBaKQ4MlyvdY97wu0UyfeGlU7lARL7vgdmEkyql+ifR2DQwKZhRhMCunk9Xp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782852613; c=relaxed/simple;
	bh=HpPwTWZAzWpyCvJ1vy1ICWIXIGvkhNfk6GdEYvv0fNA=;
	h=Date:To:From:Subject:Message-Id; b=CuFuC4w1jUOpFcy3HRbPGq26EKbPmPUFN/azboBca31kgYTuURJi7X+n3CJ5EbqLRmMSrSiqEArpRov6R35aPbIYpOCZBaEy7lrqw0x0EDSGrazfETlxXql9Q0sI7Ipw0ZS0uS6nqZqznVloJfEmEAvwgf7MsU2UZ/TRCcJduOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k4eS8NhZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k4eS8NhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845351F000E9;
	Tue, 30 Jun 2026 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852611;
	bh=WDDo3tZ/AHiP7tx3fi1FIvUhhDQU7ZC37etcPih5q6g=;
	h=Date:To:From:Subject;
	b=k4eS8NhZGp8BwdIQJQWLdL7NSK6OxSKfPakKSrh4C0wmJ/PgvkeDeImv/0zYlLYbf
	 tOxcy1Ys71jH22CQoNVIioyteUS/k8vweQPHO7EBKCg8sjy1CgCNlF5vwN8fm3osO8
	 CcRnLDUDS0oiqOfVMcYnC7e8fTyBLVwinGeGB0Os=
Date: Tue, 30 Jun 2026 13:50:11 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch removed from -mm tree
Message-Id: <20260630205011.845351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: drop dead error_states[] entry for reserved pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: drop dead error_states[] entry for reserved pages
Date: Fri, 26 Jun 2026 08:33:15 -0700

Patch series "mm/memory-failure: add panic option for unrecoverable
pages", v10.

A multi-bit ECC error on a kernel-owned page that the memory failure
handler cannot recover is currently swallowed: PG_hwpoison is set, the
event is logged, and the kernel keeps running.  The corrupted memory
remains accessible to the kernel and either drives silent data corruption
or surfaces seconds-to-minutes later as an apparently unrelated crash.  In
a large fleet that delayed, unattributable crash turns into significant
engineering effort to root-cause; in a kdump configuration, by the time
the crash happens the original error context (faulting PFN, MCE/GHES
record, page state) is long gone.

This series adds an opt-in sysctl,
vm.panic_on_unrecoverable_memory_failure, that converts an unrecoverable
kernel-page hwpoison event into an immediate panic with a clean
dmesg/vmcore that still contains the original failure context.  The
default is disabled so existing workloads see no change.

There is a selftest that test different cases, and I tested it using the
following variants:

  ┌─────────┬──────────┬───────────────────────────────────────────────────────────┐
  │ Variant │   PFN    │                          Result                           │
  ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
  │ rodata  │ 0x2600   │ Panic with "Memory failure: 0x2600: unrecoverable page"   │
  ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
  │ slab    │ 0x100032 │ Panic with "Memory failure: 0x100032: unrecoverable page" │
  ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
  │ pgtable │ 0x100000 │ Panic with "Memory failure: 0x100000: unrecoverable page" │
  └─────────┴──────────┴───────────────────────────────────────────────────────────┘

Each one shows the same call trace, exactly the path the series builds:

  hard_offline_page_store
    → memory_failure
      → action_result
        → panic("Memory failure: %#lx: unrecoverable page")


This patch (of 6):

The first entry of error_states[],

	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },

is unreachable.  identify_page_state() has two callers, and neither one
can dispatch a PG_reserved page to me_kernel():

  * memory_failure() reaches identify_page_state() only after
    get_hwpoison_page() returned 1.  get_any_page() reaches that
    return only via __get_hwpoison_page(), which only takes a
    refcount when the page is HWPoisonHandlable().
    HWPoisonHandlable() is an allowlist for LRU, free-buddy, and
    (for soft-offline) movable_ops pages -- PG_reserved pages do
    not satisfy any of these, so they fail with -EBUSY/-EIO long
    before identify_page_state() runs.

  * try_memory_failure_hugetlb() reaches identify_page_state() only
    via the MF_HUGETLB_IN_USED branch, where the page is necessarily
    a hugetlb folio.  hugetlb folios don't carry PG_reserved at that
    point: hugetlb_folio_init_vmemmap() calls __folio_clear_reserved()
    during init, so the reserved entry would not match even if it
    were still present.

me_kernel() never executes and the entry exists only to be matched against
by code that cannot see it.

Drop the entry, the me_kernel() helper, and the now-unused "reserved"
macro.  Leave the MF_MSG_KERNEL enum value in place: it remains part of
the tracepoint and pr_err() string tables, and follow-on work to classify
unrecoverable kernel pages can reuse it without churning the user-visible
enum.

No functional change.

Link: https://lore.kernel.org/20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org
Link: https://lore.kernel.org/20260626-ecc_panic-v10-1-6dacb8ad024d@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages
+++ a/mm/memory-failure.c
@@ -981,17 +981,6 @@ static bool has_extra_refcount(struct pa
 }
 
 /*
- * Error hit kernel page.
- * Do nothing, try to be lucky and not touch this instead. For a few cases we
- * could be more sophisticated.
- */
-static int me_kernel(struct page_state *ps, struct page *p)
-{
-	unlock_page(p);
-	return MF_IGNORED;
-}
-
-/*
  * Page in unknown state. Do nothing.
  * This is a catch-all in case we fail to make sense of the page state.
  */
@@ -1199,10 +1188,8 @@ static int me_huge_page(struct page_stat
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
-	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -1234,7 +1221,6 @@ static struct page_state error_states[]
 #undef mlock
 #undef lru
 #undef head
-#undef reserved
 
 static void update_per_node_mf_stats(unsigned long pfn,
 				     enum mf_result result)
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
a.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

