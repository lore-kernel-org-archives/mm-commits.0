From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix.patch added to -mm tree
Date: Fri, 16 Feb 2018 16:46:43 -0800
Message-ID: <5a877b73.nlp4eUn8YL1yBFs/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51902 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbeBQAqo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:46:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix

Specify that movablecore= can use a percent value.

Remove comment about hugetlb pages not being movable per Mike.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1802131700160.71590@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   22 +++++++-------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1837,10 +1837,9 @@
 
 			ZONE_MOVABLE is used for the allocation of pages that
 			may be reclaimed or moved by the page migration
-			subsystem.  This means that HugeTLB pages may not be
-			allocated from this zone.  Note that allocations like
-			PTEs-from-HighMem still use the HighMem zone if it
-			exists, and the Normal zone if it does not.
+			subsystem.  Note that allocations like PTEs-from-HighMem
+			still use the HighMem zone if it exists, and the Normal
+			zone if it does not.
 
 			It is possible to specify the exact amount of memory in
 			the form of "nn[KMGTPE]", a percentage of total system
@@ -2353,13 +2352,14 @@
 	mousedev.yres=	[MOUSE] Vertical screen resolution, used for devices
 			reporting absolute coordinates, such as tablets
 
-	movablecore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
-			is similar to kernelcore except it specifies the
-			amount of memory used for migratable allocations.
-			If both kernelcore and movablecore is specified,
-			then kernelcore will be at *least* the specified
-			value but may be more. If movablecore on its own
-			is specified, the administrator must be careful
+	movablecore=	[KNL,X86,IA-64,PPC]
+			Format: nn[KMGTPE] | nn%
+			This parameter is the complement to kernelcore=, it
+			specifies the amount of memory used for migratable
+			allocations.  If both kernelcore and movablecore is
+			specified, then kernelcore will be at *least* the
+			specified value but may be more.  If movablecore on its
+			own is specified, the administrator must be careful
 			that the amount of memory usable for all allocations
 			is not too small.
 
_

Patches currently in -mm which might be from rientjes@google.com are

kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch
mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch
mm-page_alloc-extend-kernelcore-and-movablecore-for-percent-fix.patch
mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch

