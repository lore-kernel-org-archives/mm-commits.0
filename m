From: akpm@linux-foundation.org
Subject: [patch 06/18] mm: remove unnecessary WARN_ONCE in
 page_vma_mapped_walk().
Date: Fri, 13 Oct 2017 15:57:47 -0700
Message-ID: <59e144eb.AY/0Pjl16QoDjsfn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdJMW5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zi.yan@cs.rutgers.edu, abdhalee@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com

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
