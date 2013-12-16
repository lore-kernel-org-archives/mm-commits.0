From: akpm@linux-foundation.org
Subject: + mm-zswapc-change-params-from-hidden-to-ro.patch added to -mm
 tree
Date: Mon, 16 Dec 2013 11:55:54 -0800
Message-ID: <52af5aca.BmVSUIB17aF114rT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3LPTzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang@samsung.com, sjennings@variantweb.net, murzin.v@gmail.com, minchan@kernel.org, bob.liu@oracle.com, ddstreet@ieee.org

Subject: + mm-zswapc-change-params-from-hidden-to-ro.patch added to -mm tree
To: ddstreet@ieee.org,bob.liu@oracle.com,minchan@kernel.org,murzin.v@gmail.com,sjennings@variantweb.net,weijie.yang@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:54 -0800


The patch titled
     Subject: mm/zswap.c: change params from hidden to ro
has been added to the -mm tree.  Its filename is
     mm-zswapc-change-params-from-hidden-to-ro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-change-params-from-hidden-to-ro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-change-params-from-hidden-to-ro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zswapc-change-params-from-hidden-to-ro.patch

