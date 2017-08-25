From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-change-stat-type-parameter-to-int.patch added to
 -mm tree
Date: Fri, 25 Aug 2017 14:46:08 -0700
Message-ID: <59a09aa0.FHdXx3eLrJGQ9MJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756702AbdHYVqJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 17:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, dianders@chromium.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: change stat type parameter to int
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-change-stat-type-parameter-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-change-stat-type-parameter-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-change-stat-type-parameter-to-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch
mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch
mm-zsmalloc-change-stat-type-parameter-to-int.patch
bitops-avoid-integer-overflow-in-genmask_ull.patch

