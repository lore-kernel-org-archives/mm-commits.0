From: akpm@linux-foundation.org
Subject: + mm-vmallocc-report-more-vmalloc-failures.patch added to -mm tree
Date: Wed, 31 Aug 2011 14:17:00 -0700
Message-ID: <201108312117.p7VLH0oa027030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab1HaVRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 17:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     mm/vmalloc.c: report more vmalloc failures
has been added to the -mm tree.  Its filename is
     mm-vmallocc-report-more-vmalloc-failures.patch

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
Subject: mm/vmalloc.c: report more vmalloc failures
From: Joe Perches <joe@perches.com>

Some vmalloc failure paths do not report OOM conditions.

Add warn_alloc_failed, which also does a dump_stack, to those failure
paths.

This allows more site specific vmalloc failure logging message printks to
be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-report-more-vmalloc-failures mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-report-more-vmalloc-failures
+++ a/mm/vmalloc.c
@@ -1625,13 +1625,12 @@ void *__vmalloc_node_range(unsigned long
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
-		return NULL;
+		goto fail;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
 				  start, end, node, gfp_mask, caller);
-
 	if (!area)
-		return NULL;
+		goto fail;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 
@@ -1649,6 +1648,12 @@ void *__vmalloc_node_range(unsigned long
 	kmemleak_alloc(addr, real_size, 3, gfp_mask);
 
 	return addr;
+
+fail:
+	warn_alloc_failed(gfp_mask, 0,
+			  "vmalloc: allocation failure: %lu bytes\n",
+			  real_size);
+	return NULL;
 }
 
 /**
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-bna-10g-maintainer.patch
mm-neaten-warn_alloc_failed.patch
mm-neaten-warn_alloc_failed-fix.patch
mm-vmallocc-report-more-vmalloc-failures.patch
treewide-use-__printf-not-__attribute__formatprintf.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete.patch

