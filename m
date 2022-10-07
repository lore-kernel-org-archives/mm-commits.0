Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4088C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Oct 2022 21:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJGV3U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGV3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2022 17:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4182A8F258
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 14:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E72CBB80D68
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 21:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C0C433C1;
        Fri,  7 Oct 2022 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665178155;
        bh=vA1t20dWgzOJDCOIEKHGibCtiZuU8ur0EhPPm2guxSU=;
        h=Date:To:From:Subject:From;
        b=LKSSt1ZWSMvIUY9pS49Uu9K3c8Wa2mLdLbkUgGrBAdCOlUGDK5PKsi/8bhAlpwEWc
         5PCewKFsqkQt4JKgtYr7v5vxZmCt5ZuicythxvID+IWW7T2XgPngWu5XhemEeKTD71
         eHR3GjqMH6YF6CKhbX+eCHBOc5M35soLDr+7s7Vw=
Date:   Fri, 07 Oct 2022 14:29:14 -0700
To:     mm-commits@vger.kernel.org, axelrasmussen@google.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-dont-sync-disk-for-each-aging-cycle.patch removed from -mm tree
Message-Id: <20221007212915.818C0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mglru: don't sync disk for each aging cycle
has been removed from the -mm tree.  Its filename was
     mm-mglru-dont-sync-disk-for-each-aging-cycle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: don't sync disk for each aging cycle
Date: Wed, 28 Sep 2022 13:36:58 -0600

wakeup_flusher_threads() was added under the assumption that if a system
runs out of clean cold pages, it might want to write back dirty pages more
aggressively so that they can become clean and be dropped.

However, doing so can breach the rate limit a system wants to impose on
writeback, resulting in early SSD wearout.

Link: https://lkml.kernel.org/r/YzSiWq9UEER5LKup@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-dont-sync-disk-for-each-aging-cycle
+++ a/mm/vmscan.c
@@ -4413,8 +4413,6 @@ done:
 	if (wq_has_sleeper(&lruvec->mm_state.wait))
 		wake_up_all(&lruvec->mm_state.wait);
 
-	wakeup_flusher_threads(WB_REASON_VMSCAN);
-
 	return true;
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are


