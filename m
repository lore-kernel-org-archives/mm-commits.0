Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8716AC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70102603E9
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347866AbhIBV5F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347809AbhIBV5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B443B60E8B;
        Thu,  2 Sep 2021 21:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619762;
        bh=bY3M8n7R+bSmNyWrrMDODU6pKoCv3v0lKroeb+F9a9Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qotbJSczJEC884Wpm6uIy+SbjW+93jG6V3LAke/FtCKOYlmKTas9c9/C3k3iL6tLy
         i9MhOyDLfqSTCQGl4BwB/GvUlgj1erG/jV4HLi+ThNyVEc9STt6dChqR68CVDKV7d8
         KYg8ScaDkFNjYA6Hm8h6l6bO9yHzvnCYgtO4j2OA=
Date:   Thu, 02 Sep 2021 14:56:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 113/212] memcg: fix up drain_local_stock comment
Message-ID: <20210902215602.ErIiniI2k%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: memcg: fix up drain_local_stock comment

Thomas and Vlastimil have noticed that the comment in drain_local_stock
doesn't quite make sense.  It talks about a synchronization with the
memory hotplug but there is no actual memory hotplug involvement here.  I
meant to talk about cpu hotplug here.  Fix that up and hopefuly make the
comment more helpful by referencing the cpu hotplug callback as well.

Link: https://lkml.kernel.org/r/YRDwOhVglJmY7ES5@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-fix-up-drain_local_stock-comment
+++ a/mm/memcontrol.c
@@ -2178,8 +2178,9 @@ static void drain_local_stock(struct wor
 	unsigned long flags;
 
 	/*
-	 * The only protection from memory hotplug vs. drain_stock races is
-	 * that we always operate on local CPU stock here with IRQ disabled
+	 * The only protection from cpu hotplug (memcg_hotplug_cpu_dead) vs.
+	 * drain_stock races is that we always operate on local CPU stock
+	 * here with IRQ disabled
 	 */
 	local_irq_save(flags);
 
_
