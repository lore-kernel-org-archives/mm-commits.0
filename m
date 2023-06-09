Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5360DC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjFIX2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjFIX1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D723AA8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D317B6169F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386C6C433EF;
        Fri,  9 Jun 2023 23:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353257;
        bh=67QUe1k/ch7oV8NmvwLMHcuNu2FRZFEU3t5Wvasg5jA=;
        h=Date:To:From:Subject:From;
        b=aMp34VZfS1UsPJoP8mPYJKUmPP2eZsvN8eGep/viliOMVctd+m4v8v09w7yeLwniz
         1I2pXFQ3+6gtsh79KeHmoGHDvJ6r9YXjDVi+tIm5PW0GTQ8L6X92kHcNzPMv/Fqfe7
         wIp4eQUaxMC5UzMN3oWiyOrH0t3hJpEIXyc8ryMk=
Date:   Fri, 09 Jun 2023 16:27:36 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch removed from -mm tree
Message-Id: <20230609232737.386C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: move init_on_alloc/free() into mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


