From: akpm@linux-foundation.org
Subject: + mm-config_have_memblock_node-config_have_memblock_node_map.patch added to -mm tree
Date: Fri, 29 Jun 2012 13:22:03 -0700
Message-ID: <20120629202203.A1682A0244@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56451 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2F2UWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 16:22:06 -0400
Received: by bkty5 with SMTP id y5so212292bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 13:22:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin@rab.in, tj@kernel.org


The patch titled
     Subject: mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP
has been added to the -mm tree.  Its filename is
     mm-config_have_memblock_node-config_have_memblock_node_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rabin Vincent <rabin@rab.in>
Subject: mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP

0ee332c14518699 ("memblock: Kill early_node_map[]") wanted to replace
CONFIG_ARCH_POPULATES_NODE_MAP with CONFIG_HAVE_MEMBLOCK_NODE_MAP but
ended up replacing one occurence with a reference to the non-existent
symbol CONFIG_HAVE_MEMBLOCK_NODE.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-config_have_memblock_node-config_have_memblock_node_map include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-config_have_memblock_node-config_have_memblock_node_map
+++ a/include/linux/mmzone.h
@@ -775,7 +775,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
_
Subject: Subject: mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP

Patches currently in -mm which might be from rabin@rab.in are

mm-config_have_memblock_node-config_have_memblock_node_map.patch

