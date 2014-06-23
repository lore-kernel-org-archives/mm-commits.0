From: akpm@linux-foundation.org
Subject: + mm-zbud-change-zbud_alloc-size-type-to-size_t.patch added to
 -mm tree
Date: Mon, 23 Jun 2014 14:49:05 -0700
Message-ID: <53a8a0d1.QSUH5q7kaxdE92TC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaFWVtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 17:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, bob.liu@oracle.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, minchan@kernel.org, ngupta@vflare.org, riel@redhat.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: change zbud_alloc size type to size_t
has been added to the -mm tree.  Its filename is
     mm-zbud-change-zbud_alloc-size-type-to-size_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-change-zbud_alloc-size-type-to-size_t.patch

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
Subject: mm/zbud: change zbud_alloc size type to size_t

Change the type of the zbud_alloc() size param from unsigned int
to size_t.

Technically, this should not make any difference, as the zbud
implementation already restricts the size to well within either
type's limits; but as zsmalloc (and kmalloc) use size_t, and
zpool will use size_t, this brings the size parameter type
in line with zsmalloc/zpool.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Cc: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zbud.h |    2 +-
 mm/zbud.c            |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/zbud.h~mm-zbud-change-zbud_alloc-size-type-to-size_t include/linux/zbud.h
--- a/include/linux/zbud.h~mm-zbud-change-zbud_alloc-size-type-to-size_t
+++ a/include/linux/zbud.h
@@ -11,7 +11,7 @@ struct zbud_ops {
 
 struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, unsigned int size,
+int zbud_alloc(struct zbud_pool *pool, size_t size,
 	unsigned long *handle);
 void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
diff -puN mm/zbud.c~mm-zbud-change-zbud_alloc-size-type-to-size_t mm/zbud.c
--- a/mm/zbud.c~mm-zbud-change-zbud_alloc-size-type-to-size_t
+++ a/mm/zbud.c
@@ -123,7 +123,7 @@ enum buddy {
 };
 
 /* Converts an allocation size in bytes to size in zbud chunks */
-static int size_to_chunks(int size)
+static int size_to_chunks(size_t size)
 {
 	return (size + CHUNK_SIZE - 1) >> CHUNK_SHIFT;
 }
@@ -250,8 +250,7 @@ void zbud_destroy_pool(struct zbud_pool
  * -EINVAL if the @size is 0, or -ENOMEM if the pool was unable to
  * allocate a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, unsigned int size,
-			unsigned long *handle)
+int zbud_alloc(struct zbud_pool *pool, size_t size, unsigned long *handle)
 {
 	int chunks, i, freechunks;
 	struct zbud_header *zhdr = NULL;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch

