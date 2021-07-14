Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6792C07E96
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E18561380
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhGNBQv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237198AbhGNBQv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C73F36136E;
        Wed, 14 Jul 2021 01:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225240;
        bh=t2flSFZ2iCBbvSB3SX5HvII2NRVe8uzVraH+fAG1inE=;
        h=Date:From:To:Subject:From;
        b=YFSoLq7AVfKSzBLbWqJYrrMr/o8fRu+MwValzEb4AJHCxY7GeSE56/Zad3C5VoDNN
         OpYWfZmucov/1qqBxSdwfnyqtsh6kINFdZNmt6hlTG3JhIGmTjnRhXFfhswOCWSfRe
         Wyhp2mlhBN/InHQl9vLc9HulG204DvDO4uDY2sZ8=
Date:   Tue, 13 Jul 2021 18:14:00 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  + writeback-rename-domain_update_bandwidth.patch added to
 -mm tree
Message-ID: <20210714011400.56yBf4n5w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: rename domain_update_bandwidth()
has been added to the -mm tree.  Its filename is
     writeback-rename-domain_update_bandwidth.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-rename-domain_update_bandwidth.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-rename-domain_update_bandwidth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
@@ -1345,7 +1345,7 @@ static void __wb_update_bandwidth(struct
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
 	if (update_ratelimit) {
-		domain_update_bandwidth(gdtc, now);
+		domain_update_dirty_limit(gdtc, now);
 		wb_update_dirty_ratelimit(gdtc, dirtied, elapsed);
 
 		/*
@@ -1353,7 +1353,7 @@ static void __wb_update_bandwidth(struct
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

writeback-track-number-of-inodes-under-writeback.patch
writeback-reliably-update-bandwidth-estimation.patch
writeback-fix-bandwidth-estimate-for-spiky-workload.patch
writeback-rename-domain_update_bandwidth.patch
writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

