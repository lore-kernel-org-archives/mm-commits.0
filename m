Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2793C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJCVPs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiJCVOI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891B9AE6F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E22261207
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63772C433C1;
        Mon,  3 Oct 2022 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831378;
        bh=H/6v60DCWcMgtjCdRa4aW6GQfjDZRuSt8kfYabxdlsI=;
        h=Date:To:From:Subject:From;
        b=lLSEChbkbwlXUoXj1VvWWrfTf9SX0EEcuDNvR+1ptelaHsC9ZHDLKZQiKPa97WFeb
         li4ReVeoMw6n1yBDkHdlWRKlkSgWyc385BF4lv+EuXue7ZsJaWystMRXdoK8CaUKZR
         8WxKnsv+kxYdnmCajQmVsKpRn6QVGN8DLx7brJeo=
Date:   Mon, 03 Oct 2022 14:09:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-boot_nodestats-static.patch removed from -mm tree
Message-Id: <20221003210938.63772C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: make boot_nodestats static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-boot_nodestats-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: make boot_nodestats static
Date: Fri, 16 Sep 2022 15:22:52 +0800

It's only used in mm/page_alloc.c now.  Make it static.

Link: https://lkml.kernel.org/r/20220916072257.9639-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 --
 mm/page_alloc.c |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/mm/internal.h~mm-page_alloc-make-boot_nodestats-static
+++ a/mm/internal.h
@@ -836,8 +836,6 @@ int migrate_device_coherent_page(struct
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
 
-DECLARE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
-
 extern bool mirrored_kernelcore;
 
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
--- a/mm/page_alloc.c~mm-page_alloc-make-boot_nodestats-static
+++ a/mm/page_alloc.c
@@ -6579,7 +6579,7 @@ static void per_cpu_pages_init(struct pe
 #define BOOT_PAGESET_BATCH	1
 static DEFINE_PER_CPU(struct per_cpu_pages, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_zonestat, boot_zonestats);
-DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
+static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
 static void __build_all_zonelists(void *data)
 {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


