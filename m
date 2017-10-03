From: akpm@linux-foundation.org
Subject: + mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk.patch
 added to -mm tree
Date: Tue, 03 Oct 2017 14:40:13 -0700
Message-ID: <59d403bd.lQKeFfX/nXYhOsxh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdJCVkO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zi.yan@cs.rutgers.edu, abdhalee@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary WARN_ONCE in page_vma_mapped_walk().
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm: remove unnecessary WARN_ONCE in page_vma_mapped_walk().

A non present pmd entry can appear after pmd_lock is taken in
page_vma_mapped_walk(), even if THP migration is not enabled.  The
WARN_ONCE is unnecessary.

Link: http://lkml.kernel.org/r/20171003142606.12324-1-zi.yan@sent.com
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_vma_mapped.c~mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk
+++ a/mm/page_vma_mapped.c
@@ -167,8 +167,7 @@ restart:
 						return not_found(pvmw);
 					return true;
 				}
-			} else
-				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+			}
 			return not_found(pvmw);
 		} else {
 			/* THP pmd was split under us: handle on pte level */
_

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are

mm-remove-unnecessary-warn_once-in-page_vma_mapped_walk.patch

