From: akpm@linux-foundation.org
Subject: + mm-mincore-use-offset_in_page-macro.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:22:39 -0700
Message-ID: <55f89a2f.cwSvrMLgm4PJQ55i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbIOWWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mincore: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     mm-mincore-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mincore-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mincore-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/mincore: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mincore.c~mm-mincore-use-offset_in_page-macro mm/mincore.c
--- a/mm/mincore.c~mm-mincore-use-offset_in_page-macro
+++ a/mm/mincore.c
@@ -234,7 +234,7 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 
 	/* This also avoids any overflows on PAGE_CACHE_ALIGN */
 	pages = len >> PAGE_SHIFT;
-	pages += (len & ~PAGE_MASK) != 0;
+	pages += (offset_in_page(len)) != 0;
 
 	if (!access_ok(VERIFY_WRITE, vec, pages))
 		return -EFAULT;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

