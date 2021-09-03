Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF43C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F3E6113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhICU7o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhICU7o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 828686112E;
        Fri,  3 Sep 2021 20:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702723;
        bh=UV/5IeMloP8qn3sO+3NHW2UDbYCU5JCcYnzDI8HdT5s=;
        h=Date:From:To:Subject:From;
        b=iysS4SeP2GuzpDw79u9xocUdZs1SSwHDCpXFqth84sWaRp79C8aQ9ssLCy9tPQRhi
         aRLf5TCDWDQ7BdS1O18kMFG+iDASLrLB217SYlx+EYvr1E10ejWPl6QadzOKCCm5P3
         AhckSQ4myNse00LEUdPnowYa/YwREckdXm+kw4v0=
Date:   Fri, 03 Sep 2021 13:58:43 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  [merged]
 mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch
 removed from -mm tree
Message-ID: <20210903205843.GU8A2zsgW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem_info.c: mark __init on register_page_bootmem_info_section
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/bootmem_info.c: mark __init on register_page_bootmem_info_section

register_page_bootmem_info_section() is only called from __init functions,
so mark it __init as well.

Link: https://lkml.kernel.org/r/20210817042221.77172-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section
+++ a/mm/bootmem_info.c
@@ -39,7 +39,7 @@ void put_page_bootmem(struct page *page)
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void register_page_bootmem_info_section(unsigned long start_pfn)
+static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
 	struct mem_section *ms;
@@ -74,7 +74,7 @@ static void register_page_bootmem_info_s
 
 }
 #else /* CONFIG_SPARSEMEM_VMEMMAP */
-static void register_page_bootmem_info_section(unsigned long start_pfn)
+static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
 	struct mem_section *ms;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-remove-redundant-compound_head-calling.patch
mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch

