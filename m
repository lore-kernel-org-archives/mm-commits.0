From: akpm@linux-foundation.org
Subject: + mm-zonelist-enumerate-zonelists-array-index.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 16:02:08 -0800
Message-ID: <564bc000.95e5mNrCFPfBYXyY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbbKRACJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 19:02:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zonelist: enumerate zonelists array index
has been added to the -mm tree.  Its filename is
     mm-zonelist-enumerate-zonelists-array-index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zonelist-enumerate-zonelists-array-index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zonelist-enumerate-zonelists-array-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/zonelist: enumerate zonelists array index

Hardcoding index to zonelists array in gfp_zonelist() is not a good idea,
let's enumerate it to improve readability.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    4 ++--
 include/linux/mmzone.h |   20 +++++++++-----------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff -puN include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index include/linux/gfp.h
--- a/include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index
+++ a/include/linux/gfp.h
@@ -385,9 +385,9 @@ static inline enum zone_type gfp_zone(gf
 static inline int gfp_zonelist(gfp_t flags)
 {
 	if (IS_ENABLED(CONFIG_NUMA) && unlikely(flags & __GFP_THISNODE))
-		return 1;
+		return ZONELIST_NOFALLBACK;
 
-	return 0;
+	return ZONELIST_FALLBACK;
 }
 
 /*
diff -puN include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index
+++ a/include/linux/mmzone.h
@@ -571,19 +571,17 @@ static inline bool zone_is_empty(struct
 /* Maximum number of zones on a zonelist */
 #define MAX_ZONES_PER_ZONELIST (MAX_NUMNODES * MAX_NR_ZONES)
 
+enum {
+	ZONELIST_FALLBACK,	/* zonelist with fallback */
 #ifdef CONFIG_NUMA
-
-/*
- * The NUMA zonelists are doubled because we need zonelists that restrict the
- * allocations to a single node for __GFP_THISNODE.
- *
- * [0]	: Zonelist with fallback
- * [1]	: No fallback (__GFP_THISNODE)
- */
-#define MAX_ZONELISTS 2
-#else
-#define MAX_ZONELISTS 1
+	/*
+	 * The NUMA zonelists are doubled because we need zonelists that restrict
+	 * the allocations to a single node for __GFP_THISNODE.
+	 */
+	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
 #endif
+	MAX_ZONELISTS
+};
 
 /*
  * This struct contains information about a zone in a zonelist. It is stored
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-hugetlb-is_file_hugepages-can-be-boolean.patch
mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch
mm-lru-remove-unused-is_unevictable_lru-function.patch
mm-zonelist-enumerate-zonelists-array-index.patch
fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

