Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E890C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF362087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816473;
	bh=I1oPvgUFXZI/JchfhpOsS+KnjOIOJFmcW5JgN5nAvcw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IJhV5GPN6qSRgZNaraZI822g0mAEpMfZfU48dfsVflC6gINxQHwY7MEcwccst/Qhe
	 bj8dB9RB1XP6j23SSCBIMJCvY3ZUgWIT0xLY6s2EODkkqZJr+7ukPRUpFpoh4m53J3
	 iL1NwOv+vX8/PsWfIGNDUQkbwd70rpETkrZ7Gh60=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbgJPCrw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404354AbgJPCrw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7302074D;
        Fri, 16 Oct 2020 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816471;
        bh=I1oPvgUFXZI/JchfhpOsS+KnjOIOJFmcW5JgN5nAvcw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fmeKkKKLHkWdZ9pDL3wvDulqdmcELidkTWBm5+CTP28Coxp/WspyUbWbx55UQeXtE
         oQVxpMXOpthkU4LqjuH7DMOtZRXwlR1YYaPmEEX/Sj/9X3crSVsd2WHhEbVgPLPIQv
         EW64Kqwaap8M7urPKLx50TARa+HugLc7nfJCuMOc=
Date:   Thu, 15 Oct 2020 19:47:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 106/156] lib: dynamic_queue_limits: delete
 duplicated words + fix typo
Message-ID: <20201016024750.uQmFdMBiM%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
