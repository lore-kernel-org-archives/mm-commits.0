Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737EDC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A8866120A
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhJOU2f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238545AbhJOU2f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 16:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF7B561205;
        Fri, 15 Oct 2021 20:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634329588;
        bh=AqtJ+zIeiEafEkd24bXSWeabwUtxtCrJKAjfeR1/QGQ=;
        h=Date:From:To:Subject:From;
        b=sam0H+diDs/5+3QKPY5NTUJr2sI/9IjF3V6Ainghe0T5RQXDFjZAKppZneEb3xG3P
         41EZltXwaBPo1ygk9+EuEZ0gSTboWztOXq0LBGPHvtMqWsWlpu5+m/9+RlslKrPIca
         bx72rjX6DN2M/61qopHjRGRsMBvcc+4L2vdHr6YI=
Date:   Fri, 15 Oct 2021 13:26:27 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  + mm-hwpoison-refactor-refcount-check-handling.patch
 added to -mm tree
Message-ID: <20211015202627.6vbtnxPJ4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: refactor refcount check handling
has been added to the -mm tree.  Its filename is
     mm-hwpoison-refactor-refcount-check-handling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-refactor-refcount-check-handling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-refactor-refcount-check-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: refactor refcount check handling

Memory failure will report failure if the page still has extra pinned
refcount other than from hwpoison after the handler is done.  Actually the
check is not necessary for all handlers, so move the check into specific
handlers.  This would make the following keeping shmem page in page cache
patch easier.

There may be expected extra pin for some cases, for example, when the page
is dirty and in swapcache.

Link: https://lkml.kernel.org/r/20211014191615.6674-5-shy828301@gmail.com
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   93 ++++++++++++++++++++++++++++--------------
 1 file changed, 64 insertions(+), 29 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-refactor-refcount-check-handling
+++ a/mm/memory-failure.c
@@ -807,12 +807,44 @@ static int truncate_error_page(struct pa
 	return ret;
 }
 
+struct page_state {
+	unsigned long mask;
+	unsigned long res;
+	enum mf_action_page_type type;
+
+	/* Callback ->action() has to unlock the relevant page inside it. */
+	int (*action)(struct page_state *ps, struct page *p);
+};
+
+/*
+ * Return true if page is still referenced by others, otherwise return
+ * false.
+ *
+ * The extra_pins is true when one extra refcount is expected.
+ */
+static bool has_extra_refcount(struct page_state *ps, struct page *p,
+			       bool extra_pins)
+{
+	int count = page_count(p) - 1;
+
+	if (extra_pins)
+		count -= 1;
+
+	if (count > 0) {
+		pr_err("Memory failure: %#lx: %s still referenced by %d users\n",
+		       page_to_pfn(p), action_page_types[ps->type], count);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Error hit kernel page.
  * Do nothing, try to be lucky and not touch this instead. For a few cases we
  * could be more sophisticated.
  */
-static int me_kernel(struct page *p, unsigned long pfn)
+static int me_kernel(struct page_state *ps, struct page *p)
 {
 	unlock_page(p);
 	return MF_IGNORED;
@@ -821,9 +853,9 @@ static int me_kernel(struct page *p, uns
 /*
  * Page in unknown state. Do nothing.
  */
-static int me_unknown(struct page *p, unsigned long pfn)
+static int me_unknown(struct page_state *ps, struct page *p)
 {
-	pr_err("Memory failure: %#lx: Unknown page state\n", pfn);
+	pr_err("Memory failure: %#lx: Unknown page state\n", page_to_pfn(p));
 	unlock_page(p);
 	return MF_FAILED;
 }
@@ -831,7 +863,7 @@ static int me_unknown(struct page *p, un
 /*
  * Clean (or cleaned) page cache page.
  */
-static int me_pagecache_clean(struct page *p, unsigned long pfn)
+static int me_pagecache_clean(struct page_state *ps, struct page *p)
 {
 	int ret;
 	struct address_space *mapping;
@@ -868,9 +900,13 @@ static int me_pagecache_clean(struct pag
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
-	ret = truncate_error_page(p, pfn, mapping);
+	ret = truncate_error_page(p, page_to_pfn(p), mapping);
 out:
 	unlock_page(p);
+
+	if (has_extra_refcount(ps, p, false))
+		ret = MF_FAILED;
+
 	return ret;
 }
 
@@ -879,7 +915,7 @@ out:
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
-static int me_pagecache_dirty(struct page *p, unsigned long pfn)
+static int me_pagecache_dirty(struct page_state *ps, struct page *p)
 {
 	struct address_space *mapping = page_mapping(p);
 
@@ -923,7 +959,7 @@ static int me_pagecache_dirty(struct pag
 		mapping_set_error(mapping, -EIO);
 	}
 
-	return me_pagecache_clean(p, pfn);
+	return me_pagecache_clean(ps, p);
 }
 
 /*
@@ -945,9 +981,10 @@ static int me_pagecache_dirty(struct pag
  * Clean swap cache pages can be directly isolated. A later page fault will
  * bring in the known good data from disk.
  */
-static int me_swapcache_dirty(struct page *p, unsigned long pfn)
+static int me_swapcache_dirty(struct page_state *ps, struct page *p)
 {
 	int ret;
+	bool extra_pins = false;
 
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
@@ -955,10 +992,17 @@ static int me_swapcache_dirty(struct pag
 
 	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
 	unlock_page(p);
+
+	if (ret == MF_DELAYED)
+		extra_pins = true;
+
+	if (has_extra_refcount(ps, p, extra_pins))
+		ret = MF_FAILED;
+
 	return ret;
 }
 
-static int me_swapcache_clean(struct page *p, unsigned long pfn)
+static int me_swapcache_clean(struct page_state *ps, struct page *p)
 {
 	int ret;
 
@@ -966,6 +1010,10 @@ static int me_swapcache_clean(struct pag
 
 	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
 	unlock_page(p);
+
+	if (has_extra_refcount(ps, p, false))
+		ret = MF_FAILED;
+
 	return ret;
 }
 
@@ -975,7 +1023,7 @@ static int me_swapcache_clean(struct pag
  * - Error on hugepage is contained in hugepage unit (not in raw page unit.)
  *   To narrow down kill region to one page, we need to break up pmd.
  */
-static int me_huge_page(struct page *p, unsigned long pfn)
+static int me_huge_page(struct page_state *ps, struct page *p)
 {
 	int res;
 	struct page *hpage = compound_head(p);
@@ -986,7 +1034,7 @@ static int me_huge_page(struct page *p,
 
 	mapping = page_mapping(hpage);
 	if (mapping) {
-		res = truncate_error_page(hpage, pfn, mapping);
+		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
 		unlock_page(hpage);
 	} else {
 		res = MF_FAILED;
@@ -1004,6 +1052,9 @@ static int me_huge_page(struct page *p,
 		}
 	}
 
+	if (has_extra_refcount(ps, p, false))
+		res = MF_FAILED;
+
 	return res;
 }
 
@@ -1029,14 +1080,7 @@ static int me_huge_page(struct page *p,
 #define slab		(1UL << PG_slab)
 #define reserved	(1UL << PG_reserved)
 
-static struct page_state {
-	unsigned long mask;
-	unsigned long res;
-	enum mf_action_page_type type;
-
-	/* Callback ->action() has to unlock the relevant page inside it. */
-	int (*action)(struct page *p, unsigned long pfn);
-} error_states[] = {
+static struct page_state error_states[] = {
 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
@@ -1096,19 +1140,10 @@ static int page_action(struct page_state
 			unsigned long pfn)
 {
 	int result;
-	int count;
 
 	/* page p should be unlocked after returning from ps->action().  */
-	result = ps->action(p, pfn);
+	result = ps->action(ps, p);
 
-	count = page_count(p) - 1;
-	if (ps->action == me_swapcache_dirty && result == MF_DELAYED)
-		count--;
-	if (count > 0) {
-		pr_err("Memory failure: %#lx: %s still referenced by %d users\n",
-		       pfn, action_page_types[ps->type], count);
-		result = MF_FAILED;
-	}
 	action_result(pfn, ps->type, result);
 
 	/* Could do more checks here if page looks ok */
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

