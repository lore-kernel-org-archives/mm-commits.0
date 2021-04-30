Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1466BC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA2AF613F8
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhD3GDK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230362AbhD3GDI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ABD061424;
        Fri, 30 Apr 2021 06:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762537;
        bh=ogmXwCXb623m4Iiqcv+WWGgCxqQdw2SZ7UWOj0F+bIo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J1uxbwtVzigegQc4dP/pL2aOUWSXFt808ECg0WJW9m9g4U+CiPG2+j1tshcl4I63J
         eqWdTJfMJEEHCpXLux4ao5Q3uguTBVYnOmNgzsJ3qReIUi4lokWzABTQ78wc508L7J
         bMpXNiVQHGJKjHlg3b8KHvSzulczOQ+iivnRG4Gc=
Date:   Thu, 29 Apr 2021 23:02:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 177/178] mm/mmzone.h: fix existing kernel-doc
 comments and link them to core-api
Message-ID: <20210430060216.Uol0c5QyW%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/mmzone.h: fix existing kernel-doc comments and link them to core-api

There are a couple of kernel-doc comments in include/linux/mmzone.h but
they have minor formatting issues that would cause kernel-doc warnings.

Fix the formatting of those comments, add missing Return: descriptions and
link include/linux/mmzone.h to Documentation/core-api/mm-api.rst

Link: https://lkml.kernel.org/r/20210426141927.1314326-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 
 include/linux/mmzone.h            |   43 +++++++++++++++-------------
 2 files changed, 25 insertions(+), 19 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-mmzoneh-fix-existing-kernel-doc-comments-and-link-them-to-core-api
+++ a/Documentation/core-api/mm-api.rst
@@ -97,3 +97,4 @@ More Memory Management Functions
    :internal:
 .. kernel-doc:: include/linux/mm.h
    :internal:
+.. kernel-doc:: include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-mmzoneh-fix-existing-kernel-doc-comments-and-link-them-to-core-api
+++ a/include/linux/mmzone.h
@@ -993,7 +993,8 @@ static inline int is_highmem_idx(enum zo
  * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
  *              to ZONE_{DMA/NORMAL/HIGHMEM/etc} in general code to a minimum.
- * @zone - pointer to struct zone variable
+ * @zone: pointer to struct zone variable
+ * Return: 1 for a highmem zone, 0 otherwise
  */
 static inline int is_highmem(struct zone *zone)
 {
@@ -1044,7 +1045,7 @@ extern struct zone *next_zone(struct zon
 
 /**
  * for_each_online_pgdat - helper macro to iterate over all online nodes
- * @pgdat - pointer to a pg_data_t variable
+ * @pgdat: pointer to a pg_data_t variable
  */
 #define for_each_online_pgdat(pgdat)			\
 	for (pgdat = first_online_pgdat();		\
@@ -1052,7 +1053,7 @@ extern struct zone *next_zone(struct zon
 	     pgdat = next_online_pgdat(pgdat))
 /**
  * for_each_zone - helper macro to iterate over all memory zones
- * @zone - pointer to struct zone variable
+ * @zone: pointer to struct zone variable
  *
  * The user only needs to declare the zone variable, for_each_zone
  * fills it in.
@@ -1091,15 +1092,18 @@ struct zoneref *__next_zones_zonelist(st
 
 /**
  * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
- * @z - The cursor used as a starting point for the search
- * @highest_zoneidx - The zone index of the highest zone to return
- * @nodes - An optional nodemask to filter the zonelist with
+ * @z: The cursor used as a starting point for the search
+ * @highest_zoneidx: The zone index of the highest zone to return
+ * @nodes: An optional nodemask to filter the zonelist with
  *
  * This function returns the next zone at or below a given zone index that is
  * within the allowed nodemask using a cursor as the starting point for the
  * search. The zoneref returned is a cursor that represents the current zone
  * being examined. It should be advanced by one before calling
  * next_zones_zonelist again.
+ *
+ * Return: the next zone at or below highest_zoneidx within the allowed
+ * nodemask using a cursor within a zonelist as a starting point
  */
 static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
@@ -1112,10 +1116,9 @@ static __always_inline struct zoneref *n
 
 /**
  * first_zones_zonelist - Returns the first zone at or below highest_zoneidx within the allowed nodemask in a zonelist
- * @zonelist - The zonelist to search for a suitable zone
- * @highest_zoneidx - The zone index of the highest zone to return
- * @nodes - An optional nodemask to filter the zonelist with
- * @return - Zoneref pointer for the first suitable zone found (see below)
+ * @zonelist: The zonelist to search for a suitable zone
+ * @highest_zoneidx: The zone index of the highest zone to return
+ * @nodes: An optional nodemask to filter the zonelist with
  *
  * This function returns the first zone at or below a given zone index that is
  * within the allowed nodemask. The zoneref returned is a cursor that can be
@@ -1125,6 +1128,8 @@ static __always_inline struct zoneref *n
  * When no eligible zone is found, zoneref->zone is NULL (zoneref itself is
  * never NULL). This may happen either genuinely, or due to concurrent nodemask
  * update due to cpuset modification.
+ *
+ * Return: Zoneref pointer for the first suitable zone found
  */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 					enum zone_type highest_zoneidx,
@@ -1136,11 +1141,11 @@ static inline struct zoneref *first_zone
 
 /**
  * for_each_zone_zonelist_nodemask - helper macro to iterate over valid zones in a zonelist at or below a given zone index and within a nodemask
- * @zone - The current zone in the iterator
- * @z - The current pointer within zonelist->_zonerefs being iterated
- * @zlist - The zonelist being iterated
- * @highidx - The zone index of the highest zone to return
- * @nodemask - Nodemask allowed by the allocator
+ * @zone: The current zone in the iterator
+ * @z: The current pointer within zonelist->_zonerefs being iterated
+ * @zlist: The zonelist being iterated
+ * @highidx: The zone index of the highest zone to return
+ * @nodemask: Nodemask allowed by the allocator
  *
  * This iterator iterates though all zones at or below a given zone index and
  * within a given nodemask
@@ -1160,10 +1165,10 @@ static inline struct zoneref *first_zone
 
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
- * @zone - The current zone in the iterator
- * @z - The current pointer within zonelist->zones being iterated
- * @zlist - The zonelist being iterated
- * @highidx - The zone index of the highest zone to return
+ * @zone: The current zone in the iterator
+ * @z: The current pointer within zonelist->zones being iterated
+ * @zlist: The zonelist being iterated
+ * @highidx: The zone index of the highest zone to return
  *
  * This iterator iterates though all zones at or below a given zone index.
  */
_
