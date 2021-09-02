Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE73C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4457610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347666AbhIBWCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347893AbhIBWCN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D3FA610E7;
        Thu,  2 Sep 2021 22:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620072;
        bh=SzvW1FD9Z7jDJpbupNPxlIQPOeZubWgjw+Wut/pl9bs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=clGKx0U0ylEgvZDWw6j1ue0B0mleLP8qVhAhDKrDAL1PZdNRS/K8NgtnDAK8PuV7b
         UJEplt6E6i42Ng0s5bwgndX8kWIboU59p1x/V5cpxCBysKcAqosA6h2WQaCrU874wl
         XWGSGbQXTCyYpRa1MRrtkWIutqpGjGsSudQOutCI=
Date:   Thu, 02 Sep 2021 15:01:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhangkui@oppo.com
Subject:  [patch 212/212] mm/madvise: add MADV_WILLNEED to
 process_madvise()
Message-ID: <20210902220111.lorKCcIsp%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: zhangkui <zhangkui@oppo.com>
Subject: mm/madvise: add MADV_WILLNEED to process_madvise()

There is a usecase in Android that an app process's memory is swapped out
by process_madvise() with MADV_PAGEOUT, such as the memory is swapped to
zram or a backing device.  When the process is scheduled to running, like
switch to foreground, multiple page faults may cause the app dropped
frames.

To reduce the problem, System Management Software can read-ahead memory
of the process immediately when the app switches to forground.  Calling
process_madvise() with MADV_WILLNEED can meet this need.

Link: https://lkml.kernel.org/r/20210804082010.12482-1-zhangkui@oppo.com
Signed-off-by: zhangkui <zhangkui@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-add-madv_willneed-to-process_madvise
+++ a/mm/madvise.c
@@ -1048,6 +1048,7 @@ process_madvise_behavior_valid(int behav
 	switch (behavior) {
 	case MADV_COLD:
 	case MADV_PAGEOUT:
+	case MADV_WILLNEED:
 		return true;
 	default:
 		return false;
_
