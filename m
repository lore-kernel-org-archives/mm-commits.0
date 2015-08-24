From: akpm@linux-foundation.org
Subject: + mm-mmap-check-all-failures-before-set-values.patch added to -mm tree
Date: Mon, 24 Aug 2015 14:26:06 -0700
Message-ID: <55db8bee.EBphhGs0WQ3XDCaI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbHXV0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 17:26:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c:insert_vm_struct(): check for failure before setting values
has been added to the -mm tree.  Its filename is
     mm-mmap-check-all-failures-before-set-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-check-all-failures-before-set-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-check-all-failures-before-set-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c:insert_vm_struct(): check for failure before setting values

There's no point in initializing vma->vm_pgoff if the insertion attempt
will be failing anyway.  Run the checks before performing the
initialization.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmap-check-all-failures-before-set-values mm/mmap.c
--- a/mm/mmap.c~mm-mmap-check-all-failures-before-set-values
+++ a/mm/mmap.c
@@ -2859,6 +2859,13 @@ int insert_vm_struct(struct mm_struct *m
 	struct vm_area_struct *prev;
 	struct rb_node **rb_link, *rb_parent;
 
+	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
+			   &prev, &rb_link, &rb_parent))
+		return -ENOMEM;
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
+		return -ENOMEM;
+
 	/*
 	 * The vm_pgoff of a purely anonymous vma should be irrelevant
 	 * until its first write fault, when page's anon_vma and index
@@ -2875,12 +2882,6 @@ int insert_vm_struct(struct mm_struct *m
 		BUG_ON(vma->anon_vma);
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
 	}
-	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
-			   &prev, &rb_link, &rb_parent))
-		return -ENOMEM;
-	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
-		return -ENOMEM;
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

mm-mmap-simplify-the-failure-return-working-flow.patch
mm-mmap-check-all-failures-before-set-values.patch

