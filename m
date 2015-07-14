From: akpm@linux-foundation.org
Subject: + mm-zbud-constify-the-zbud_ops.patch added to -mm tree
Date: Tue, 14 Jul 2015 15:42:11 -0700
Message-ID: <55a59043.5F79MShqQzSIrLq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbbGNWmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zbud: constify the zbud_ops
has been added to the -mm tree.  Its filename is
     mm-zbud-constify-the-zbud_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-constify-the-zbud_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-constify-the-zbud_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: mm: zbud: constify the zbud_ops

The structure zbud_ops is not modified so make the pointer to it a
pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zbud.h |    2 +-
 mm/zbud.c            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/zbud.h~mm-zbud-constify-the-zbud_ops include/linux/zbud.h
--- a/include/linux/zbud.h~mm-zbud-constify-the-zbud_ops
+++ a/include/linux/zbud.h
@@ -9,7 +9,7 @@ struct zbud_ops {
 	int (*evict)(struct zbud_pool *pool, unsigned long handle);
 };
 
-struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
+struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
 int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	unsigned long *handle);
diff -puN mm/zbud.c~mm-zbud-constify-the-zbud_ops mm/zbud.c
--- a/mm/zbud.c~mm-zbud-constify-the-zbud_ops
+++ a/mm/zbud.c
@@ -96,7 +96,7 @@ struct zbud_pool {
 	struct list_head buddied;
 	struct list_head lru;
 	u64 pages_nr;
-	struct zbud_ops *ops;
+	const struct zbud_ops *ops;
 #ifdef CONFIG_ZPOOL
 	struct zpool *zpool;
 	const struct zpool_ops *zpool_ops;
@@ -133,7 +133,7 @@ static int zbud_zpool_evict(struct zbud_
 		return -ENOENT;
 }
 
-static struct zbud_ops zbud_zpool_ops = {
+static const struct zbud_ops zbud_zpool_ops = {
 	.evict =	zbud_zpool_evict
 };
 
@@ -302,7 +302,7 @@ static int num_free_chunks(struct zbud_h
  * Return: pointer to the new zbud pool or NULL if the metadata allocation
  * failed.
  */
-struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops)
+struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops)
 {
 	struct zbud_pool *pool;
 	int i;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
linux-next.patch

