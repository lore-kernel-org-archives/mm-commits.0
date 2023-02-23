Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AFFC64ED8
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBWT4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBWT4o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:56:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0F59410
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E59ABB81A82
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D1C433D2;
        Thu, 23 Feb 2023 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677182200;
        bh=1d4TL9Pz1gFTLUMFVR6sw8GlHMoMr3d4lVTh9sSy8fk=;
        h=Date:To:From:Subject:From;
        b=JuR1F4Ochle5Y72AsLNIZG0DjeXtuBZJf1udg9EuYeL9I35FaulH+CwgeL+L3c3Q2
         WjuDJh/Bxdzzv6rSZZjvUldJ9U1GMtrV6itwcOy9cbTCXNwkLG0YuObLIeBN88xQbf
         0lAIyCgh9FHezhF0f1CHVdJDVWeOPHFhCal3+4NU=
Date:   Thu, 23 Feb 2023 11:56:40 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-extend-compaction-statistics.patch added to mm-unstable branch
Message-Id: <20230223195640.A20D1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: extend compaction statistics
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-extend-compaction-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-extend-compaction-statistics.patch

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
Subject: zsmalloc: extend compaction statistics
Date: Thu, 23 Feb 2023 12:04:50 +0900

Extend zsmalloc zs_pool_stats with a new member that holds the number of
objects pool compaction moved between pool pages.

Link: https://lkml.kernel.org/r/20230223030451.543162-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    2 ++
 mm/zsmalloc.c            |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/zsmalloc.h~zsmalloc-extend-compaction-statistics
+++ a/include/linux/zsmalloc.h
@@ -36,6 +36,8 @@ enum zs_mapmode {
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
 	atomic_long_t pages_compacted;
+	/* How many objects were migrated during compaction */
+	atomic_long_t objs_moved;
 };
 
 struct zs_pool;
--- a/mm/zsmalloc.c~zsmalloc-extend-compaction-statistics
+++ a/mm/zsmalloc.c
@@ -1815,6 +1815,7 @@ static void migrate_zspage(struct zs_poo
 		obj_idx++;
 		record_obj(handle, free_obj);
 		obj_free(class->size, used_obj, NULL);
+		atomic_long_inc(&pool->stats.objs_moved);
 	}
 
 	/* Remember last position in this iteration */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-remove-stat-and-fullness-enums.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-extend-compaction-statistics.patch
zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch

