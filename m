Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D17C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D619661074
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346353AbhIBVNI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346156AbhIBVNI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:13:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AD2E60FDA;
        Thu,  2 Sep 2021 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617129;
        bh=chfahDuWBFSDJsDcKLajadFrOxABz1iyXX5wqgC0Yo8=;
        h=Date:From:To:Subject:From;
        b=LuncWnBpCKXPzluimvlfBV5j2Kd8sSjz6BHkr/AUVz/zUBE1/vdLAR1Vze2m2H578
         GTr8atvOTutNtcXkcEVIlbkbmKJNGAUTkDJV2VDrExvN+bnlAUYFHFpfF7p4GwdHji
         9zE8kW7m4FFpTNjxJNHUTbR8FZaqQI2blypyhUMc=
Date:   Thu, 02 Sep 2021 14:12:09 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  [folded-merged]
 writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch removed from
 -mm tree
Message-ID: <20210902211209.PasLHBsLq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: avoid division by 0 in wb_update_dirty_ratelimit()
has been removed from the -mm tree.  Its filename was
     writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch

This patch was dropped because it was folded into writeback-fix-bandwidth-estimate-for-spiky-workload.patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: avoid division by 0 in wb_update_dirty_ratelimit()

Fixup patch "writeback: Fix bandwidth estimate for spiky workload" which
introduced possibility of __wb_update_bandwidth() getting called at a
moment when 'elapsed' evaluates to 0.

Cc: Jan Kara <jack@suse.cz>
Cc: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~writeback-fix-bandwidth-estimate-for-spiky-workload-fix
+++ a/mm/page-writeback.c
@@ -1336,11 +1336,19 @@ static void __wb_update_bandwidth(struct
 {
 	struct bdi_writeback *wb = gdtc->wb;
 	unsigned long now = jiffies;
-	unsigned long elapsed = now - wb->bw_time_stamp;
+	unsigned long elapsed;
 	unsigned long dirtied;
 	unsigned long written;
 
 	spin_lock(&wb->list_lock);
+
+	/*
+	 * Lockless checks for elapsed time are racy and delayed update after
+	 * IO completion doesn't do it at all (to make sure written pages are
+	 * accounted reasonably quickly). Make sure elapsed >= 1 to avoid
+	 * division errors.
+	 */
+	elapsed = max(now - wb->bw_time_stamp, 1UL);
 	dirtied = percpu_counter_read(&wb->stat[WB_DIRTIED]);
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
_

Patches currently in -mm which might be from jack@suse.cz are

writeback-track-number-of-inodes-under-writeback.patch
writeback-reliably-update-bandwidth-estimation.patch
writeback-fix-bandwidth-estimate-for-spiky-workload.patch
writeback-rename-domain_update_bandwidth.patch
writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

