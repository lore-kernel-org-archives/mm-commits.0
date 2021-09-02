Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24448C43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B6376115C
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347838AbhIBVyV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347756AbhIBVyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39730610D2;
        Thu,  2 Sep 2021 21:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619593;
        bh=jRzEAfF4we4GyftA21skeapG/IoO+l1HQggWj654+rs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AToLtIgJs2ZXWNkrIaaOTjirGXDiN27eXI1k5tSQBTRePaLcxPMuHegfBq3PQzbO2
         yAtF9gMqfjKghkmJjkm5mI7k5/tIbFhjUY4JUAkKV82ZCiph/d0bsIjYY26aHEmjL0
         NekHLUSc6ba9ZTcnRbF7FVLdTS3KG3Lmmzj4DGQE=
Date:   Thu, 02 Sep 2021 14:53:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fengguang.wu@intel.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com, torvalds@linux-foundation.org
Subject:  [patch 061/212] writeback: rename
 domain_update_bandwidth()
Message-ID: <20210902215312.f0YaZnU5h%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jan Kara <jack@suse.cz>
Subject: writeback: rename domain_update_bandwidth()

Rename domain_update_bandwidth() to domain_update_dirty_limit().  The
original name is a misnomer.  The function has nothing to do with a
bandwidth, it updates dirty limits.

Link: https://lkml.kernel.org/r/20210713104716.22868-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c~writeback-rename-domain_update_bandwidth
+++ a/mm/page-writeback.c
@@ -1147,8 +1147,8 @@ update:
 	dom->dirty_limit = limit;
 }
 
-static void domain_update_bandwidth(struct dirty_throttle_control *dtc,
-				    unsigned long now)
+static void domain_update_dirty_limit(struct dirty_throttle_control *dtc,
+				      unsigned long now)
 {
 	struct wb_domain *dom = dtc_dom(dtc);
 
@@ -1353,7 +1353,7 @@ static void __wb_update_bandwidth(struct
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
 	if (update_ratelimit) {
-		domain_update_bandwidth(gdtc, now);
+		domain_update_dirty_limit(gdtc, now);
 		wb_update_dirty_ratelimit(gdtc, dirtied, elapsed);
 
 		/*
@@ -1361,7 +1361,7 @@ static void __wb_update_bandwidth(struct
 		 * compiler has no way to figure that out.  Help it.
 		 */
 		if (IS_ENABLED(CONFIG_CGROUP_WRITEBACK) && mdtc) {
-			domain_update_bandwidth(mdtc, now);
+			domain_update_dirty_limit(mdtc, now);
 			wb_update_dirty_ratelimit(mdtc, dirtied, elapsed);
 		}
 	}
_
