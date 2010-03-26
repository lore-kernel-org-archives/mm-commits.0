From: akpm@linux-foundation.org
Subject: [merged] mm-ksmc-is-doing-an-unneeded-_notify-in-write_protect_page.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:30 -0400
Message-ID: <201003261937.o2QJbToH016609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab0CZThg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, aarcange@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/ksm.c is doing an unneeded _notify in write_protect_page.
has been removed from the -mm tree.  Its filename was
     mm-ksmc-is-doing-an-unneeded-_notify-in-write_protect_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/ksm.c is doing an unneeded _notify in write_protect_page.
From: Robin Holt <holt@sgi.com>

ksm.c's write_protect_page implements a lockless means of verifying a page
does not have any users of the page which are not accounted for via other
kernel tracking means.  It does this by removing the writable pte with TLB
flushes, checking the page_count against the total known users, and then
using set_pte_at_notify to make it a read-only entry.

An unneeded mmu_notifier callout is made in the case where the known users
does not match the page_count.  In that event, we are inserting the
identical pte and there is no need for the set_pte_at_notify, but rather
the simpler set_pte_at suffices.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Izik Eidus <ieidus@redhat.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~mm-ksmc-is-doing-an-unneeded-_notify-in-write_protect_page mm/ksm.c
--- a/mm/ksm.c~mm-ksmc-is-doing-an-unneeded-_notify-in-write_protect_page
+++ a/mm/ksm.c
@@ -751,7 +751,7 @@ static int write_protect_page(struct vm_
 		 * page
 		 */
 		if (page_mapcount(page) + 1 + swapped != page_count(page)) {
-			set_pte_at_notify(mm, addr, ptep, entry);
+			set_pte_at(mm, addr, ptep, entry);
 			goto out_unlock;
 		}
 		entry = pte_wrprotect(entry);
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

