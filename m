From: akpm@linux-foundation.org
Subject: + mm-fix-null-ptr-deref-when-walking-hugepages.patch added to -mm tree
Date: Wed, 23 May 2012 15:26:16 -0700
Message-ID: <20120523222617.B8850A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44948 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2EWW0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 18:26:20 -0400
Received: by wibhn6 with SMTP id hn6so316435wib.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 15:26:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, aarcange@redhat.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: mm: fix NULL ptr deref when walking hugepages
has been added to the -mm tree.  Its filename is
     mm-fix-null-ptr-deref-when-walking-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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
Subject: Subject: mm: fix NULL ptr deref when walking hugepages

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch
mm-fix-null-ptr-deref-when-walking-hugepages.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch
isdn-add-missing-kern_cont-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch

