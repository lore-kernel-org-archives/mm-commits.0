From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:08:58 -0800
Message-ID: <548d0d5a.EiAnPKq2oR9DhrrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaLNEIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: allocate exactly size of struct zs_pool
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

