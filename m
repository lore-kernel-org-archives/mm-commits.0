From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch added to -mm tree
Date: Tue, 02 Dec 2014 14:46:30 -0800
Message-ID: <547e4146.QloAocsLM/seETHY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaLBWqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2014 17:46:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: allocate exactly size of struct zs_pool
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch

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
Subject: mm/zsmalloc: allocate exactly size of struct zs_pool

In zs_create_pool(), we allocate memory more then sizeof(struct zs_pool)
  ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);

This patch allocate memory of exactly needed size.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool
+++ a/mm/zsmalloc.c
@@ -979,12 +979,11 @@ static bool can_merge(struct size_class
  */
 struct zs_pool *zs_create_pool(gfp_t flags)
 {
-	int i, ovhd_size;
+	int i;
 	struct zs_pool *pool;
 	struct size_class *prev_class = NULL;
 
-	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
-	pool = kzalloc(ovhd_size, GFP_KERNEL);
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

