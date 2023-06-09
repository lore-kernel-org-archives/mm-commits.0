Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0568BC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjFIX2l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjFIX1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306813ABD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E7963E52
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22870C433EF;
        Fri,  9 Jun 2023 23:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353262;
        bh=a739mH+CeD/B7l48UvBxtFbnSpK96Z7384TjJ4m52YM=;
        h=Date:To:From:Subject:From;
        b=JeTtawQlnXdyXv0r1+6UVlsLL67cFbVH0ue3rJaMpybKP4q8A5OVdI1Eics7RZyN2
         ORrTDF6I5J03hNOMnZEV9nseBoG4gSxVaN9QeZb6qrzfdQKJ0O/Np+bQyTcUuKrTsO
         OKfAJHktVM5i0Tr1Qx43O7tFCUVx4wZkpqXeYZ48=
Date:   Fri, 09 Jun 2023 16:27:41 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch removed from -mm tree
Message-Id: <20230609232742.22870C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: remove alloc_contig_dump_pages() stub
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6213,8 +6213,6 @@ out:
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
-#if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
 {
@@ -6228,11 +6226,6 @@ static void alloc_contig_dump_pages(stru
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


