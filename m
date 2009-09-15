From: akpm@linux-foundation.org
Subject: + hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix.patch added to -mm tree
Date: Tue, 15 Sep 2009 14:45:00 -0700
Message-ID: <200909152145.n8FLj0VK012468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbZIOVpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 17:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebmunson@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix
has been added to the -mm tree.  Its filename is
     hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix.patch

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
Subject: hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix
From: Eric B Munson <ebmunson@us.ibm.com>

The patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
used the value 0x40 for MAP_HUGETLB which is the same value used for
various other flags on some architectures.  This collision causes
unexpected use of huge pages in the best case and mmap to fail with
ENOMEM or ENOSYS in the worst.  This patch changes the value for
MAP_HUGETLB to a value that is not currently used on any arch.

This patch should be considered a fix to
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/mman-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/mman-common.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix
+++ a/include/asm-generic/mman-common.h
@@ -19,7 +19,7 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
-#define MAP_HUGETLB	0x40		/* create a huge page mapping */
+#define MAP_HUGETLB	0x080000	/* create a huge page mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
_

Patches currently in -mm which might be from ebmunson@us.ibm.com are

hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix.patch
hugetlb-add-map_hugetlb-example.patch

