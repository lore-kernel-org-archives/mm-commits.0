Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0851CC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66F6221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781333;
	bh=4GM+OdBs020kSyD8E3UZo77r6Tblr8fQbRSIP0O90fY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Lb+AHqWsKHS78MR1jHeAUu6wIiFKfivouveM8pP0bKrrldj2p2EyPcFADOonDGDs3
	 pWelC09gHV6DUt2fApyubXoMsKzmunF7ei3sR/Ji8s3a1GPHMet/x5OYalS0P2Z0PB
	 vBftPRCA/AN64QYeTP4Q74YVEhrbfw+6DOf+NRMU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGWN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A579E2177B;
        Fri,  7 Aug 2020 06:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781333;
        bh=4GM+OdBs020kSyD8E3UZo77r6Tblr8fQbRSIP0O90fY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wwNq4cSW+rOfQ09zKGk0FlKNjl7J9BgbgYstyDUlJBIuUsQOXaZN+WnV3EkYpg6Nt
         OEgjDC4pacZNYuaFxBXJGzCHbyH7tu0wN38Qr62Lccza7vM/BRkHH7p0/iQZ+B7ENu
         YnYLvhkdp+GZz8QukJ8mK7NaALF4KineU865wo3M=
Date:   Thu, 06 Aug 2020 23:22:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 091/163] mm: memcontrol: restore proper dirty
 throttling when memory.high changes
Message-ID: <20200807062212.z-72hz3Ek%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: restore proper dirty throttling when memory.high changes

Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
memory.high") inadvertently removed a callback to recalculate the
writeback cache size in light of a newly configured memory.high limit.

Without letting the writeback cache know about a potentially heavily
reduced limit, it may permit too many dirty pages, which can cause
unnecessary reclaim latencies or even avoidable OOM situations.

This was spotted while reading the code, it hasn't knowingly caused any
problems in practice so far.

Link: http://lkml.kernel.org/r/20200728135210.379885-1-hannes@cmpxchg.org
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes
+++ a/mm/memcontrol.c
@@ -6273,6 +6273,8 @@ static ssize_t memory_high_write(struct
 
 	page_counter_set_high(&memcg->memory, high);
 
+	memcg_wb_domain_size_changed(memcg);
+
 	return nbytes;
 }
 
_
