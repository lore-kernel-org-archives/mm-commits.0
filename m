Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A440C61DA3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 23:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCCX3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCCX3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 18:29:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3972BED5
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 15:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D021B819FA
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 23:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA39C433EF;
        Fri,  3 Mar 2023 23:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677886136;
        bh=cDpR82iYzYyHeHekYyjVRqcTS3lqzzjO28KBoZKm834=;
        h=Date:To:From:Subject:From;
        b=hcKVRNG1qt6/FaIqfpUBWBHKwwa6DhUb4Nie2PATjXt+eCUQbQw55FCCuoiTlnNLU
         xgZyX/M2Vr3eIsVWmhlRIuEb4ApLYUned55t1jm+k6p9qLbxWpwThXWavSLKGd7jto
         IT6Dz6r1exCd4TbBngKxV0rFkjVLAsgovXxVUESo=
Date:   Fri, 03 Mar 2023 15:28:56 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-remove-insert_zspage-inuse-optimization.patch added to mm-unstable branch
Message-Id: <20230303232856.BAA39C433EF@smtp.kernel.org>
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
Date: Fri, 3 Mar 2023 16:31:27 +0900

Patch series "zsmalloc: fine-grained fullness and new compaction
algorithm", v3.

Existing zsmalloc page fullness grouping leads to suboptimal page
selection for both zs_malloc() and zs_compact().  This patchset reworks
zsmalloc fullness grouping/classification.

Additionally it also implements new compaction algorithm that is expected
to use less CPU-cycles (as it potentially does fewer memcpy-s in
zs_object_copy()).

Test (synthetic) results can be seen in patch 0003.


This patch (of 4):

This optimization has no effect.  It only ensures that when a zspage was
added to its corresponding fullness list, its "inuse" counter was higher
or lower than the "inuse" counter of the zspage at the head of the list. 
The intention was to keep busy zspages at the head, so they could be
filled up and moved to the ZS_FULL fullness group more quickly.  However,
this doesn't work as the "inuse" counter of a zspage can be modified by
obj_free() but the zspage may still belong to the same fullness list.  So,
fix_fullness_group() won't change the zspage's position in relation to the
head's "inuse" counter, leading to a largely random order of zspages
within the fullness list.

For instance, consider a printout of the "inuse" counters of the first 10
zspages in a class that holds 93 objects per zspage:

 ZS_ALMOST_EMPTY:  36  67  68  64  35  54  63  52

As we can see the zspage with the lowest "inuse" counter is actually the
head of the fullness list.

Remove this pointless "optimisation".

Link: https://lkml.kernel.org/r/20230303073130.1950714-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20230303073130.1950714-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-remove-insert_zspage-inuse-optimization
+++ a/mm/zsmalloc.c
@@ -753,32 +753,19 @@ static enum fullness_group get_fullness_
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
 				struct zspage *zspage,
 				enum fullness_group fullness)
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
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-show-per-fullness-group-class-stats.patch

