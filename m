From: akpm@linux-foundation.org
Subject: [merged] mm-zswapc-change-params-from-hidden-to-ro.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:58:23 -0800
Message-ID: <52e2b7cf.zVCK9wrwDqYzk3FS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaAXS6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang@samsung.com, sjennings@variantweb.net, murzin.v@gmail.com, minchan@kernel.org, bob.liu@oracle.com, ddstreet@ieee.org

Subject: [merged] mm-zswapc-change-params-from-hidden-to-ro.patch removed from -mm tree
To: ddstreet@ieee.org,bob.liu@oracle.com,minchan@kernel.org,murzin.v@gmail.com,sjennings@variantweb.net,weijie.yang@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:23 -0800


The patch titled
     Subject: mm/zswap.c: change params from hidden to ro
has been removed from the -mm tree.  Its filename was
     mm-zswapc-change-params-from-hidden-to-ro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zswap.c: change params from hidden to ro

The "compressor" and "enabled" params are currently hidden, this changes
them to read-only, so userspace can tell if zswap is enabled or not and
see what compressor is in use.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Vladimir Murzin <murzin.v@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswapc-change-params-from-hidden-to-ro mm/zswap.c
--- a/mm/zswap.c~mm-zswapc-change-params-from-hidden-to-ro
+++ a/mm/zswap.c
@@ -77,12 +77,12 @@ static u64 zswap_duplicate_entry;
 **********************************/
 /* Enable/disable zswap (disabled by default, fixed at boot for now) */
 static bool zswap_enabled __read_mostly;
-module_param_named(enabled, zswap_enabled, bool, 0);
+module_param_named(enabled, zswap_enabled, bool, 0444);
 
 /* Compressor to be used by zswap (fixed at boot for now) */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
 static char *zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
-module_param_named(compressor, zswap_compressor, charp, 0);
+module_param_named(compressor, zswap_compressor, charp, 0444);
 
 /* The maximum percentage of memory that the compressed pool can occupy */
 static unsigned int zswap_max_pool_percent = 20;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch

