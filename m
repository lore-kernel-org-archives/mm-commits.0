From: akpm@linux-foundation.org
Subject: + mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma.patch
 added to -mm tree
Date: Thu, 10 Sep 2015 15:22:01 -0700
Message-ID: <55f20289.lS0qS8uZyoCzxtiO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbIJWWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 18:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove useless statement "vma = NULL" in find_vma()
has been added to the -mm tree.  Its filename is
     mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-remove-useless-statement-vma-%3D-null-in-find_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-remove-useless-statement-vma-%3D-null-in-find_vma.patch

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
Subject: mm/mmap.c: remove useless statement "vma = NULL" in find_vma()

Before the main loop, vma is already is NULL.  There is no need to set it
to NULL again.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma
+++ a/mm/mmap.c
@@ -2054,7 +2054,6 @@ struct vm_area_struct *find_vma(struct m
 		return vma;
 
 	rb_node = mm->mm_rb.rb_node;
-	vma = NULL;
 
 	while (rb_node) {
 		struct vm_area_struct *tmp;
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma.patch

