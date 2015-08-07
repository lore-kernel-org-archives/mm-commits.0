From: akpm@linux-foundation.org
Subject: + zpool-add-zpool_has_pool-fix.patch added to -mm tree
Date: Fri, 07 Aug 2015 15:15:03 -0700
Message-ID: <55c52de7.r25wRiH6X1G2C/wb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946271AbbHGWPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: clarification comment for zpool_has_pool
has been added to the -mm tree.  Its filename is
     zpool-add-zpool_has_pool-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zpool-add-zpool_has_pool-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zpool-add-zpool_has_pool-fix.patch

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

mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
zpool-add-zpool_has_pool.patch
zpool-add-zpool_has_pool-fix.patch
zswap-dynamic-pool-creation.patch
zswap-dynamic-pool-creation-fix.patch
zswap-change-zpool-compressor-at-runtime.patch
linux-next.patch
zswap-comment-clarifying-maxlen.patch

