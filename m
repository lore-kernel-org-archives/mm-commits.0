From: akpm@linux-foundation.org
Subject: + zram-drop-gfp_t-from-zcomp_strm_alloc.patch added to -mm tree
Date: Tue, 31 May 2016 12:10:54 -0700
Message-ID: <574de1be.CpZ2CvSBgIK7GllX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcEaTKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: drop gfp_t from zcomp_strm_alloc()
has been added to the -mm tree.  Its filename is
     zram-drop-gfp_t-from-zcomp_strm_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-drop-gfp_t-from-zcomp_strm_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-drop-gfp_t-from-zcomp_strm_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: drop gfp_t from zcomp_strm_alloc()

We now allocate streams from CPU_UP hot-plug path, there are no
context-dependent stream allocations anymore and we can schedule from
zcomp_strm_alloc().  Use GFP_KERNEL directly and drop a gfp_t parameter.

Link: http://lkml.kernel.org/r/20160531122017.2878-9-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-drop-gfp_t-from-zcomp_strm_alloc drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-drop-gfp_t-from-zcomp_strm_alloc
+++ a/drivers/block/zram/zcomp.c
@@ -39,9 +39,9 @@ static void zcomp_strm_free(struct zcomp
  * allocate new zcomp_strm structure with ->tfm initialized by
  * backend, return NULL on error
  */
-static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp, gfp_t flags)
+static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 {
-	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), flags);
+	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_KERNEL);
 	if (!zstrm)
 		return NULL;
 
@@ -50,7 +50,7 @@ static struct zcomp_strm *zcomp_strm_all
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
-	zstrm->buffer = (void *)__get_free_pages(flags | __GFP_ZERO, 1);
+	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
 	if (IS_ERR_OR_NULL(zstrm->tfm) || !zstrm->buffer) {
 		zcomp_strm_free(zstrm);
 		zstrm = NULL;
@@ -158,7 +158,7 @@ static int __zcomp_cpu_notifier(struct z
 	case CPU_UP_PREPARE:
 		if (WARN_ON(*per_cpu_ptr(comp->stream, cpu)))
 			break;
-		zstrm = zcomp_strm_alloc(comp, GFP_KERNEL);
+		zstrm = zcomp_strm_alloc(comp);
 		if (IS_ERR_OR_NULL(zstrm)) {
 			pr_err("Can't allocate a compression stream\n");
 			return NOTIFY_BAD;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-align-zcomp-interface-to-crypto-comp-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-add-more-compression-algorithms.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

