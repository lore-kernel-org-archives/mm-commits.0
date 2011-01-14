From: akpm@linux-foundation.org
Subject: [merged] thp-update-futex-compound-knowledge.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:30 -0800
Message-ID: <201101142249.p0EMnKO2005284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab1ANWt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: update futex compound knowledge
has been removed from the -mm tree.  Its filename was
     thp-update-futex-compound-knowledge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: update futex compound knowledge
From: Andrea Arcangeli <aarcange@redhat.com>

Futex code is smarter than most other gup_fast O_DIRECT code and knows
about the compound internals.  However now doing a put_page(head_page)
will not release the pin on the tail page taken by gup-fast, leading to
all sort of refcounting bugchecks.  Getting a stable head_page is a little
tricky.

page_head = page is there because if this is not a tail page it's also the
page_head.  Only in case this is a tail page, compound_head is called,
otherwise it's guaranteed unnecessary.  And if it's a tail page
compound_head has to run atomically inside irq disabled section
__get_user_pages_fast before returning.  Otherwise ->first_page won't be a
stable pointer.

Disableing irq before __get_user_page_fast and releasing irq after running
compound_head is needed because if __get_user_page_fast returns == 1, it
means the huge pmd is established and cannot go away from under us. 
pmdp_splitting_flush_notify in __split_huge_page_splitting will have to
wait for local_irq_enable before the IPI delivery can return.  This means
__split_huge_page_refcount can't be running from under us, and in turn
when we run compound_head(page) we're not reading a dangling pointer from
tailpage->first_page.  Then after we get to stable head page, we are
always safe to call compound_lock and after taking the compound lock on
head page we can finally re-check if the page returned by gup-fast is
still a tail page.  in which case we're set and we didn't need to split
the hugepage in order to take a futex on it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   55 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff -puN kernel/futex.c~thp-update-futex-compound-knowledge kernel/futex.c
--- a/kernel/futex.c~thp-update-futex-compound-knowledge
+++ a/kernel/futex.c
@@ -233,7 +233,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
-	struct page *page;
+	struct page *page, *page_head;
 	int err;
 
 	/*
@@ -265,11 +265,46 @@ again:
 	if (err < 0)
 		return err;
 
-	page = compound_head(page);
-	lock_page(page);
-	if (!page->mapping) {
-		unlock_page(page);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	page_head = page;
+	if (unlikely(PageTail(page))) {
 		put_page(page);
+		/* serialize against __split_huge_page_splitting() */
+		local_irq_disable();
+		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+			page_head = compound_head(page);
+			/*
+			 * page_head is valid pointer but we must pin
+			 * it before taking the PG_lock and/or
+			 * PG_compound_lock. The moment we re-enable
+			 * irqs __split_huge_page_splitting() can
+			 * return and the head page can be freed from
+			 * under us. We can't take the PG_lock and/or
+			 * PG_compound_lock on a page that could be
+			 * freed from under us.
+			 */
+			if (page != page_head) {
+				get_page(page_head);
+				put_page(page);
+			}
+			local_irq_enable();
+		} else {
+			local_irq_enable();
+			goto again;
+		}
+	}
+#else
+	page_head = compound_head(page);
+	if (page != page_head) {
+		get_page(page_head);
+		put_page(page);
+	}
+#endif
+
+	lock_page(page_head);
+	if (!page_head->mapping) {
+		unlock_page(page_head);
+		put_page(page_head);
 		goto again;
 	}
 
@@ -280,20 +315,20 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page)) {
+	if (PageAnon(page_head)) {
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page->mapping->host;
-		key->shared.pgoff = page->index;
+		key->shared.inode = page_head->mapping->host;
+		key->shared.pgoff = page_head->index;
 	}
 
 	get_futex_key_refs(key);
 
-	unlock_page(page);
-	put_page(page);
+	unlock_page(page_head);
+	put_page(page_head);
 	return 0;
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

