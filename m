From: akpm@linux-foundation.org
Subject: + ifdef-very-expensive-debug-check-in-page-fault-path.patch added to -mm tree
Date: Wed, 16 Jan 2008 10:54:54 -0800
Message-ID: <200801161854.m0GIsYSD018805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbYAPSyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 13:54:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cotte@de.ibm.com, nickpiggin@yahoo.com.au


The patch titled
     #ifdef very expensive debug check in page fault path
has been added to the -mm tree.  Its filename is
     ifdef-very-expensive-debug-check-in-page-fault-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: #ifdef very expensive debug check in page fault path
From: Carsten Otte <cotte@de.ibm.com>

This patch puts #ifdef CONFIG_DEBUG_VM around a check in vm_normal_page
that verifies that a pfn is valid.  This patch increases performance of the
page fault microbenchmark in lmbench by 13% and overall dbench performance
by 7% on s390x.  pfn_valid() is an expensive operation on s390 that needs a
high double digit amount of CPU cycles.  Nick Piggin suggested that
pfn_valid() involves an array lookup on systems with sparsemem, and
therefore is an expensive operation there too.

The check looks like a clear debug thing to me, it should never trigger on
regular kernels.  And if a pte is created for an invalid pfn, we'll find
out once the memory gets accessed later on anyway.  Please consider
inclusion of this patch into mm.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory.c~ifdef-very-expensive-debug-check-in-page-fault-path mm/memory.c
--- a/mm/memory.c~ifdef-very-expensive-debug-check-in-page-fault-path
+++ a/mm/memory.c
@@ -392,6 +392,7 @@ struct page *vm_normal_page(struct vm_ar
 			return NULL;
 	}
 
+#ifdef CONFIG_DEBUG_VM
 	/*
 	 * Add some anal sanity checks for now. Eventually,
 	 * we should just do "return pfn_to_page(pfn)", but
@@ -402,6 +403,7 @@ struct page *vm_normal_page(struct vm_ar
 		print_bad_pte(vma, pte, addr);
 		return NULL;
 	}
+#endif
 
 	/*
 	 * NOTE! We still have PageReserved() pages in the page 
_

Patches currently in -mm which might be from cotte@de.ibm.com are

origin.patch
ifdef-very-expensive-debug-check-in-page-fault-path.patch
git-kvm.patch
check-advice-of-fadvice64_64-even-if-get_xip_page-is-given.patch
ext2-xip-check-fix.patch
