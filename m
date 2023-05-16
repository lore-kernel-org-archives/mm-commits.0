Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8737FC77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjEPWWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjEPWWe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:22:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3678759DA
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0BB633C2
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241EAC433EF;
        Tue, 16 May 2023 22:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275751;
        bh=t92NrfITsC0xl/HXm3rFEigdjk9CFBA6LMC7U0QXMSA=;
        h=Date:To:From:Subject:From;
        b=Yw92nRnvmTVapaQoWVnBlvMmgXQLXl6bjiACAYEX0d9qAGYGLSt+Fr0I9iMXnDUQm
         YvKDKpebx6inkEqEIPmiJQoKv5ABSmaK16Isf2PP2RIqDHWZA3SjLZmqqaziiDK/Xd
         w+BpehjlVdUnhDu+YWTnvCq27D9OefShfm551n7A=
Date:   Tue, 16 May 2023 15:22:30 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch added to mm-unstable branch
Message-Id: <20230516222231.241EAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move mirrored_kernelcore into mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch

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
Subject: mm: page_alloc: move mirrored_kernelcore into mm_init.c
Date: Tue, 16 May 2023 14:38:09 +0800

Patch series "mm: page_alloc: misc cleanup and refactor", v2.

This aims to reduce more space in page_alloc.c, also do some cleanup, no
functional changes intended.


This patch (of 13):

Since commit 9420f89db2dd ("mm: move most of core MM initialization to
mm/mm_init.c"), mirrored_kernelcore should be moved into mm_init.c, as
most related codes are already there.

Link: https://lkml.kernel.org/r/20230516063821.121844-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230516063821.121844-2-wangkefeng.wang@huawei.com
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

 mm/mm_init.c    |    2 ++
 mm/page_alloc.c |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-page_alloc-move-mirrored_kernelcore-into-mm_initc
+++ a/mm/mm_init.c
@@ -259,6 +259,8 @@ static int __init cmdline_parse_core(cha
 	return 0;
 }
 
+bool mirrored_kernelcore __initdata_memblock;
+
 /*
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
--- a/mm/page_alloc.c~mm-page_alloc-move-mirrored_kernelcore-into-mm_initc
+++ a/mm/page_alloc.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
-#include <linux/memblock.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kasan.h>
@@ -374,8 +373,6 @@ int user_min_free_kbytes = -1;
 int watermark_boost_factor __read_mostly = 15000;
 int watermark_scale_factor = 10;
 
-bool mirrored_kernelcore __initdata_memblock;
-
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
 EXPORT_SYMBOL(movable_zone);
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

