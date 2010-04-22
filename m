From: akpm@linux-foundation.org
Subject: + mm-document-follow_page.patch added to -mm tree
Date: Thu, 22 Apr 2010 13:53:52 -0700
Message-ID: <201004222053.o3MKrqDW009188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755600Ab0DVUyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 16:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, error27@gmail.com, ieidus@redhat.com, riel@redhat.com


The patch titled
     mm: document follow_page()
has been added to the -mm tree.  Its filename is
     mm-document-follow_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: document follow_page()
From: Johannes Weiner <hannes@cmpxchg.org>

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-document-follow_page mm/memory.c
--- a/mm/memory.c~mm-document-follow_page
+++ a/mm/memory.c
@@ -1227,8 +1227,17 @@ int zap_vma_ptes(struct vm_area_struct *
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
-/*
- * Do a quick page-table lookup for a single page.
+/**
+ * follow_page - look up a page descriptor from a user-virtual address
+ * @vma: vm_area_struct mapping @address
+ * @address: virtual address to look up
+ * @flags: flags modifying lookup behaviour
+ *
+ * @flags can have FOLL_ flags set, defined in <linux/mm.h>
+ *
+ * Returns the mapped (struct page *), %NULL if no mapping exists, or
+ * an error pointer if there is a mapping to something not represented
+ * by a page descriptor (see also vm_normal_page()).
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

ksm-check-for-err_ptr-from-follow_page.patch
sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-document-follow_page.patch

