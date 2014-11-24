From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
 added to -mm tree
Date: Mon, 24 Nov 2014 13:09:12 -0800
Message-ID: <54739e78.FX5h0Hvrh4wSJYWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKXVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 16:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, iamjoonsoo.kim@lge.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid duplicate assignment of prev_class
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid duplicate assignment of prev_class

In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1) times. 
And the prev_class only references to the previous size_class.  So we do
not need unnecessary assignement.

This patch assigns *prev_class* when a new size_class structure is
allocated and uses prev_class to check whether the first class has been
allocated.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class
+++ a/mm/zsmalloc.c
@@ -980,7 +980,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
-		struct size_class *prev_class;
+		struct size_class *prev_class = NULL;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
@@ -996,8 +996,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		 * characteristics. So, we makes size_class point to
 		 * previous size_class if possible.
 		 */
-		if (i < ZS_SIZE_CLASSES - 1) {
-			prev_class = pool->size_class[i + 1];
+		if (prev_class) {
 			if (can_merge(prev_class, size, pages_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
@@ -1013,6 +1012,8 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		class->pages_per_zspage = pages_per_zspage;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
+
+		prev_class = class;
 	}
 
 	pool->flags = flags;
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

