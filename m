From: akpm@linux-foundation.org
Subject: + mm-systems-without-mmu-do-not-need-pte_mkwrite.patch added to -mm tree
Date: Fri, 21 Jan 2011 00:01:17 -0800
Message-ID: <201101210801.p0L81HAx029936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab1AUIBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 03:01:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: monstr@monstr.eu, aarcange@redhat.com


The patch titled
     mm: systems without MMU do not need pte_mkwrite()
has been added to the -mm tree.  Its filename is
     mm-systems-without-mmu-do-not-need-pte_mkwrite.patch

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
Subject: mm: systems without MMU do not need pte_mkwrite()
From: Michal Simek <monstr@monstr.eu>

14fd403f214 ("thp: export maybe_mkwrite") break systems without MMU.

Error log:
  CC      arch/microblaze/mm/init.o
In file included from include/linux/mman.h:14,
                 from arch/microblaze/mm/consistent.c:24:
include/linux/mm.h: In function 'maybe_mkwrite':
include/linux/mm.h:482: error: implicit declaration of function 'pte_mkwrite'
include/linux/mm.h:482: error: incompatible types in assignment

Signed-off-by: Michal Simek <monstr@monstr.eu>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mm.h~mm-systems-without-mmu-do-not-need-pte_mkwrite include/linux/mm.h
--- a/include/linux/mm.h~mm-systems-without-mmu-do-not-need-pte_mkwrite
+++ a/include/linux/mm.h
@@ -470,6 +470,7 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
+#ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
  * servicing faults for write access.  In the normal case, do always want
@@ -482,6 +483,7 @@ static inline pte_t maybe_mkwrite(pte_t 
 		pte = pte_mkwrite(pte);
 	return pte;
 }
+#endif
 
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
_

Patches currently in -mm which might be from monstr@monstr.eu are

mm-systems-without-mmu-do-not-need-pte_mkwrite.patch
llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

