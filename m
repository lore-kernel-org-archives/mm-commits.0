Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EA6C04AA9
	for <mm-commits@archiver.kernel.org>; Wed, 20 Sep 2023 16:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbjITQHY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbjITQHY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Sep 2023 12:07:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CB1D3
        for <mm-commits@vger.kernel.org>; Wed, 20 Sep 2023 09:07:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDE8C433CD;
        Wed, 20 Sep 2023 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695226037;
        bh=E+4vgkh9U/1OH2mEtMrnfyQ5dEHhDRIMbv4IXXLdwv8=;
        h=Date:To:From:Subject:From;
        b=B6upFWKOJU6FL3IW09xsuqpMMF42AyWZBsAq5EQONaZTQ73JmhW++/lrXlH7Lzz1/
         +i4AOjdM1jZa34NpTNOZjRwo8+/9dKz1oAOjM7o/Z1CsvPcnSwqfyrIgExuYlB/XW0
         WVJJ4FoPsKIcFH+mCMJVhWEYsIO5FM4KWHb0dUWU=
Date:   Wed, 20 Sep 2023 09:07:17 -0700
To:     mm-commits@vger.kernel.org, wangyun@bilibili.com,
        bsingharora@gmail.com, wenyuli@ex.bilibili.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-add-memory-reclaim-delay-in-get_page_from_freelist.patch added to mm-unstable branch
Message-Id: <20230920160717.CCDE8C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: add memory reclaim delay in get_page_from_freelist
has been added to the -mm mm-unstable branch.  Its filename is
     delayacct-add-memory-reclaim-delay-in-get_page_from_freelist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-add-memory-reclaim-delay-in-get_page_from_freelist.patch

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
From: liwenyu <wenyuli@ex.bilibili.com>
Subject: delayacct: add memory reclaim delay in get_page_from_freelist
Date: Wed, 20 Sep 2023 17:38:49 +0800

The current memory reclaim delay statistics only count the direct memory
reclaim of the task in do_try_to_free_pages().  In systems with NUMA open,
some tasks occasionally experience slower response times, but the total
count of reclaim does not increase, using ftrace can show that
node_reclaim has occurred.

The memory reclaim occurring in get_page_from_freelist() is also due to
heavy memory load.  To get the impact of tasks in memory reclaim, this
patch adds the statistics of the memory reclaim delay statistics for
__node_reclaim().

Link: https://lkml.kernel.org/r/181C946095F0252B+7cc60eca-1abf-4502-aad3-ffd8ef89d910@ex.bilibili.com
Signed-off-by: Wen Yu Li <wenyuli@ex.bilibili.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <wangyun@bilibili.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c~delayacct-add-memory-reclaim-delay-in-get_page_from_freelist
+++ a/mm/vmscan.c
@@ -7350,6 +7350,7 @@ static int __node_reclaim(struct pglist_
 
 	cond_resched();
 	psi_memstall_enter(&pflags);
+	delayacct_freepages_start();
 	fs_reclaim_acquire(sc.gfp_mask);
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
@@ -7372,6 +7373,7 @@ static int __node_reclaim(struct pglist_
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc.gfp_mask);
 	psi_memstall_leave(&pflags);
+	delayacct_freepages_end();
 
 	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from wenyuli@ex.bilibili.com are

delayacct-add-memory-reclaim-delay-in-get_page_from_freelist.patch

