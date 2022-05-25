Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C7BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbiEYRtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiEYRs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6108E50B3E
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05A82B81E8F
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893A5C34113;
        Wed, 25 May 2022 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500934;
        bh=TYUsdTUWIoiaN7kC0iRJnQz4U4PiaIDMsdh/Qgi7x5o=;
        h=Date:To:From:Subject:From;
        b=NP+0qQJbfxZk+gItuTRr7j7Jy6foyYPpOXg7KjN6uKyHcy78Tchdr1Uj+eyNzDzSI
         dnpyb7ag+9XmUnaVPAr7tMSz+roXEuCS6LJeqIXWa/Z8WmK/Y+gWQ968ZeiDASdurF
         aT0BI1zf6wQlvyAx0e5pKHssxZzSQ9D4LdGuPrq0=
Date:   Wed, 25 May 2022 10:48:53 -0700
To:     mm-commits@vger.kernel.org, vvs@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch removed from -mm tree
Message-Id: <20220525174854.893A5C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/trace/events/percpu.h: cleanup for "percpu: improve percpu_alloc_percpu event trace"
has been removed from the -mm tree.  Its filename was
     cleanup-for-percpu-improve-percpu_alloc_percpu-event-trace.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


