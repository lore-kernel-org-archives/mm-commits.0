From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-track-foll_pin-pages-fix-2.patch added to -mm
 tree
Date: Sat, 07 Mar 2020 15:25:17 -0800
Message-ID: <20200307232517.0eSNFUWfN%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgCGXZT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 18:25:19 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imbrenda@linux.ibm.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fixup for 9947ea2c1e608e32 "mm/gup: track FOLL_PIN pages"
has been added to the -mm tree.  Its filename is
     mm-gup-track-foll_pin-pages-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-track-foll_pin-pages-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-track-foll_pin-pages-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: mm/gup: fixup for 9947ea2c1e608e32 "mm/gup: track FOLL_PIN pages"

In case pin fails, we need to unpin, a simple put_page will not be enough

fixup for commit 9947ea2c1e608e32 ("mm/gup: track FOLL_PIN pages")

it can be simply squashed in

Link: http://lkml.kernel.org/r/20200306132537.783769-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-track-foll_pin-pages-fix-2
+++ a/mm/gup.c
@@ -2065,7 +2065,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
-			put_page(head);
+			put_compound_head(head, 1, flags);
 			goto pte_unmap;
 		}
 
_

Patches currently in -mm which might be from imbrenda@linux.ibm.com are

mm-gup-track-foll_pin-pages-fix-2.patch
mm-gup-writeback-add-callbacks-for-inaccessible-pages.patch
