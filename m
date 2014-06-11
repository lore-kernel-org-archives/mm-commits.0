From: akpm@linux-foundation.org
Subject: + mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch added to -mm tree
Date: Wed, 11 Jun 2014 16:10:50 -0700
Message-ID: <5398e1fa.HeFPV9nGT9DjJSiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaFKXKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, sasha.levin@oracle.com, koct9i@gmail.com, kirill.shutemov@linux.intel.com, hughd@google.com

Subject: + mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch added to -mm tree
To: hughd@google.com,kirill.shutemov@linux.intel.com,koct9i@gmail.com,sasha.levin@oracle.com,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:10:50 -0700


The patch titled
     Subject: mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()
has been added to the -mm tree.  Its filename is
     mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()

Use ACCESS_ONCE() in handle_pte_fault() when getting the entry or orig_pte
upon which all subsequent decisions and pte_same() tests will be made.

I have no evidence that its lack is responsible for the mm/filemap.c:202
BUG_ON(page_mapped(page)) in __delete_from_page_cache() found by trinity,
and I am not optimistic that it will fix it.  But I have found no other
explanation, and ACCESS_ONCE() here will surely not hurt.

If gcc does re-access the pte before passing it down, then that would be
disastrous for correct page fault handling, and certainly could explain
the page_mapped() BUGs seen (concurrent fault causing page to be mapped in
a second time on top of itself: mapcount 2 for a single pte).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault mm/memory.c
--- a/mm/memory.c~mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault
+++ a/mm/memory.c
@@ -3177,7 +3177,7 @@ static int handle_pte_fault(struct mm_st
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = *pte;
+	entry = ACCESS_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

