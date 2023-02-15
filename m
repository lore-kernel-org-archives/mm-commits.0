Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9033C636CC
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 23:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBOXag (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 18:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBOXaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 18:30:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E3543458
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 15:30:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7B861DE7
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 23:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD016C433D2;
        Wed, 15 Feb 2023 23:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676503833;
        bh=S9pYsD3fRjPXtIHIyUFyxeoTXi2yEkjl7/AF/rF/27g=;
        h=Date:To:From:Subject:From;
        b=VOcxoqSB/Gx8zQVaf77MYQrItvT6PACF9eO7SaY+0Viw3nHgwlaI8aM2qs1mMaejI
         B5ObBdg4HhEVBPR4B8vbUWwtr766KVzJZEV+X+PsV59c+7vYZpPaNdHZFwdc82obmq
         Oy3lW+oOH9QkNJC9AKJwWT17z4a5QZEECXDOYJJo=
Date:   Wed, 15 Feb 2023 15:30:33 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20230215233033.CD016C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: cleanup 'ret' variable usage in do_migrate_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/memory_hotplug: cleanup 'ret' variable usage in do_migrate_range()
Date: Wed, 15 Feb 2023 23:03:00 +0000

Because do_migrate_range() returns nothing, some 'ret' variable usages are
unnecessary.  Remove unnecessary usage and reduce its scope.

Link: https://lkml.kernel.org/r/20230215230300.61125-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1624,7 +1624,6 @@ static void do_migrate_range(unsigned lo
 {
 	unsigned long pfn;
 	struct page *page, *head;
-	int ret = 0;
 	LIST_HEAD(source);
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1678,7 +1677,6 @@ static void do_migrate_range(unsigned lo
 						    page_is_file_lru(page));
 
 		} else {
-			ret = -EBUSY;
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n", pfn);
 				dump_page(page, "isolation failed");
@@ -1692,6 +1690,7 @@ static void do_migrate_range(unsigned lo
 			.nmask = &nmask,
 			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 		};
+		int ret;
 
 		/*
 		 * We have checked that migration range is on a single zone so
_

Patches currently in -mm which might be from sj@kernel.org are

mm-memory_hotplug-return-nothing-from-do_migrate_range.patch
mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range.patch

