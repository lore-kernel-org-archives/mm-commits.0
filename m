Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8CDC77B70
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjC1XWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjC1XVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8652630E9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23156619A3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789D7C433EF;
        Tue, 28 Mar 2023 23:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045696;
        bh=WCVKgpQ20VImkn2Ur0CqnIpCXPYFMqIjQy2JdUmYYVk=;
        h=Date:To:From:Subject:From;
        b=Pg15i630XhYYySS81JsPrnNANAIV/UarAG3TIwILMtIrEeLHYo5a24Hdd8Dxo0w45
         kl7oOUleaULGkcXqVmHgcsUlVGAziDlMrCkr1fQKFuW40S0+dgnL8snx3+95PqNJri
         loSrNsUzvi8iLmDgjElXBBLmRMu8yPxoFkP/f86M=
Date:   Tue, 28 Mar 2023 16:21:36 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-remove-insert_zspage-inuse-optimization.patch removed from -mm tree
Message-Id: <20230328232136.789D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: remove insert_zspage() ->inuse optimization
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-insert_zspage-inuse-optimization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: remove insert_zspage() ->inuse optimization
Date: Sat, 4 Mar 2023 12:48:32 +0900

Patch series "zsmalloc: fine-grained fullness and new compaction
algorithm", v4.

Existing zsmalloc page fullness grouping leads to suboptimal page
selection for both zs_malloc() and zs_compact().  This patchset reworks
zsmalloc fullness grouping/classification.

Additinally it also implements new compaction algorithm that is expected
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

As we can see the zspage with the lowest "inuse" counter
is actually the head of the fullness list.

Remove this pointless "optimisation".

Link: https://lkml.kernel.org/r/20230304034835.2082479-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20230304034835.2082479-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-remove-insert_zspage-inuse-optimization
+++ a/mm/zsmalloc.c
@@ -762,19 +762,8 @@ static void insert_zspage(struct size_cl
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
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-document-new-fullness-grouping.patch
zsmalloc-document-freeable-stats.patch

