From: akpm@linux-foundation.org
Subject: + mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range.patch added to -mm tree
Date: Fri, 09 Jul 2010 17:00:42 -0700
Message-ID: <201007100000.o6A00gOW000759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab0GJABC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 20:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, aarcange@redhat.com, avi@qumranet.com, jeremy.fitzhardinge@citrix.com, stefano.stabellini@eu.citrix.com


The patch titled
     mmu-notifiers: remove mmu notifier calls in apply_to_page_range()
has been added to the -mm tree.  Its filename is
     mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmu-notifiers: remove mmu notifier calls in apply_to_page_range()
From: Jeremy Fitzhardinge <jeremy@goop.org>

It is not appropriate for apply_to_page_range() to directly call any mmu
notifiers, because it is a general purpose function whose effect depends
on what context it is called in and what the callback function does.

In particular, if it is being used as part of an mmu notifier
implementation, the recursive calls can be particularly problematic.

It is up to apply_to_page_range's caller to do any notifier calls if
necessary.  It does not affect any in-tree users because they all operate
on init_mm, and mmu notifiers only pertain to usermode mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memory.c~mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range mm/memory.c
--- a/mm/memory.c~mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range
+++ a/mm/memory.c
@@ -2000,7 +2000,6 @@ int apply_to_page_range(struct mm_struct
 	int err;
 
 	BUG_ON(addr >= end);
-	mmu_notifier_invalidate_range_start(mm, start, end);
 	pgd = pgd_offset(mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
@@ -2008,7 +2007,7 @@ int apply_to_page_range(struct mm_struct
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	mmu_notifier_invalidate_range_end(mm, start, end);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range.patch

