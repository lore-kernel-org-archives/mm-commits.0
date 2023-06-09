Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD69C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbjFIX2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjFIX1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A23A9D
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABEE361AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C526C433EF;
        Fri,  9 Jun 2023 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353256;
        bh=ToN+/ySGYmdVfDHvvs1/czaLlmp4Omc9+H0IazgxEqo=;
        h=Date:To:From:Subject:From;
        b=ptrfv7stOrDbm/pWvCXdyu7V/yNWNgoAJCyWRVfXFlvF0cb1KPMasn79LWU5wJxiY
         u0nDNkWM25/LS5MGffe5Sb3jWrROqlZp0DvJV3WwBYIEhNpjYwZSfM9M0rkX7RvxQv
         KeLFRJZ6I5vtztoqQOV5kYwcdQ/2Cf67IAOzjecI=
Date:   Fri, 09 Jun 2023 16:27:35 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch removed from -mm tree
Message-Id: <20230609232736.0C526C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: move mirrored_kernelcore into mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


