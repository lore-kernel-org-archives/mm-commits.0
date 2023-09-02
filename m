Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C424C71153
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbjIBWik (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjIBWij (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:38:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED80CED
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:38:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26DB5B80023
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4726C433C8;
        Sat,  2 Sep 2023 22:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693694313;
        bh=zT8FLeRZIWociSsWz3f2oi/S7cua6bjuYtg3f2P6gdg=;
        h=Date:To:From:Subject:From;
        b=j4Qt77QM+eq/zdudSTKwvGsSFVHc8i+mvALbNQWJqGdoHK00uDrkI/7tqVCkqCFt5
         HVDUadGsFUNbC0mMfSs+vEsfkJO67y8MSRUMs2XwckoRtCLw0CtVz1XV5cMH6Tnv3d
         Jx8o6wRTgvML/8MAY/NDBbly7BIM5JAzQgCFIr7g=
Date:   Sat, 02 Sep 2023 15:38:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch added to mm-unstable branch
Message-Id: <20230902223833.D4726C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove repeat compact_blockskip_flush check in reset_isolation_suitable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: remove repeat compact_blockskip_flush check in reset_isolation_suitable
Date: Fri, 1 Sep 2023 23:51:39 +0800

We have compact_blockskip_flush check in __reset_isolation_suitable, just
remove repeat check before __reset_isolation_suitable in
compact_blockskip_flush.

Link: https://lkml.kernel.org/r/20230901155141.249860-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable
+++ a/mm/compaction.c
@@ -382,6 +382,7 @@ static void __reset_isolation_suitable(s
 	bool source_set = false;
 	bool free_set = false;
 
+	/* Only flush if a full compaction finished recently */
 	if (!zone->compact_blockskip_flush)
 		return;
 
@@ -434,9 +435,7 @@ void reset_isolation_suitable(pg_data_t
 		if (!populated_zone(zone))
 			continue;
 
-		/* Only flush if a full compaction finished recently */
-		if (zone->compact_blockskip_flush)
-			__reset_isolation_suitable(zone);
+		__reset_isolation_suitable(zone);
 	}
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

