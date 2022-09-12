Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF83C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiILD3D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiILD2w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97AB275D9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A687CB80C71
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61712C433D7;
        Mon, 12 Sep 2022 03:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953314;
        bh=+aUmEO3tU12KS+rwSBzUtHeXgEhLO5ED9wE6k2jP55Y=;
        h=Date:To:From:Subject:From;
        b=xGBxHHQKjOUVNFEtJJD5DvjbefYo7PGSHN6iaETb7MlGwd1Ozmnt9l8E/eLw5Ov0F
         4K+bAeBRmJdJNSYKsYSakRXc2K5mKTifBNpKtcmUMGvSR2xNeWbnesjvnRcQHstnkG
         G5toQt4o9ZmUClMFdIG70N+u5RYfJxa24Mi5n68A=
Date:   Sun, 11 Sep 2022 20:28:33 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch removed from -mm tree
Message-Id: <20220912032834.61712C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: define macros for refaults in struct lruvec
has been removed from the -mm tree.  Its filename was
     mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmscan: define macros for refaults in struct lruvec
Date: Mon, 8 Aug 2022 00:56:45 +0000

The magic number 0 and 1 are used in several places in vmscan.c.
Define macros for them to improve code readability.

Link: https://lkml.kernel.org/r/20220808005644.1721066-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmscan.c            |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-define-macros-for-refaults-in-struct-lruvec
+++ a/include/linux/mmzone.h
@@ -306,6 +306,8 @@ static inline bool is_active_lru(enum lr
 	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
+#define WORKINGSET_ANON 0
+#define WORKINGSET_FILE 1
 #define ANON_AND_FILE 2
 
 enum lruvec_flags {
--- a/mm/vmscan.c~mm-vmscan-define-macros-for-refaults-in-struct-lruvec
+++ a/mm/vmscan.c
@@ -3230,7 +3230,7 @@ again:
 
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_ANON);
-		if (refaults != target_lruvec->refaults[0] ||
+		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
 			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
 			sc->may_deactivate |= DEACTIVATE_ANON;
 		else
@@ -3243,7 +3243,7 @@ again:
 		 */
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_FILE);
-		if (refaults != target_lruvec->refaults[1] ||
+		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
 		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
 			sc->may_deactivate |= DEACTIVATE_FILE;
 		else
@@ -3559,9 +3559,9 @@ static void snapshot_refaults(struct mem
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
-	target_lruvec->refaults[0] = refaults;
+	target_lruvec->refaults[WORKINGSET_ANON] = refaults;
 	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
-	target_lruvec->refaults[1] = refaults;
+	target_lruvec->refaults[WORKINGSET_FILE] = refaults;
 }
 
 /*
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

filemap-make-the-accounting-of-thrashing-more-consistent.patch
delayacct-support-re-entrance-detection-of-thrashing-accounting.patch
mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

