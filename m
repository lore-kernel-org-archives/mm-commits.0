Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5FFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA87F60184
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhICU5E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhICU5E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 815E560231;
        Fri,  3 Sep 2021 20:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702563;
        bh=Im8YQIpbjD3fCa53dct61g8r8tXftgoI8EfBVWRKRVE=;
        h=Date:From:To:Subject:From;
        b=YPMwjZDUP7xQ8R9+4+/cYbopnaewoq4urRGKyUXYgCdkXWcOoGGi6r6v4HH8FXpC+
         s/+OgPhHGyfM+6HuKSyzh9MXOAoI2OckYlCASVPP8VoV4Xt2BoDS8xhlENqVTcg52F
         ApzCD9NZFpNUinVffnTBGObvJgrB7Maa/3NGDTCo=
Date:   Fri, 03 Sep 2021 13:56:03 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  [merged] writeback-rename-domain_update_bandwidth.patch
 removed from -mm tree
Message-ID: <20210903205603.WjgXdThxK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: rename domain_update_bandwidth()
has been removed from the -mm tree.  Its filename was
     writeback-rename-domain_update_bandwidth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jack@suse.cz are


