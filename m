Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9F0C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F268461CA4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhGFTXc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C7E061C9C;
        Tue,  6 Jul 2021 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599252;
        bh=NEfVrvO9+Wzv0ytS0pdB5isa2tXTRqaV+fGQV7AoZ7c=;
        h=Date:From:To:Subject:From;
        b=yK4fyQ7ivXLjb/RkCBRzOLOq7FHGm1HtdW3PzAismoaKcSGfYRviY4qXuHhJiW4p6
         keru4VPDLbUzcrxmHWCKgpTZZsIy190L0Bq8j4lmdyP6BqETk31N23/UGD2u8znBh9
         cIp1RGRdSR4RTlXDQxv8jyMpHIqQ/fFabpG7UKTQ=
Date:   Tue, 06 Jul 2021 12:20:52 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
 removed from -mm tree
Message-ID: <20210706192052.gfgPDEIii%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: include header for prototype of set_iounmap_nonlazy
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmalloc: include header for prototype of set_iounmap_nonlazy

make W=1 generates the following warning for mm/vmalloc.c

  mm/vmalloc.c:1599:6: warning: no previous prototype for `set_iounmap_nonlazy' [-Wmissing-prototypes]
   void set_iounmap_nonlazy(void)
        ^~~~~~~~~~~~~~~~~~~

This is an arch-generic function only used by x86.  On other arches, it's
dead code.  Include the header with the definition and make it x86-64
specific.

Link: https://lkml.kernel.org/r/20210520084809.8576-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy
+++ a/mm/vmalloc.c
@@ -25,6 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
 #include <linux/xarray.h>
+#include <linux/io.h>
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
@@ -1607,6 +1608,7 @@ static DEFINE_MUTEX(vmap_purge_lock);
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
 
+#ifdef CONFIG_X86_64
 /*
  * called before a call to iounmap() if the caller wants vm_area_struct's
  * immediately freed.
@@ -1615,6 +1617,7 @@ void set_iounmap_nonlazy(void)
 {
 	atomic_long_set(&vmap_lazy_nr, lazy_max_pages()+1);
 }
+#endif /* CONFIG_X86_64 */
 
 /*
  * Purges all lazily-freed vmap areas.
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


