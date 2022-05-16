Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E29C43217
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 21:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348753AbiEPVBm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 17:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349476AbiEPVBW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 17:01:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8883445782
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 13:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21398B81636
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 20:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB3AC34115;
        Mon, 16 May 2022 20:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652733539;
        bh=FmTmalTzv8E7kJ5NOs1e7Q1MYyctKjfCvL7lURTHI2s=;
        h=Date:To:From:Subject:From;
        b=lFiPmkoysL6hY58+j/U4PAiDDFCOinaLVyKNWPptMaGOFig17lemekVcX0JbdxSq6
         TdTZLH0kzbqqdp93XyIPvimVvxZb7Xqq5ltkjjlrSrnVKeNZQsQj0uAiCa3mXOpP6O
         u6RQQNFTOfVxnlT2eWoD1vDObpkq0MAL8h/MCIUE=
Date:   Mon, 16 May 2022 13:38:59 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, vvs@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch added to mm-unstable branch
Message-Id: <20220516203859.BCB3AC34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate
has been added to the -mm mm-unstable branch.  Its filename is
     tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch

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

tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch

