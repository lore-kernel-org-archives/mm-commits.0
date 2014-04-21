From: akpm@linux-foundation.org
Subject: + mm-mmap-remove-the-first-mapping-check.patch added to -mm tree
Date: Mon, 21 Apr 2014 15:36:17 -0700
Message-ID: <53559d61.pHeoJxAOJEGR24MH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaDUWgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, b32955@freescale.com

Subject: + mm-mmap-remove-the-first-mapping-check.patch added to -mm tree
To: b32955@freescale.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:36:17 -0700


The patch titled
     Subject: mm/mmap.c: remove the first mapping check
has been added to the -mm tree.  Its filename is
     mm-mmap-remove-the-first-mapping-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-remove-the-first-mapping-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-remove-the-first-mapping-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -643,11 +643,10 @@ static void vma_link(struct mm_struct *m
 {
 	struct address_space *mapping = NULL;
 
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
