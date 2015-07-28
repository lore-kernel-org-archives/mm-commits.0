From: akpm@linux-foundation.org
Subject: +
 kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch added to -mm tree
Date: Tue, 28 Jul 2015 14:19:24 -0700
Message-ID: <55b7f1dc.C2NnWa81xosDnoNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbbG1VTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 17:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, dyoung@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove unnecessary test in kimage_alloc_crash_control_pages()
has been added to the -mm tree.  Its filename is
     kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: remove unnecessary test in kimage_alloc_crash_control_pages()

Transforming PFN(Page Frame Number) to struct page is never failure, so we
can simplify the code logic to do the image->control_page assignment
directly in the loop, and remove the unnecessary conditional judgement.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Acked-by: Dave Young <dyoung@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/kexec.c~kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic kernel/kexec.c
diff -puN kernel/kexec_core.c~kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic
+++ a/kernel/kexec_core.c
@@ -439,11 +439,10 @@ static struct page *kimage_alloc_crash_c
 		/* If I don't overlap any segments I have found my hole! */
 		if (i == image->nr_segments) {
 			pages = pfn_to_page(hole_start >> PAGE_SHIFT);
+			image->control_page = hole_end;
 			break;
 		}
 	}
-	if (pages)
-		image->control_page = hole_end;
 
 	return pages;
 }
_

Patches currently in -mm which might be from mnfhuang@gmail.com are

kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch
linux-next.patch

