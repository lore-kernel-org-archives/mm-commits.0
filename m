Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5E1C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjFIXc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjFIXbg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1934686
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD9C63EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE15C433D2;
        Fri,  9 Jun 2023 23:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353358;
        bh=MXWkWtIqW6ZahP+kgLWVVJEpfMsg6jnNg+gceoao88A=;
        h=Date:To:From:Subject:From;
        b=OU39kiAUmtI9XiwnPkLUL5jzABrGWpouoHjTZhFceXeF37yXwyn196xHJY4TNjYQa
         qBkQJ2DCr/Kctcta/FIiRjIzaM1IFM27JNMoNrq3Eh9Vc5CzxNwRCebWmaP6Po8RnW
         Dk5l9ZQvTJKhJaec09vwKdnG5Z/mPqmwwbJg2wBg=
Date:   Fri, 09 Jun 2023 16:29:18 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch removed from -mm tree
Message-Id: <20230609232918.AFE15C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: drop the redundant page validation in update_pageblock_skip()
has been removed from the -mm tree.  Its filename was
     mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: drop the redundant page validation in update_pageblock_skip()
Date: Thu, 25 May 2023 20:53:56 +0800

Patch series "Misc cleanups and improvements for compaction".

This series cantains some cleanups and improvements for compaction.


This patch (of 6):

The caller has validated the page before calling
update_pageblock_skip(), thus drop the redundant page validation in
update_pageblock_skip().

Link: https://lkml.kernel.org/r/5142e15b9295fe8c447dbb39b7907a20177a1413.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip
+++ a/mm/compaction.c
@@ -436,9 +436,6 @@ static void update_pageblock_skip(struct
 	if (cc->no_set_skip_hint)
 		return;
 
-	if (!page)
-		return;
-
 	set_pageblock_skip(page);
 
 	/* Update where async and sync compaction should restart */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


