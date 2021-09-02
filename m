Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A15C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BDAD60FA0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347809AbhIBV57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347918AbhIBV5z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F3760E8B;
        Thu,  2 Sep 2021 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619816;
        bh=a6P5GVXOvGmpUjHKBQwZ6A634lHAklVt1KIr18dPOz4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nQqA5sWQ7KMWgwX8Q/WLcpObnwD7uBhpR8OM5MZldr792CPK2qCbeW+yaRpYnwECm
         kcfke3OKJ86/4PID30E0Hbndr6Vqix7OZQ5sogca05933H+Vwd6tGUo2Tm1m6imddZ
         Glsgwy2PKH0CHRMPn39FuW6QajCncWcIYd8gk4OE=
Date:   Thu, 02 Sep 2021 14:56:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 130/212] mm/bootmem_info.c: mark __init on
 register_page_bootmem_info_section
Message-ID: <20210902215655.qLveW816V%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
