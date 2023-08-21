Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525F3EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjHUUlF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjHUUk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16379194
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6273B64B08
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A5DC433C8;
        Mon, 21 Aug 2023 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650403;
        bh=v5ai9unk4baPeJ+AYthKfcz96pCE3YRwcNteSlR4JYc=;
        h=Date:To:From:Subject:From;
        b=MwVTEcZDwnqXIlTP0uqMOBVyenUiRJuDcmsGHzpPElN6ocu9RKvqtp6Z6LXvMpWdH
         X+hiLhoNdyfjA46nPRhS0NiJJRgTWyK9Q26HpOX0Gfb8jqVWi+JTRlgsCZYzsn2438
         mfp9beBgOrQpm1RetpwckN8d5y+mH/WNyHRktepw=
Date:   Mon, 21 Aug 2023 13:40:03 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huawei.com,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch removed from -mm tree
Message-Id: <20230821204003.B0A5DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: remove unnecessary "else continue" at end of loop in isolate_freepages_block
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: remove unnecessary "else continue" at end of loop in isolate_freepages_block
Date: Thu, 3 Aug 2023 17:49:01 +0800

There is no behavior change to remove "else continue" code at end of scan
loop.  Just remove it to make code cleaner.

Link: https://lkml.kernel.org/r/20230803094901.2915942-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kemeng Shi <shikemeng@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block
+++ a/mm/compaction.c
@@ -671,8 +671,6 @@ static unsigned long isolate_freepages_b
 isolate_fail:
 		if (strict)
 			break;
-		else
-			continue;
 
 	}
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


