Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630D5C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C8921775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881585;
	bh=GVoGKyb15yKXMSJOIq49QYpAd3HdEQ3keEZ6Q5PPiK8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zOZ5q1PdzIuLrVpth8aWp9a/l0ZqbWMn9bI7ZYkU7zwjOdPSq+9gz6llDOvwb9qiY
	 tP/YqgjLc6+g0JEguMBzi5idLpFl+y6Anrbsjm9n8YdcilovPhXbn7pRAk0xFjN5Ua
	 QCNChvd77ZVTLpD2077zogzVJX6ZR2Jnz1uYOgsA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407010AbgJPUxE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393599AbgJPUxB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A222B216C4;
        Fri, 16 Oct 2020 20:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881580;
        bh=GVoGKyb15yKXMSJOIq49QYpAd3HdEQ3keEZ6Q5PPiK8=;
        h=Date:From:To:Subject:From;
        b=ByTf6BGNP7IwBynJA39JTL/FqIxLQz/lBhzqZTsuqvdX4IscsAktcWjgoju0WHynI
         GgCHgel8e2HyDGwmlF2xTVX4wXPII0p7/xCDCFBKC/m2HCoG0wMmHkkDx06b803KVK
         g3MeiHVQe7MxKenZcVJR3HFtbNXYzpDjoPxQuNJA=
Date:   Fri, 16 Oct 2020 13:53:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch removed
 from -mm tree
Message-ID: <20201016205300.WX0O0TPi_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: dynamic_queue_limits: delete duplicated words + fix typo
has been removed from the -mm tree.  Its filename was
     lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: dynamic_queue_limits: delete duplicated words + fix typo

Drop the repeated word "the".
Fix spelling of "excess".

Link: https://lkml.kernel.org/r/20200823040449.25946-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_queue_limits.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/dynamic_queue_limits.c~lib-dynamic_queue_limits-delete-duplicated-words-fix-typo
+++ a/lib/dynamic_queue_limits.c
@@ -60,8 +60,8 @@ void dql_completed(struct dql *dql, unsi
 		 * A decrease is only considered if the queue has been busy in
 		 * the whole interval (the check above).
 		 *
-		 * If there is slack, the amount of execess data queued above
-		 * the the amount needed to prevent starvation, the queue limit
+		 * If there is slack, the amount of excess data queued above
+		 * the amount needed to prevent starvation, the queue limit
 		 * can be decreased.  To avoid hysteresis we consider the
 		 * minimum amount of slack found over several iterations of the
 		 * completion routine.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


