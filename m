From: akpm@linux-foundation.org
Subject: +
 mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch added
 to -mm tree
Date: Fri, 27 Dec 2013 14:43:39 -0800
Message-ID: <52be029b.4J7E0j+CmZHtQAaV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3L0Wnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Dec 2013 17:43:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com

Subject: + mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch added to -mm tree
To: sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 27 Dec 2013 14:43:39 -0800


The patch titled
     Subject: mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE fix
has been added to the -mm tree.  Its filename is
     mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE fix

I messed up and forgot to commit this fix before sending out the original
patch.

It fixes build issues in various files using VM_BUG_ON_PAGE.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mmdebug.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix
+++ a/include/linux/mmdebug.h
@@ -2,6 +2,7 @@
 #define LINUX_MM_DEBUG_H 1
 
 #ifdef CONFIG_DEBUG_VM
+extern void dump_page(struct page *page);
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #define VM_BUG_ON_PAGE(cond, page) \
 	do { if (unlikely(cond)) { dump_page(page); BUG(); } } while(0)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-remove-bogus-warning-in-copy_huge_pmd.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch
linux-next.patch

