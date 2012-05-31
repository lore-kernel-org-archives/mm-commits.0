From: akpm@linux-foundation.org
Subject: [merged] mm-fix-null-ptr-deref-when-walking-hugepages.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:34 -0700
Message-ID: <20120531191334.71EB5A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:65320 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EaTNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:36 -0400
Received: by mail-we0-f202.google.com with SMTP id e53so75779wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, aarcange@redhat.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix NULL ptr deref when walking hugepages
has been removed from the -mm tree.  Its filename was
     mm-fix-null-ptr-deref-when-walking-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: mm: fix NULL ptr deref when walking hugepages

A missing vlidation of the value returned by find_vma() could cause a NULL ptr
dereference when walking the pagetable.

This is triggerable from usermode by a simple user by trying to read a
page info out of /proc/pid/pagemap which doesn't exist.

Introduced by commit 025c5b24 ("thp: optimize away unnecessary page table
locking").

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>		[3.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-fix-null-ptr-deref-when-walking-hugepages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-fix-null-ptr-deref-when-walking-hugepages
+++ a/fs/proc/task_mmu.c
@@ -784,7 +784,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
-	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (vma && pmd_trans_huge_lock(pmd, vma) == 1) {
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
 
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch
locking-add-kern_cont-when-needed-to-self-test.patch
isdn-add-missing-kern_cont.patch
isdn-add-missing-kern_cont-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch

