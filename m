Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8963C7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjEPWWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjEPWWf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:22:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6005B92
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0F9863FEF
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57949C433EF;
        Tue, 16 May 2023 22:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275753;
        bh=Of0A+5vI8AN77XZB63iH+3xNUg6nyLAYxWu4T7tIOG0=;
        h=Date:To:From:Subject:From;
        b=nM0aYjvZy3qwF6T2C7qlmM6JhHZI9frWk2Q6tpx/e4BEt/ZlUXqTfNnVWZsqWNJmK
         7PiIIs3p+hBoJ9pdOSxTL5dyTYN1M93LTU3GSBF150hWJ1VDU5UhN2VMs9qxIBF7rL
         5Q0PcNvs0i/CxxsXkfOuWAXfUI7y2HLyIfIx1TpM=
Date:   Tue, 16 May 2023 15:22:32 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch added to mm-unstable branch
Message-Id: <20230516222233.57949C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move init_on_alloc/free() into mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch

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
Subject: mm: page_alloc: move init_on_alloc/free() into mm_init.c
Date: Tue, 16 May 2023 14:38:10 +0800

Since commit f2fc4b44ec2b ("mm: move init_mem_debugging_and_hardening() to
mm/mm_init.c"), the init_on_alloc() and init_on_free() define is better to
move there too.

Link: https://lkml.kernel.org/r/20230516063821.121844-3-wangkefeng.wang@huawei.com
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

 mm/mm_init.c    |    6 ++++++
 mm/page_alloc.c |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-page_alloc-move-init_on_alloc-free-into-mm_initc
+++ a/mm/mm_init.c
@@ -2543,6 +2543,12 @@ void __init memblock_free_pages(struct p
 	__free_pages_core(page, order);
 }
 
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
+EXPORT_SYMBOL(init_on_alloc);
+
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
+EXPORT_SYMBOL(init_on_free);
+
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
 static int __init early_init_on_alloc(char *buf)
--- a/mm/page_alloc.c~mm-page_alloc-move-init_on_alloc-free-into-mm_initc
+++ a/mm/page_alloc.c
@@ -233,11 +233,6 @@ unsigned long totalcma_pages __read_most
 
 int percpu_pagelist_high_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
-DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
-EXPORT_SYMBOL(init_on_alloc);
-
-DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
-EXPORT_SYMBOL(init_on_free);
 
 /*
  * A cached value of the page's pageblock's migratetype, used when the page is
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

