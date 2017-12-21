From: akpm@linux-foundation.org
Subject: + mm-store-compound_dtor-compound_order-as-bytes-fix.patch added
 to -mm tree
Date: Wed, 20 Dec 2017 16:29:28 -0800
Message-ID: <5a3b0068.JPFOSHJB7OsVibX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756543AbdLUA3d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 19:29:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-store-compound_dtor-compound_order-as-bytes-fix
has been added to the -mm tree.  Its filename is
     mm-store-compound_dtor-compound_order-as-bytes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-store-compound_dtor-compound_order-as-bytes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-store-compound_dtor-compound_order-as-bytes-fix.patch

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
Subject: mm-store-compound_dtor-compound_order-as-bytes-fix

add comment

Link: http://lkml.kernel.org/r/20171221000144.GB2980@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes-fix
+++ a/include/linux/mm_types.h
@@ -138,6 +138,7 @@ struct page {
 			/* First tail page only */
 			unsigned char compound_dtor;
 			unsigned char compound_order;
+			/* two/six bytes available here */
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
mm-store-compound_dtor-compound_order-as-bytes-fix.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

