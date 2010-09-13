From: akpm@linux-foundation.org
Subject: + mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch added to -mm tree
Date: Mon, 13 Sep 2010 16:53:54 -0700
Message-ID: <201009132353.o8DNrsUm028575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab0IMXyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 19:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     mm: fix typo in mm.h when NODE_NOT_IN_PAGE_FLAGS
has been added to the -mm tree.  Its filename is
     mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch

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
Subject: mm: fix typo in mm.h when NODE_NOT_IN_PAGE_FLAGS
From: Will Deacon <will.deacon@arm.com>

NODE_NOT_IN_PAGE_FLAGS is defined in mm.h when the node information is not
stored in the page flags bitmap.

Unfortunately, there's a typo in one of the checks for it.  This patch
fixes it (s/NODE_NOT_IN_PAGEFLAGS/NODE_NOT_IN_PAGE_FLAGS/).  Since this
has been around for ages, I doubt it's been causing any serious problems.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-fix-typo-in-mmh-when-node_not_in_page_flags include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-typo-in-mmh-when-node_not_in_page_flags
+++ a/include/linux/mm.h
@@ -497,8 +497,8 @@ static inline void set_compound_order(st
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
 
-/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allcator */
-#ifdef NODE_NOT_IN_PAGEFLAGS
+/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
+#ifdef NODE_NOT_IN_PAGE_FLAGS
 #define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
 #define ZONEID_PGOFF		((SECTIONS_PGOFF < ZONES_PGOFF)? \
 						SECTIONS_PGOFF : ZONES_PGOFF)
_

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch

