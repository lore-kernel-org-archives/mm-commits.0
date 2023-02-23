Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BC0C64ED8
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBWT4i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBWT4h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:56:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E5125B9
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:56:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A910B81A82
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F4AC433EF;
        Thu, 23 Feb 2023 19:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677182192;
        bh=2oHCiibQ12r0iiNANTqztmDqqBYJ5hwV0oaSYgbxmT4=;
        h=Date:To:From:Subject:From;
        b=vv7OxpaLHptdyUnjdtzT2aY31wReMAP2xuPKTK0njXgx373WbSJ/eLtDvuzZuxi/j
         MT8PDODtjD6X6CW07pkg4SMx4j3B/w0/jRy31m8Tzqba+QgXaLjluV1Zmg9FFq+6Bo
         i0UDNBpba/JHgOrUcqQt7CdD/+xZTWcF3rXtbH6Q=
Date:   Thu, 23 Feb 2023 11:56:32 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-remove-insert_zspage-inuse-optimization.patch added to mm-unstable branch
Message-Id: <20230223195632.D8F4AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove insert_zspage() ->inuse optimization
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-remove-insert_zspage-inuse-optimization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-remove-insert_zspage-inuse-optimization.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: remove insert_zspage() ->inuse optimization
Date: Thu, 23 Feb 2023 12:04:46 +0900

Patch series "zsmalloc: fine-grained fullness and new compaction
algorithm", v2.

Existing zsmalloc page fullness grouping leads to suboptimal page
selection for both zs_malloc() and zs_compact().  This patchset reworks
zsmalloc fullness grouping/classification.

Additionally it also implements new compaction algorithm that is expected
to use CPU-cycles (as it potentially does fewer memcpy-s in
zs_object_copy()).

TEST
====

It's very challenging to reliably test this series.  I ended up developing
my own synthetic test that has 100% reproducibility.  The test generates
significan fragmentation (for each size class) and then performs
compaction for each class individually and tracks the number of memcpy()
in zs_object_copy(), so that we can compare the amount work compaction
does on per-class basis.

Total amount of work (zram mm_stat objs_moved)
----------------------------------------------

Old fullness grouping, old compaction algorithm:
323977 memcpy() in zs_object_copy().

Old fullness grouping, new compaction algorithm:
262944 memcpy() in zs_object_copy().

New fullness grouping, new compaction algorithm:
213978 memcpy() in zs_object_copy().


Per-class compaction memcpy() comparison (T-test)
-------------------------------------------------

x Old fullness grouping, old compaction algorithm
+ Old fullness grouping, new compaction algorithm

    N           Min           Max        Median           Avg        Stddev
x 140           349          3513          2461     2314.1214     806.03271
+ 140           289          2778          2006     1878.1714     641.02073
Difference at 95.0% confidence
	-435.95 +/- 170.595
	-18.8387% +/- 7.37193%
	(Student's t, pooled s = 728.216)


x Old fullness grouping, old compaction algorithm
+ New fullness grouping, new compaction algorithm

    N           Min           Max        Median           Avg        Stddev
x 140           349          3513          2461     2314.1214     806.03271
+ 140           226          2279          1644     1528.4143     524.85268
Difference at 95.0% confidence
	-785.707 +/- 159.331
	-33.9527% +/- 6.88516%
	(Student's t, pooled s = 680.132)


This patch (of 6):

This optimization has no effect.  It only ensures that when a page was
added to its corresponding fullness list, its "inuse" counter was higher
or lower than the "inuse" counter of the page at the head of the list. 
The intention was to keep busy pages at the head, so they could be filled
up and moved to the ZS_FULL fullness group more quickly.  However, this
doesn't work as the "inuse" counter of a page can be modified by
obj_free() but the page may still belong to the same fullness list.  So,
fix_fullness_group() won't change the page's position in relation to the
head's "inuse" counter, leading to a largely random order of pages within
the fullness list.

For instance, consider a printout of the "inuse" counters of the first 10
pages in a class that holds 93 objects per zspage:

 ZS_ALMOST_EMPTY:  36  67  68  64  35  54  63  52

As we can see the page with the lowest "inuse" counter is actually the
head of the fullness list.

Link: https://lkml.kernel.org/r/20230223030451.543162-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20230223030451.543162-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-remove-insert_zspage-inuse-optimization
+++ a/mm/zsmalloc.c
@@ -753,37 +753,24 @@ static enum fullness_group get_fullness_
 }
 
 /*
- * Each size class maintains various freelists and zspages are assigned
- * to one of these freelists based on the number of live objects they
- * have. This functions inserts the given zspage into the freelist
- * identified by <class, fullness_group>.
+ * This function adds the given zspage to the fullness list identified
+ * by <class, fullness_group>.
  */
 static void insert_zspage(struct size_class *class,
-				struct zspage *zspage,
-				enum fullness_group fullness)
+			  struct zspage *zspage,
+			  enum fullness_group fullness)
 {
-	struct zspage *head;
-
 	class_stat_inc(class, fullness, 1);
-	head = list_first_entry_or_null(&class->fullness_list[fullness],
-					struct zspage, list);
-	/*
-	 * We want to see more ZS_FULL pages and less almost empty/full.
-	 * Put pages with higher ->inuse first.
-	 */
-	if (head && get_zspage_inuse(zspage) < get_zspage_inuse(head))
-		list_add(&zspage->list, &head->list);
-	else
-		list_add(&zspage->list, &class->fullness_list[fullness]);
+	list_add(&zspage->list, &class->fullness_list[fullness]);
 }
 
 /*
- * This function removes the given zspage from the freelist identified
+ * This function removes the given zspage from the fullness list identified
  * by <class, fullness_group>.
  */
 static void remove_zspage(struct size_class *class,
-				struct zspage *zspage,
-				enum fullness_group fullness)
+			  struct zspage *zspage,
+			  enum fullness_group fullness)
 {
 	VM_BUG_ON(list_empty(&class->fullness_list[fullness]));
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-remove-stat-and-fullness-enums.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-extend-compaction-statistics.patch
zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch

