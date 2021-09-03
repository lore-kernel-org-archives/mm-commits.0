Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F63C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B076112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbhICU76 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhICU7x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E2F3610FD;
        Fri,  3 Sep 2021 20:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702732;
        bh=crmpPIAcWZABPmpDg/WvNAD2RClVIaRYcVVQPOkBUe4=;
        h=Date:From:To:Subject:From;
        b=CSkeIupWslJQEpBBj8RPCmjIv92X0rftJB7sAvdqPI6Lt04rftw/ubvQ8Sp350IfB
         ZCfJUBUV9UVJBZaPnfrX7upJ/wDVD6YGskcp1BQmewdubnfHddFGI6zxtNEl0UtevM
         5xUMLE9wbX28BfHzHxGUuY7aRzkvp0++YBu+tGuI=
Date:   Fri, 03 Sep 2021 13:58:52 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, k-hagio-ab@nec.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, rui.xiang@huawei.com, wangwensheng4@huawei.com
Subject:  [merged] mm-sparse-set-section_nid_shift-to-6.patch
 removed from -mm tree
Message-ID: <20210903205852.pvSju4Vd6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: set SECTION_NID_SHIFT to 6
has been removed from the -mm tree.  Its filename was
     mm-sparse-set-section_nid_shift-to-6.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/sparse: set SECTION_NID_SHIFT to 6

Currently SECTION_NID_SHIFT is set to 3, which is incorrect because bit 3
and 4 can be overlapped by sub-field for early NID, and can be
unexpectedly set on NUMA systems.  There are a few non-critical issues
related to this:

- Having SECTION_TAINT_ZONE_DEVICE set for wrong sections forces
  pfn_to_online_page() through the slow path, but doesn't actually break
  the kernel.

- A kdump generation tool like makedumpfile uses this field to calculate
  the physical address to read.  So wrong bits can make the tool access to
  wrong address and fail to create kdump.  This can be avoided by the
  tool, so it's not critical.

To fix it, set SECTION_NID_SHIFT to 6 which is the minimum number of
available bits of section flag field.

Link: https://lkml.kernel.org/r/20210707045548.810271-1-naoya.horiguchi@linux.dev
Fixes: 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Kazuhito Hagio <k-hagio-ab@nec.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wang Wensheng <wangwensheng4@huawei.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Kazu <k-hagio-ab@nec.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-sparse-set-section_nid_shift-to-6
+++ a/include/linux/mmzone.h
@@ -1364,7 +1364,7 @@ extern size_t mem_section_usage_size(voi
 #define SECTION_TAINT_ZONE_DEVICE	(1UL<<4)
 #define SECTION_MAP_LAST_BIT		(1UL<<5)
 #define SECTION_MAP_MASK		(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT		3
+#define SECTION_NID_SHIFT		6
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


