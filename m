Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6AFEB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjGGTPd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjGGTPb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01943124
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8220961A39
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA359C433C7;
        Fri,  7 Jul 2023 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688757330;
        bh=SsBTq2pEFRAILI1rQX8ZjzR7Iq9389hYHZhiRI5Y6t8=;
        h=Date:To:From:Subject:From;
        b=GAdM2bVJcxNP03Ek5XVTksLNuESj5W2muEx1l/1JpvFQGkW8E+KuXJCN7f7A1vLrG
         kUc1dEs+zYZh8fKaaUBmHLYy/rN+b3yEWLB3JJMNXCIjBudOYiKLLZroU7facK6uIR
         aFe59fFDV0MOtjTpiyM/7Sd/YYaCw7E3mL5OEgbw=
Date:   Fri, 07 Jul 2023 12:15:29 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-use-the-correct-type-of-list-for-free-pages.patch added to mm-unstable branch
Message-Id: <20230707191529.DA359C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: use the correct type of list for free pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-use-the-correct-type-of-list-for-free-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-use-the-correct-type-of-list-for-free-pages.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: use the correct type of list for free pages
Date: Fri, 7 Jul 2023 16:51:46 +0800

Use the page->buddy_list instead of page->lru to clarify the correct type
of list for free pages.

Link: https://lkml.kernel.org/r/b21cd8e2e32b9a1d9bc9e43ebf8acaf35e87f8df.1688715750.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-the-correct-type-of-list-for-free-pages
+++ a/mm/compaction.c
@@ -1500,7 +1500,7 @@ static void fast_isolate_freepages(struc
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry_reverse(freepage, freelist, lru) {
+		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
 			unsigned long pfn;
 
 			order_scanned++;
@@ -1883,7 +1883,7 @@ static unsigned long fast_find_migratebl
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry(freepage, freelist, lru) {
+		list_for_each_entry(freepage, freelist, buddy_list) {
 			unsigned long free_pfn;
 
 			if (nr_scanned++ >= limit) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-use-the-correct-type-of-list-for-free-pages.patch
mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch

