Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC68FC4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C934B60F9C
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhHCVbO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 17:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232478AbhHCVbN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 17:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD7660F46;
        Tue,  3 Aug 2021 21:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628026261;
        bh=FHYOooyjsTDiGoWpBL7o/TB1qrNjrzQVyWn5p/e4cn8=;
        h=Date:From:To:Subject:From;
        b=GmIjw+ptssGi/rjvqM5BTKrEpwtTPiQGF9o3qoE6ubyXBgchccKFVoOIMrKlNrP1Z
         AMNiWD+3B3OOmYjvPOtLX2L/oNWqzcCjQvSQJX22hn+ZPlXBay45hYf1jE4++f21A0
         4gosyUZDOgACWLXKTzpPloPL7fjWyn1cbiG/t7wc=
Date:   Tue, 03 Aug 2021 14:31:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stapelberg+linux@google.com,
        fengguang.wu@intel.com, jack@suse.cz
Subject:  +
 writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch added to -mm
 tree
Message-ID: <20210803213101.XDK-R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: avoid division by 0 in wb_update_dirty_ratelimit()
has been added to the -mm tree.  Its filename is
     writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch

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
writeback-fix-bandwidth-estimate-for-spiky-workload-fix.patch
writeback-rename-domain_update_bandwidth.patch
writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

