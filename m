Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912B2C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 19:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbiEQT5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 15:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbiEQT5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 15:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC0438DB8
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 12:57:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C5F61555
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 19:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F941C385B8;
        Tue, 17 May 2022 19:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652817467;
        bh=t+Y9YtXbjMFmELiiCILsTxetN+DjMDRm5pxUEWZ6/EI=;
        h=Date:To:From:Subject:From;
        b=BNH1DjXRyhap7AiXUGM4eVM7fYEKsz+PAtAyVKra1Lj/rbv0YcwqoUS73Ntv3YLa0
         dhdeFGv/BuW40stFN+AxE6pOXhy1Ma8Ps7WXPI/m4mtTpvj1//u71PqjJIluS4/zMl
         wvjHnz1zXoAeBGbDjED1QaOa0qvo6GY4YdD5KUXE=
Date:   Tue, 17 May 2022 12:57:46 -0700
To:     mm-commits@vger.kernel.org, vvs@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch added to mm-unstable branch
Message-Id: <20220517195747.1F941C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/trace/events/percpu.h: cleanup for "percpu: improve percpu_alloc_percpu event trace"
has been added to the -mm mm-unstable branch.  Its filename is
     cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch

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
Subject: include/trace/events/percpu.h: cleanup for "percpu: improve percpu_alloc_percpu event trace"
Date: Tue, 17 May 2022 09:55:51 +0300

Fix sparse warning about incorrect gfp_t cast.

Link: https://lkml.kernel.org/r/001979f3-e978-0998-cbed-61a4a2ac87b8@openvz.org
Fixes: f67bed134a05 ("percpu: improve percpu_alloc_percpu event trace")
Signed-off-by: Vasily Averin <vvs@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/percpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/percpu.h~cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace
+++ a/include/trace/events/percpu.h
@@ -28,7 +28,7 @@ TRACE_EVENT(percpu_alloc_percpu,
 		__field(	int,			off		)
 		__field(	void __percpu *,	ptr		)
 		__field(	size_t,			bytes_alloc	)
-		__field(	gfp_t,			gfp_flags	)
+		__field(	unsigned long,		gfp_flags	)
 	),
 	TP_fast_assign(
 		__entry->call_site	= call_site;
@@ -40,7 +40,7 @@ TRACE_EVENT(percpu_alloc_percpu,
 		__entry->off		= off;
 		__entry->ptr		= ptr;
 		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
+		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 	),
 
 	TP_printk("call_site=%pS reserved=%d is_atomic=%d size=%zu align=%zu base_addr=%p off=%d ptr=%p bytes_alloc=%zu gfp_flags=%s",
_

Patches currently in -mm which might be from vvs@openvz.org are

tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch
cleanup-for-tracing-incorrect-gfp_t-conversion.patch
cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch

