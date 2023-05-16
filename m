Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78646C7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjEPWWp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjEPWWp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:22:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B32C59E6
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC53C63FF2
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F69EC433EF;
        Tue, 16 May 2023 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275763;
        bh=kJFYrY25Z2yfhZlyJt7oqKDu93xCGTvYO7YY7wStuFs=;
        h=Date:To:From:Subject:From;
        b=DdXQhQPb3BYOyOYkQFpQFih1znssJd9mAoO6s4kZhym+D9Lm7NmBnwY9OuJ+GxWOt
         7kGhbbMAis+T8Fn3qgwZyJjcJz8qeXF2KKH0KSrFzEzgu+jNh62u8VisZQ0oh3CMrj
         RNhOxp2jhZP8ATtbVmck5vEJ5aXBXyJTzpstBCRg=
Date:   Tue, 16 May 2023 15:22:42 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch added to mm-unstable branch
Message-Id: <20230516222243.1F69EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: remove alloc_contig_dump_pages() stub
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: remove alloc_contig_dump_pages() stub
Date: Tue, 16 May 2023 14:38:14 +0800

DEFINE_DYNAMIC_DEBUG_METADATA and DYNAMIC_DEBUG_BRANCH already has stub
definitions without dynamic debug feature, remove unnecessary
alloc_contig_dump_pages() stub.

Link: https://lkml.kernel.org/r/20230516063821.121844-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-alloc_contig_dump_pages-stub
+++ a/mm/page_alloc.c
@@ -6250,8 +6250,6 @@ out:
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
-#if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
 {
@@ -6265,11 +6263,6 @@ static void alloc_contig_dump_pages(stru
 			dump_page(page, "migration failure");
 	}
 }
-#else
-static inline void alloc_contig_dump_pages(struct list_head *page_list)
-{
-}
-#endif
 
 /* [start, end) must belong to a single zone. */
 int __alloc_contig_migrate_range(struct compact_control *cc,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch
mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch
mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch
mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch
mm-page_alloc-collect-mem-statistic-into-show_memc.patch
mm-page_alloc-squash-page_is_consistent.patch
mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch
mm-page_alloc-split-out-fail_page_alloc.patch
mm-page_alloc-split-out-debug_pagealloc.patch
mm-page_alloc-move-mark_free_page-into-snapshotc.patch
mm-page_alloc-move-pm_-function-into-power.patch
mm-vmscan-use-gfp_has_io_fs.patch
mm-page_alloc-move-sysctls-into-it-own-fils.patch
mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

