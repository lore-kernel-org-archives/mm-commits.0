From: akpm@linux-foundation.org
Subject: + mm-fix-slab-page-_count-corruption-when-using-slub.patch added to -mm tree
Date: Fri, 08 Jun 2012 13:11:07 -0700
Message-ID: <20120608201107.CD136A02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48300 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab2FHULJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 16:11:09 -0400
Received: by ggeh3 with SMTP id h3so206044gge.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 13:11:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pshelar@nicira.com, aarcange@redhat.com, abhide@nicira.com, cl@linux.com, penberg@cs.helsinki.fi, stable@vger.kernel.org


The patch titled
     Subject: mm: fix slab->page _count corruption when using slub
has been added to the -mm tree.  Its filename is
     mm-fix-slab-page-_count-corruption-when-using-slub.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pravin B Shelar <pshelar@nicira.com>
Subject: mm: fix slab->page _count corruption when using slub

On arches that do not support this_cpu_cmpxchg_double() slab_lock is used
to do atomic cmpxchg() on double word which contains page->_count.  The
page count can be changed from get_page() or put_page() without taking
slab_lock.  That corrupts page counter.

Fix it by moving page->_count out of cmpxchg_double data.  So that slub
does no change it while updating slub meta-data in struct page.

Reported-by: Amey Bhide <abhide@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/mm_types.h~mm-fix-slab-page-_count-corruption-when-using-slub include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-slab-page-_count-corruption-when-using-slub
+++ a/include/linux/mm_types.h
@@ -57,8 +57,16 @@ struct page {
 		};
 
 		union {
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
+#else
+			/* Keep _count separate from slub cmpxchg_double data,
+			 * As rest of double word is protected by slab_lock
+			 * but _count is not. */
+			unsigned counters;
+#endif
 
 			struct {
 
_
Subject: Subject: mm: fix slab->page _count corruption when using slub

Patches currently in -mm which might be from pshelar@nicira.com are

mm-fix-slab-page-_count-corruption-when-using-slub.patch

