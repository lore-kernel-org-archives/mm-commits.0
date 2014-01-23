From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch
 removed from -mm tree
Date: Thu, 23 Jan 2014 15:17:40 -0800
Message-ID: <52e1a314.OacZXu0HaokMoBJy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAWXRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com

Subject: [folded-merged] mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch removed from -mm tree
To: sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:17:40 -0800


The patch titled
     Subject: mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE fix
has been removed from the -mm tree.  Its filename was
     mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix.patch

This patch was dropped because it was folded into mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch

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

origin.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch

