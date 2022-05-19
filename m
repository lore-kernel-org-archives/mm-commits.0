Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A19C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiESW0e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiESW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8313833E0E
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6565961693
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC36C385B8;
        Thu, 19 May 2022 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999163;
        bh=I+PezEkHrLMOHrwmj44v17fGzClljxvw242QQ/lAeHI=;
        h=Date:To:From:Subject:From;
        b=h0BvqGFfznSAP7vptvNnaVIZqr3W8WY5NSMjlY38jZ0kR2A9Gcr9x0VgENmyAxBh9
         Oo7onhAdU4QpPlPqtZcs7FO655Ykxp9JzPmQrGNszhM/MQQVZWPwrZ3lgVh1a1wHx/
         dE9TY07jCBPMtseSRZxYP+2ZTdwhRWJr8ZiUTqUI=
Date:   Thu, 19 May 2022 15:26:03 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, vvs@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch removed from -mm tree
Message-Id: <20220519222603.BBC36C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate
has been removed from the -mm tree.  Its filename was
     tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vasily Averin <vvs@openvz.org>
Subject: tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate
Date: Wed, 11 May 2022 12:46:53 +0300

Fixes following sparse warnings:

  CHECK   mm/vmscan.c
mm/vmscan.c: note: in included file (through
include/trace/trace_events.h, include/trace/define_trace.h,
include/trace/events/vmscan.h):
./include/trace/events/vmscan.h:281:1: sparse: warning:
 cast to restricted isolate_mode_t
./include/trace/events/vmscan.h:281:1: sparse: warning:
 restricted isolate_mode_t degrades to integer

Link: https://lkml.kernel.org/r/e85d7ff2-fd10-53f8-c24e-ba0458439c1b@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/vmscan.h~tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate
+++ a/include/trace/events/vmscan.h
@@ -297,7 +297,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
-		__field(isolate_mode_t, isolate_mode)
+		__field(unsigned int, isolate_mode)
 		__field(int, lru)
 	),
 
@@ -308,7 +308,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
-		__entry->isolate_mode = isolate_mode;
+		__entry->isolate_mode = (__force unsigned int)isolate_mode;
 		__entry->lru = lru;
 	),
 
_

Patches currently in -mm which might be from vvs@openvz.org are

cleanup-for-tracing-incorrect-gfp_t-conversion.patch
cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch

