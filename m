From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-change-stat-type-parameter-to-int.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:40:07 -0700
Message-ID: <20170911194007.i82j4zIPk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdIKTkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dianders@chromium.org, minchan@kernel.org, mka@chromium.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: mm/zsmalloc.c: change stat type parameter to int
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-change-stat-type-parameter-to-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: mm/zsmalloc.c: change stat type parameter to int

zs_stat_inc/dec/get() uses enum zs_stat_type for the stat type, however
some callers pass an enum fullness_group value.  Change the type to int to
reflect the actual use of the functions and get rid of 'enum-conversion'
warnings

Link: http://lkml.kernel.org/r/20170731175000.56538-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-change-stat-type-parameter-to-int mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-change-stat-type-parameter-to-int
+++ a/mm/zsmalloc.c
@@ -551,20 +551,23 @@ static int get_size_class_index(int size
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
+/* type can be of enum type zs_stat_type or fullness_group */
 static inline void zs_stat_inc(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
+				int type, unsigned long cnt)
 {
 	class->stats.objs[type] += cnt;
 }
 
+/* type can be of enum type zs_stat_type or fullness_group */
 static inline void zs_stat_dec(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
+				int type, unsigned long cnt)
 {
 	class->stats.objs[type] -= cnt;
 }
 
+/* type can be of enum type zs_stat_type or fullness_group */
 static inline unsigned long zs_stat_get(struct size_class *class,
-				enum zs_stat_type type)
+				int type)
 {
 	return class->stats.objs[type];
 }
_

Patches currently in -mm which might be from mka@chromium.org are


