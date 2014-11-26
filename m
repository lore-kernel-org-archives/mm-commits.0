From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
 added to -mm tree
Date: Tue, 25 Nov 2014 16:06:24 -0800
Message-ID: <54751980.uROfyqDM8TQZZUNk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaKZAGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 19:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


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
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid duplicate assignment of prev_class

In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1) times. 
And the prev_class only references to the previous size_class.  So we do
not need unnecessary assignement.

This patch assigns *prev_class* when a new size_class structure is
allocated and uses prev_class to check whether the first class has been
allocated.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class
+++ a/mm/zsmalloc.c
@@ -981,6 +981,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 {
 	int i, ovhd_size;
 	struct zs_pool *pool;
+	struct size_class *prev_class = NULL;
 
 	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
 	pool = kzalloc(ovhd_size, GFP_KERNEL);
@@ -1002,7 +1003,6 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
-		struct size_class *prev_class;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
@@ -1018,8 +1018,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		 * characteristics. So, we makes size_class point to
 		 * previous size_class if possible.
 		 */
-		if (i < ZS_SIZE_CLASSES - 1) {
-			prev_class = pool->size_class[i + 1];
+		if (prev_class) {
 			if (can_merge(prev_class, size, pages_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
@@ -1035,6 +1034,8 @@ struct zs_pool *zs_create_pool(gfp_t fla
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
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

