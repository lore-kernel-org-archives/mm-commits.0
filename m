From: akpm@linux-foundation.org
Subject: [merged] mm-config_have_memblock_node-config_have_memblock_node_map.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:15 -0700
Message-ID: <20120801201416.1491C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:53643 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab2HAUOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:17 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so343830lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rabin@rab.in, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP
has been removed from the -mm tree.  Its filename was
     mm-config_have_memblock_node-config_have_memblock_node_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rabin Vincent <rabin@rab.in>
Subject: mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP

0ee332c14518699 ("memblock: Kill early_node_map[]") wanted to replace
CONFIG_ARCH_POPULATES_NODE_MAP with CONFIG_HAVE_MEMBLOCK_NODE_MAP but
ended up replacing one occurence with a reference to the non-existent
symbol CONFIG_HAVE_MEMBLOCK_NODE.

The resulting omission of code would probably have been causing problems
to 32-bit machines with memory hotplug.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-config_have_memblock_node-config_have_memblock_node_map include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-config_have_memblock_node-config_have_memblock_node_map
+++ a/include/linux/mmzone.h
@@ -776,7 +776,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
_

Patches currently in -mm which might be from rabin@rab.in are

origin.patch

