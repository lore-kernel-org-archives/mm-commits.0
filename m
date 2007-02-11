From: akpm@linux-foundation.org
Subject: - zoneid-fix-up-calculations-for-zoneid_pgshift.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:49 -0800
Message-ID: <200702112246.l1BMknxC015518@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625AbXBKWqx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     zoneid: fix up calculations for ZONEID_PGSHIFT
has been removed from the -mm tree.  Its filename was
     zoneid-fix-up-calculations-for-zoneid_pgshift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: zoneid: fix up calculations for ZONEID_PGSHIFT
From: Andy Whitcroft <apw@shadowen.org>

Currently if we have a non-zero ZONES_SHIFT we assume we are able to rely
on that as the bottom edge of the ZONEID, if not then we use the
NODES_PGOFF as the right end of either NODES _or_ SECTION.  This latter is
more luck than judgement and would be incorrect if we reordered the
SECTION,NODE,ZONE options in the fields space.

Really what we want is the lower of the right hand end of the two fields we
are using (either NODE,ZONE or SECTION,ZONE).  Codify that explicitly.  As
always allow for there being no bits in either of the fields, such as might
be valid in a non-numa machine with only a zone NORMAL.

I have checked that the compiler is still able to constant fold all of this
away correctly.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~zoneid-fix-up-calculations-for-zoneid_pgshift include/linux/mm.h
--- a/include/linux/mm.h~zoneid-fix-up-calculations-for-zoneid_pgshift
+++ a/include/linux/mm.h
@@ -437,15 +437,15 @@ static inline compound_page_dtor *get_co
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allcator */
 #ifdef NODE_NOT_IN_PAGEFLAGS
 #define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
+#define ZONEID_PGOFF		((SECTIONS_PGOFF < ZONES_PGOFF)? \
+						SECTIONS_PGOFF : ZONES_PGOFF)
 #else
 #define ZONEID_SHIFT		(NODES_SHIFT + ZONES_SHIFT)
+#define ZONEID_PGOFF		((NODES_PGOFF < ZONES_PGOFF)? \
+						NODES_PGOFF : ZONES_PGOFF)
 #endif
 
-#if ZONES_WIDTH > 0
-#define ZONEID_PGSHIFT		ZONES_PGSHIFT
-#else
-#define ZONEID_PGSHIFT		NODES_PGOFF
-#endif
+#define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
 
 #if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
 #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
@@ -471,7 +471,6 @@ static inline enum zone_type page_zonenu
  */
 static inline int page_zone_id(struct page *page)
 {
-	BUILD_BUG_ON(ZONEID_PGSHIFT == 0 && ZONEID_MASK);
 	return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
 }
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
pci-device-ensure-sysdata-initialised-v2.patch
lumpy-reclaim-v2.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
