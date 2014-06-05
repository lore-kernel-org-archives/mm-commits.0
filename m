From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-remove-the-first-mapping-check.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:50:11 -0700
Message-ID: <5390c9f3.JK23BKsqjCDun1YN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaFETuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, b32955@freescale.com

Subject: [merged] mm-mmap-remove-the-first-mapping-check.patch removed from -mm tree
To: b32955@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:11 -0700


The patch titled
     Subject: mm/mmap.c: remove the first mapping check
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-the-first-mapping-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Shijie <b32955@freescale.com>
Subject: mm/mmap.c: remove the first mapping check

Remove the first mapping check for vma_link.  Move the mutex_lock into the
braces when vma->vm_file is true.

Signed-off-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmap-remove-the-first-mapping-check mm/mmap.c
--- a/mm/mmap.c~mm-mmap-remove-the-first-mapping-check
+++ a/mm/mmap.c
@@ -640,11 +640,10 @@ static void vma_link(struct mm_struct *m
 {
 	struct address_space *mapping = NULL;
 
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
