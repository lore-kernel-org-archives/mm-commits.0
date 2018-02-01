From: akpm@linux-foundation.org
Subject: [patch 081/119] mm: store compound_dtor / compound_order
 as bytes
Date: Wed, 31 Jan 2018 16:19:02 -0800
Message-ID: <20180201001902.lsyLybt03%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35904 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755813AbeBAATE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm: store compound_dtor / compound_order as bytes

Neither of these values get even close to 256; compound_dtor is currently
at a maximum of 3, and compound_order can't be over 64.  No machine has
inefficient access to bytes since EV5, and while those are still
supported, we don't optimise for them any more.  This does not shrink
struct page, but it removes an ifdef and frees up 2-6 bytes for future
use.

diff of pahole output:

 		struct callback_head callback_head;      /*    32    16 */
 		struct {
 			long unsigned int compound_head; /*    32     8 */
-			unsigned int compound_dtor;      /*    40     4 */
-			unsigned int compound_order;     /*    44     4 */
+			unsigned char compound_dtor;     /*    40     1 */
+			unsigned char compound_order;    /*    41     1 */
 		};                                       /*    32    16 */
 	};                                               /*    32    16 */
 	union {

[mawilcox@microsoft.com: add comment]
  Link: http://lkml.kernel.org/r/20171221000144.GB2980@bombadil.infradead.org
Link: http://lkml.kernel.org/r/20171220155552.15884-7-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes
+++ a/include/linux/mm_types.h
@@ -136,19 +136,9 @@ struct page {
 			unsigned long compound_head; /* If bit zero is set */
 
 			/* First tail page only */
-#ifdef CONFIG_64BIT
-			/*
-			 * On 64 bit system we have enough space in struct page
-			 * to encode compound_dtor and compound_order with
-			 * unsigned int. It can help compiler generate better or
-			 * smaller code on some archtectures.
-			 */
-			unsigned int compound_dtor;
-			unsigned int compound_order;
-#else
-			unsigned short int compound_dtor;
-			unsigned short int compound_order;
-#endif
+			unsigned char compound_dtor;
+			unsigned char compound_order;
+			/* two/six bytes available here */
 		};
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
_
