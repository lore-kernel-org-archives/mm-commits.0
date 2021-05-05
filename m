Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F19C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A8C0610A1
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhEEBhp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBho (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10F69611AB;
        Wed,  5 May 2021 01:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178609;
        bh=xpzRKtecqke6yjSUVTfsCTimEhpYQdrwsYJyx1BuD6g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=keRcSDhB+Drwj8AfCmNmPy69ekXDb1RoLZ+qCMuinqLKKhbwu5eZOb9w2vKrqM0ef
         N/sUAiHqHBcyvtVp5A2ZEXjJYOLqMFWumy1SQ3Ki20v2j/VHP8bZ7Gcq1HcQRL4ZKH
         Odc9mhEyJTUekcuzyoZSCNc135f/dnG3cw8TqOec=
Date:   Tue, 04 May 2021 18:36:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pintu.ping@gmail.com,
        pintu@codeaurora.org, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 075/143] mm/compaction: remove unused variable
 sysctl_compact_memory
Message-ID: <20210505013648.vLvZKUIbY%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pintu Kumar <pintu@codeaurora.org>
Subject: mm/compaction: remove unused variable sysctl_compact_memory

The sysctl_compact_memory is mostly unused in mm/compaction.c
It just acts as a place holder for sysctl to store .data.

But the .data itself is not needed here.
So we can get ride of this variable completely and make .data as NULL.
This will also eliminate the extern declaration from header file.
No functionality is broken or changed this way.

Link: https://lkml.kernel.org/r/1614852224-14671-1-git-send-email-pintu@codeaurora.org
Signed-off-by: Pintu Kumar <pintu@codeaurora.org>
Signed-off-by: Pintu Agarwal <pintu.ping@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    1 -
 kernel/sysctl.c            |    2 +-
 mm/compaction.c            |    3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-remove-unused-variable-sysctl_compact_memory
+++ a/include/linux/compaction.h
@@ -81,7 +81,6 @@ static inline unsigned long compact_gap(
 }
 
 #ifdef CONFIG_COMPACTION
-extern int sysctl_compact_memory;
 extern unsigned int sysctl_compaction_proactiveness;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos);
--- a/kernel/sysctl.c~mm-compaction-remove-unused-variable-sysctl_compact_memory
+++ a/kernel/sysctl.c
@@ -2830,7 +2830,7 @@ static struct ctl_table vm_table[] = {
 #ifdef CONFIG_COMPACTION
 	{
 		.procname	= "compact_memory",
-		.data		= &sysctl_compact_memory,
+		.data		= NULL,
 		.maxlen		= sizeof(int),
 		.mode		= 0200,
 		.proc_handler	= sysctl_compaction_handler,
--- a/mm/compaction.c~mm-compaction-remove-unused-variable-sysctl_compact_memory
+++ a/mm/compaction.c
@@ -2692,9 +2692,6 @@ static void compact_nodes(void)
 		compact_node(nid);
 }
 
-/* The written value is actually unused, all memory is compacted */
-int sysctl_compact_memory;
-
 /*
  * Tunable for proactive compaction. It determines how
  * aggressively the kernel should compact memory in the
_
