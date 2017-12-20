From: akpm@linux-foundation.org
Subject: + mm-store-compound_dtor-compound_order-as-bytes.patch added to
 -mm tree
Date: Wed, 20 Dec 2017 15:42:52 -0800
Message-ID: <5a3af57c.HmPT3zjxSz3KyGZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755637AbdLTXnD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 18:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: store compound_dtor / compound_order as bytes
has been added to the -mm tree.  Its filename is
     mm-store-compound_dtor-compound_order-as-bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-store-compound_dtor-compound_order-as-bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-store-compound_dtor-compound_order-as-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20171220155552.15884-7-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes
+++ a/include/linux/mm_types.h
@@ -136,19 +136,8 @@ struct page {
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
 		};
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

provide-useful-debugging-information-for-vm_bug.patch
mm-align-struct-page-more-aesthetically.patch
mm-de-indent-struct-page.patch
mm-remove-misleading-alignment-claims.patch
mm-improve-comment-on-page-mapping.patch
mm-introduce-_slub_counter_t.patch
mm-store-compound_dtor-compound_order-as-bytes.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

