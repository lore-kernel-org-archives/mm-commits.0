From: akpm@linux-foundation.org
Subject: + mm-zbud-change-zbud_alloc-size-type-to-size_t.patch added to
 -mm tree
Date: Wed, 16 Jul 2014 14:52:20 -0700
Message-ID: <53c6f414.2jABb7TJQZJ5fV9K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54976 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaGPVwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 17:52:22 -0400
Received: by mail-qc0-f202.google.com with SMTP id i17so217104qcy.3
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 14:52:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


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
implementation already restricts the size to well within either type's
limits; but as zsmalloc (and kmalloc) use size_t, and zpool will use
size_t, this brings the size parameter type in line with zsmalloc/zpool.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zbud.h |    2 +-
 mm/zbud.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/zbud.h~mm-zbud-change-zbud_alloc-size-type-to-size_t include/linux/zbud.h
--- a/include/linux/zbud.h~mm-zbud-change-zbud_alloc-size-type-to-size_t
+++ a/include/linux/zbud.h
@@ -11,7 +11,7 @@ struct zbud_ops {
 
 struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	unsigned long *handle);
 void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
diff -puN mm/zbud.c~mm-zbud-change-zbud_alloc-size-type-to-size_t mm/zbud.c
--- a/mm/zbud.c~mm-zbud-change-zbud_alloc-size-type-to-size_t
+++ a/mm/zbud.c
@@ -122,7 +122,7 @@ enum buddy {
 };
 
 /* Converts an allocation size in bytes to size in zbud chunks */
-static int size_to_chunks(int size)
+static int size_to_chunks(size_t size)
 {
 	return (size + CHUNK_SIZE - 1) >> CHUNK_SHIFT;
 }
@@ -247,7 +247,7 @@ void zbud_destroy_pool(struct zbud_pool
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch

