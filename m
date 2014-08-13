From: akpm@linux-foundation.org
Subject: + lib-genallocc-add-genpool-range-check-function.patch added to
 -mm tree
Date: Wed, 13 Aug 2014 15:19:57 -0700
Message-ID: <53ebe48d.CT5XA67ilXmHXUCR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:46115 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaHMWT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:19:58 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so107299oig.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:19:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, arnd@arndb.de, catalin.marinas@arm.com, davidriley@chromium.org, linux@arm.linux.org.uk, olof@lixom.net, ritesh.harjani@gmail.com, thierry.reding@gmail.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: add genpool range check function
has been added to the -mm tree.  Its filename is
     lib-genallocc-add-genpool-range-check-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-genallocc-add-genpool-range-check-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-genallocc-add-genpool-range-check-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: lib/genalloc.c: add genpool range check function

After allocating an address from a particular genpool, there is no good
way to verify if that address actually belongs to a genpool.  Introduce
addr_in_gen_pool which will return if an address plus size falls
completely within the genpool range.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Olof Johansson <olof@lixom.net>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Riley <davidriley@chromium.org>
Cc: Ritesh Harjain <ritesh.harjani@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    3 +++
 lib/genalloc.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff -puN include/linux/genalloc.h~lib-genallocc-add-genpool-range-check-function include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genallocc-add-genpool-range-check-function
+++ a/include/linux/genalloc.h
@@ -121,6 +121,9 @@ extern struct gen_pool *devm_gen_pool_cr
 		int min_alloc_order, int nid);
 extern struct gen_pool *dev_get_gen_pool(struct device *dev);
 
+bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
+			size_t size);
+
 #ifdef CONFIG_OF
 extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index);
diff -puN lib/genalloc.c~lib-genallocc-add-genpool-range-check-function lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-add-genpool-range-check-function
+++ a/lib/genalloc.c
@@ -403,6 +403,35 @@ void gen_pool_for_each_chunk(struct gen_
 EXPORT_SYMBOL(gen_pool_for_each_chunk);
 
 /**
+ * addr_in_gen_pool - checks if an address falls within the range of a pool
+ * @pool:	the generic memory pool
+ * @start:	start address
+ * @size:	size of the region
+ *
+ * Check if the range of addresses falls within the specified pool. Returns
+ * true if the entire range is contained in the pool and false otherwise.
+ */
+bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
+			size_t size)
+{
+	bool found = false;
+	unsigned long end = start + size;
+	struct gen_pool_chunk *chunk;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk) {
+		if (start >= chunk->start_addr && start <= chunk->end_addr) {
+			if (end <= chunk->end_addr) {
+				found = true;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+	return found;
+}
+
+/**
  * gen_pool_avail - get available free space of the pool
  * @pool: pool to get available free space
  *
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

