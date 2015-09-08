From: akpm@linux-foundation.org
Subject: [folded-merged] zpool-add-zpool_has_pool-fix.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 14:46:28 -0700
Message-ID: <55ef5734.eNxbG8b1ahFREK7N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbbIHVq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: clarification comment for zpool_has_pool
has been removed from the -mm tree.  Its filename was
     zpool-add-zpool_has_pool-fix.patch

This patch was dropped because it was folded into zpool-add-zpool_has_pool.patch

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zpool: clarification comment for zpool_has_pool

Add clarification in the documentation comment for zpool_has_pool() to
explain the caller should assume the requested driver is or is not
available, depending on return value.  If true is returned, the caller
should assume zpool_create_pool() will succeed, but still must be prepared
to handle failure.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/zpool.c~zpool-add-zpool_has_pool-fix mm/zpool.c
--- a/mm/zpool.c~zpool-add-zpool_has_pool-fix
+++ a/mm/zpool.c
@@ -103,7 +103,15 @@ static void zpool_put_driver(struct zpoo
  * zpool_has_pool() - Check if the pool driver is available
  * @type	The type of the zpool to check (e.g. zbud, zsmalloc)
  *
- * This checks if the @type pool driver is available.
+ * This checks if the @type pool driver is available.  This will try to load
+ * the requested module, if needed, but there is no guarantee the module will
+ * still be loaded and available immediately after calling.  If this returns
+ * true, the caller should assume the pool is available, but must be prepared
+ * to handle the @zpool_create_pool() returning failure.  However if this
+ * returns false, the caller should assume the requested pool type is not
+ * available; either the requested pool type module does not exist, or could
+ * not be loaded, and calling @zpool_create_pool() with the pool type will
+ * fail.
  *
  * Returns: true if @type pool is available, false if not
  */
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zpool-add-zpool_has_pool.patch
zswap-dynamic-pool-creation.patch
zswap-dynamic-pool-creation-fix-2.patch
zswap-change-zpool-compressor-at-runtime.patch
zswap-change-zpool-compressor-at-runtime-fix.patch
zswap-update-docs-for-runtime-changeable-attributes.patch
zswap-update-docs-for-runtime-changeable-attributes-v2.patch
zpool-remove-no-op-module-init-exit.patch

