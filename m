From: akpm@linux-foundation.org
Subject: + zpool-add-zpool_has_pool.patch added to -mm tree
Date: Wed, 05 Aug 2015 13:16:14 -0700
Message-ID: <55c26f0e.1NnnnRFacbwNetpW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbHEUQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 16:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: add zpool_has_pool()
has been added to the -mm tree.  Its filename is
     zpool-add-zpool_has_pool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zpool-add-zpool_has_pool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zpool-add-zpool_has_pool.patch

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
Subject: zpool: add zpool_has_pool()

This series makes creation of the zpool and compressor dynamic, so that
they can be changed at runtime.  This makes using/configuring zswap
easier, as before this zswap had to be configured at boot time, using boot
params.

This uses a single list to track both the zpool and compressor together,
although Seth had mentioned an alternative which is to track the zpools
and compressors using separate lists.  In the most common case, only a
single zpool and single compressor, using one list is slightly simpler
than using two lists, and for the uncommon case of multiple zpools and/or
compressors, using one list is slightly less simple (and uses slightly
more memory, probably) than using two lists.


This patch (of 3):

Add zpool_has_pool() function, indicating if the specified type of zpool
is available (i.e.  zsmalloc or zbud).  This allows checking if a pool is
available, without actually trying to allocate it, similar to
crypto_has_alg().

This is used by a following patch to zswap that enables the dynamic
runtime creation of zswap zpools.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    2 ++
 mm/zpool.c            |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff -puN include/linux/zpool.h~zpool-add-zpool_has_pool include/linux/zpool.h
--- a/include/linux/zpool.h~zpool-add-zpool_has_pool
+++ a/include/linux/zpool.h
@@ -36,6 +36,8 @@ enum zpool_mapmode {
 	ZPOOL_MM_DEFAULT = ZPOOL_MM_RW
 };
 
+bool zpool_has_pool(char *type);
+
 struct zpool *zpool_create_pool(char *type, char *name,
 			gfp_t gfp, const struct zpool_ops *ops);
 
diff -puN mm/zpool.c~zpool-add-zpool_has_pool mm/zpool.c
--- a/mm/zpool.c~zpool-add-zpool_has_pool
+++ a/mm/zpool.c
@@ -100,6 +100,31 @@ static void zpool_put_driver(struct zpoo
 }
 
 /**
+ * zpool_has_pool() - Check if the pool driver is available
+ * @type	The type of the zpool to check (e.g. zbud, zsmalloc)
+ *
+ * This checks if the @type pool driver is available.
+ *
+ * Returns: true if @type pool is available, false if not
+ */
+bool zpool_has_pool(char *type)
+{
+	struct zpool_driver *driver = zpool_get_driver(type);
+
+	if (!driver) {
+		request_module("zpool-%s", type);
+		driver = zpool_get_driver(type);
+	}
+
+	if (!driver)
+		return false;
+
+	zpool_put_driver(driver);
+	return true;
+}
+EXPORT_SYMBOL(zpool_has_pool);
+
+/**
  * zpool_create_pool() - Create a new zpool
  * @type	The type of the zpool to create (e.g. zbud, zsmalloc)
  * @name	The name of the zpool (e.g. zram0, zswap)
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
zpool-add-zpool_has_pool.patch
zswap-dynamic-pool-creation.patch
zswap-change-zpool-compressor-at-runtime.patch
linux-next.patch

