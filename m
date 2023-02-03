Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62074C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjBCGny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjBCGmN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AF91F913
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A4861DB1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7426FC4339B;
        Fri,  3 Feb 2023 06:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406305;
        bh=xAzOHJq6aPKl8+0laP/ntPJZJC2uWjhc3UxO7TqQmZo=;
        h=Date:To:From:Subject:From;
        b=C5YTSZQbclmewp5qy2yg8FZnD+iYUVtsUvDGXOkF9M8DWBWk3xdUpnOWLgb06FbbM
         v3GkO3EGorpPUUBuQHOIkkH/RLJsc4BMiqvlXX4lcF1SNlqHsz94lhYvcNKdKnZ8ZM
         pOvjqvmowcWHLuL7RM9XiPfq+TwPrQs5+yMfUhvU=
Date:   Thu, 02 Feb 2023 22:38:24 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch removed from -mm tree
Message-Id: <20230203063825.7426FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: check if a page has been captured before draining PCP pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, compaction: check if a page has been captured before draining PCP pages
Date: Wed, 25 Jan 2023 13:44:32 +0000

If a page has been captured then draining is unnecssary so check first for
a captured page.

Link: https://lkml.kernel.org/r/20230125134434.18017-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages
+++ a/mm/compaction.c
@@ -2439,6 +2439,12 @@ compact_zone(struct compact_control *cc,
 			}
 		}
 
+		/* Stop if a page has been captured */
+		if (capc && capc->page) {
+			ret = COMPACT_SUCCESS;
+			break;
+		}
+
 check_drain:
 		/*
 		 * Has the migration scanner moved away from the previous
@@ -2457,12 +2463,6 @@ check_drain:
 				last_migrated_pfn = 0;
 			}
 		}
-
-		/* Stop if a page has been captured */
-		if (capc && capc->page) {
-			ret = COMPACT_SUCCESS;
-			break;
-		}
 	}
 
 out:
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


