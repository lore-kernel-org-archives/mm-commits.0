From: akpm@linux-foundation.org
Subject: +
 mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch added
 to -mm tree
Date: Tue, 15 Sep 2015 15:13:05 -0700
Message-ID: <55f897f1.izmTBCbw43UwHtH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbIOWNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use 'unsigned int' for compound_dtor/compound_order on 64BIT
has been added to the -mm tree.  Its filename is
     mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use 'unsigned int' for compound_dtor/compound_order on 64BIT

On 64 bit system we have enough space in struct page to encode
compound_dtor and compound_order with unsigned int.

On x86-64 it leads to slightly smaller code size due usesage of plain
MOV instead of MOVZX (zero-extended move) or similar effect.

allyesconfig:

   text	   data	    bss	    dec	    hex	filename
159520446	48146736	72196096	279863278	10ae5fee	vmlinux.pre
159520382	48146736	72196096	279863214	10ae5fae	vmlinux.post

On other architectures without native support of 16-bit data types the

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/mm_types.h~mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit
+++ a/include/linux/mm_types.h
@@ -143,8 +143,19 @@ struct page {
 			unsigned long compound_head; /* If bit zero is set */
 
 			/* First tail page only */
+#ifdef CONFIG_64BIT
+			/*
+			 * On 64 bit system we have enough space in struct page
+			 * to encode compound_dtor and compound_order with
+			 * unsigned int. It can help compiler generate better or
+			 * smaller code on some archtectures.
+			 */
+			unsigned int compound_dtor;
+			unsigned int compound_order;
+#else
 			unsigned short int compound_dtor;
 			unsigned short int compound_order;
+#endif
 		};
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

