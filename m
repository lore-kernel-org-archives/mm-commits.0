Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6983C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37C56101D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhHISSz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhHISSz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 14:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D6A660F8F;
        Mon,  9 Aug 2021 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628533114;
        bh=h/b5HBVXsicgtOd9dyEu9T568eSILpesqiYn+UH2yfs=;
        h=Date:From:To:Subject:From;
        b=fnJKNasTDD8mvh66//A/M6a9CDBOngdh9WREuJ8wt9+ADREhBVU9lcf5g6qTYCAWm
         MHIADHhDLDo5vKnXshSOSA5LL2lbizPVtkJWaX1Z0hU0I0RQ91YSS5Zm9Ex/LLf3kb
         Q06X6IzpzFRLppH4JyAfI06xEBc/JTTu4yK1No10=
Date:   Mon, 09 Aug 2021 11:18:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        mhocko@suse.com
Subject:  + memcg-fix-up-drain_local_stock-comment.patch added to -mm
 tree
Message-ID: <20210809181834.0nacR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix up drain_local_stock comment
has been added to the -mm tree.  Its filename is
     memcg-fix-up-drain_local_stock-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-up-drain_local_stock-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-up-drain_local_stock-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are

memcg-fix-up-drain_local_stock-comment.patch

