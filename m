From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:32:30 -0800
Message-ID: <5699737e.rVY36e4+7K4U1V/z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbcAOWca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove redundant local variables for may_expand_vm()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c: remove redundant local variables for may_expand_vm()

Simplify may_expand_vm().

[akpm@linux-foundation.org: further simplification, per Naoya Horiguchi]
Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-remove-redundant-local-variables-for-may_expand_vm mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-redundant-local-variables-for-may_expand_vm
+++ a/mm/mmap.c
@@ -2988,14 +2988,7 @@ out:
  */
 int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 {
-	unsigned long cur = mm->total_vm;	/* pages */
-	unsigned long lim;
-
-	lim = rlimit(RLIMIT_AS) >> PAGE_SHIFT;
