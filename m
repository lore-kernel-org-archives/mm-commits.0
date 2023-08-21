Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F969EE49B0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjHUUla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjHUUki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC95C1BF
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1965864526
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2F9C433C7;
        Mon, 21 Aug 2023 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650420;
        bh=DN9WExoWVRSN8sHM98TfeQHwhqgwN8437X/Tz0w9Hj4=;
        h=Date:To:From:Subject:From;
        b=tpEdhJ3/uKm/OOK9UAful+EcblVrSImKiVNk2WandqdvJ1/zz7W3EsbCsc0RDfuEG
         54H6eppo6EV7z0bsXTQzPJeG4skIKkYeHOYpkvIBD5M51Bs/H43M81hUUWOxDlgchn
         v62cz0t+G48NzHe25jqKe48a8VtUFPqA7eEVns/s=
Date:   Mon, 21 Aug 2023 13:40:19 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-correct-comment-to-complete-migration-failure.patch removed from -mm tree
Message-Id: <20230821204020.6E2F9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: correct comment to complete migration failure
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-comment-to-complete-migration-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: correct comment to complete migration failure
Date: Fri, 4 Aug 2023 19:04:52 +0800

Commit cfccd2e63e7e0 ("mm, compaction: finish pageblocks on complete
migration failure") convert cc->order aligned check to page block order
aligned check.  Correct comment relevant with it.

Link: https://lkml.kernel.org/r/20230804110454.2935878-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-correct-comment-to-complete-migration-failure
+++ a/mm/compaction.c
@@ -2532,7 +2532,7 @@ rescan:
 			}
 			/*
 			 * If an ASYNC or SYNC_LIGHT fails to migrate a page
-			 * within the current order-aligned block and
+			 * within the pageblock_order-aligned block and
 			 * fast_find_migrateblock may be used then scan the
 			 * remainder of the pageblock. This will mark the
 			 * pageblock "skip" to avoid rescanning in the near
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


