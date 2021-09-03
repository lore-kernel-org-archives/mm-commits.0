Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B649C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2B9D61131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350551AbhICU7Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350017AbhICU7M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BED5610FB;
        Fri,  3 Sep 2021 20:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702691;
        bh=bDAAgP3nsLAIRxeI7+bkjZETDxI6CyaoOud9vhEvYCk=;
        h=Date:From:To:Subject:From;
        b=yKQCCr+CWVl8WbxeIbPCqmX1TXnbLWQ8o6bo4fV2AMuxzZ6m1GRDYGeOmKFql36zj
         fMvAo8rkMzeX6NajwxGHG+AtVC8aSSfnevfbwf7FVjLtpYb1kLI7OD+lU5g4dYXhJg
         WTZqeoOtwo5uya8kRQ7zEHKZCxD6BWoMTc5MidBw=
Date:   Fri, 03 Sep 2021 13:58:11 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, tglx@linutronix.de,
        vbabka@suse.cz
Subject:  [merged] memcg-fix-up-drain_local_stock-comment.patch
 removed from -mm tree
Message-ID: <20210903205811.OvJDhxMOg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix up drain_local_stock comment
has been removed from the -mm tree.  Its filename was
     memcg-fix-up-drain_local_stock-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


