From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-remove-redundant-statement-error-=-enomem.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:09:06 -0800
Message-ID: <563d08e2.iK7xSXu8DBxMQrWl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbbKFUJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:09:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, gang.chen.5i5j@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove redundant statement "error = -ENOMEM"
has been removed from the -mm tree.  Its filename was
     mm-mmapc-remove-redundant-statement-error-=-enomem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <xili_gchen_5257@hotmail.com>
Subject: mm/mmap.c: remove redundant statement "error = -ENOMEM"

It is still a little better to remove it, although it should be skipped
by "-O2".

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>=0A=
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-remove-redundant-statement-error-=-enomem mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-redundant-statement-error-=-enomem
+++ a/mm/mmap.c
@@ -1562,7 +1562,6 @@ unsigned long mmap_region(struct file *f
 	}
 
 	/* Clear old maps */
-	error = -ENOMEM;
 	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
 			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
_

Patches currently in -mm which might be from xili_gchen_5257@hotmail.com are


