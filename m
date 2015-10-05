From: akpm@linux-foundation.org
Subject: + mm-mmapc-remove-redundant-statement-error-=-enomem.patch added
 to -mm tree
Date: Mon, 05 Oct 2015 13:35:11 -0700
Message-ID: <5612deff.3V2I/pKERf4M/aev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbJEUfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 16:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, gang.chen.5i5j@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove redundant statement "error = -ENOMEM"
has been added to the -mm tree.  Its filename is
     mm-mmapc-remove-redundant-statement-error-=-enomem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-remove-redundant-statement-error-%3D-enomem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-remove-redundant-statement-error-%3D-enomem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmapc-remove-redundant-statement-error-=-enomem.patch

