From: akpm@linux-foundation.org
Subject: + mm-shmem-mark-expected-switch-fall-through.patch added to -mm
 tree
Date: Thu, 02 Nov 2017 14:51:33 -0700
Message-ID: <59fb9365.d/kYgS9btnn23isU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbdKBVve (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garsilva@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: mark expected switch fall-through
has been added to the -mm tree.  Its filename is
     mm-shmem-mark-expected-switch-fall-through.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-mark-expected-switch-fall-through.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-mark-expected-switch-fall-through.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: mm/shmem.c: mark expected switch fall-through

In preparation to enabling -Wimplicit-fallthrough, mark switch cases where
we are expecting to fall through.

Link: http://lkml.kernel.org/r/20171020191058.GA24427@embeddedor.com
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~mm-shmem-mark-expected-switch-fall-through mm/shmem.c
--- a/mm/shmem.c~mm-shmem-mark-expected-switch-fall-through
+++ a/mm/shmem.c
@@ -4098,6 +4098,7 @@ bool shmem_huge_enabled(struct vm_area_s
 			if (i_size >= HPAGE_PMD_SIZE &&
 					i_size >> PAGE_SHIFT >= off)
 				return true;
+			/* fall through */
 		case SHMEM_HUGE_ADVISE:
 			/* TODO: implement fadvise() hints */
 			return (vma->vm_flags & VM_HUGEPAGE);
_

Patches currently in -mm which might be from garsilva@embeddedor.com are

mm-shmem-mark-expected-switch-fall-through.patch

