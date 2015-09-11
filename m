From: akpm@linux-foundation.org
Subject: [merged]
 kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:23 -0700
Message-ID: <55f319c3.wNNJVK8e1xsdmhRT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbbIKSNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, dyoung@redhat.com, horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove unnecessary test in kimage_alloc_crash_control_pages()
has been removed from the -mm tree.  Its filename was
     kexec-remove-the-unnecessary-conditional-judgement-to-simplify-the-code-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: remove unnecessary test in kimage_alloc_crash_control_pages()

Transforming PFN(Page Frame Number) to struct page is never failure, so we
can simplify the code logic to do the image->control_page assignment
directly in the loop, and remove the unnecessary conditional judgement.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Acked-by: Dave Young <dyoung@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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


