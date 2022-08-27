Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A5BECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiH0BmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiH0BmO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFDAE9A9D
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73C95B83115
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E53C433D6;
        Sat, 27 Aug 2022 01:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661564531;
        bh=4V+/L7k5sUzcu+9M05AUMKfTJc3lzrxhXhkyGrjyQ98=;
        h=Date:To:From:Subject:From;
        b=U7zLDLLUf9Hr79c2IXfI3MeJNrBtGKuGsUX9rU+kJ4E4WJE8wI8aKUncCuuNjfiPr
         heUYGgyMGL28RtAAvYHq1oJsnwUGMEuBQzYAKbLPvi1f5FVZHUw4fMgJ4P4ZJ3kEvN
         dgtyU2lJfNavK+9/UZyt8sof2t/VKr8pkNz8hhb4=
Date:   Fri, 26 Aug 2022 18:42:10 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, liushixin2@huawei.com, ddstreet@ieee.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch removed from -mm tree
Message-Id: <20220827014211.13E53C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix
has been removed from the -mm tree.  Its filename was
     mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch

This patch was dropped because it was folded into mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix
Date: Thu Aug 25 06:59:19 PM PDT 2022

s/init_zswap/zswap_init/

Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix
+++ a/mm/zswap.c
@@ -1556,7 +1556,7 @@ cache_fail:
 	return -ENOMEM;
 }
 
-static int __init init_zswap(void)
+static int __init zswap_init(void)
 {
 	/* skip init if zswap is disabled when system startup */
 	if (!zswap_enabled)
@@ -1565,7 +1565,7 @@ static int __init init_zswap(void)
 }
 
 /* must be late so crypto has time to come up */
-late_initcall(init_zswap);
+late_initcall(zswap_init);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Seth Jennings <sjennings@variantweb.net>");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

