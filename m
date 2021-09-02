Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D9FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3232A60F21
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347621AbhIBV6N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347609AbhIBV6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9EA4603E9;
        Thu,  2 Sep 2021 21:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619834;
        bh=e1pbamBxblaB/j670DJmQy2BNzYLra9ZE/MrRocxIL8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iLAIo0vJ3M9kyrMFUW6DSvUuJOsCrR3VBlo+PGITcQ4WEbDbQYpVikN9mbVGpx1Vj
         l+TMi4rHH3cgqxI9BBoAAZjy/L+DjEiQ+hOqN4PKpFMVbKVXcJHMknRZk4bke65OT6
         g1e5MUsbNn4MxXSvFGcu9No+o+zZa/DGRCqiU6fM=
Date:   Thu, 02 Sep 2021 14:57:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mark.rutland@arm.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 136/212] mm/sparse: clarify pgdat_to_phys
Message-ID: <20210902215713.SjcwYIO6n%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/sparse: clarify pgdat_to_phys

Clarify pgdat_to_phys() by testing if
pgdat == &contig_page_data when CONFIG_NUMA=n.

We only expect contig_page_data in such case, so we
use &contig_page_data directly instead of pgdat.

No functional change intended when CONFIG_BUG_VM=n.

Comment from Mark [1]:
"
... and I reckon it'd be clearer and more robust to define
pgdat_to_phys() in the same ifdefs as contig_page_data so
that these, stay in-sync. e.g. have:

| #ifdef CONFIG_NUMA
| #define pgdat_to_phys(x)	virt_to_phys(x)
| #else /* CONFIG_NUMA */
|
| extern struct pglist_data contig_page_data;
| ...
| #define pgdat_to_phys(x)	__pa_symbol(&contig_page_data)
|
| #endif /* CONIFIG_NUMA */
"

[1] https://lore.kernel.org/linux-arm-kernel/20210615131902.GB47121@C02TD0UTHF1T.local/

Link: https://lkml.kernel.org/r/20210723123342.26406-1-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-clarify-pgdat_to_phys
+++ a/mm/sparse.c
@@ -321,7 +321,8 @@ size_t mem_section_usage_size(void)
 static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
 {
 #ifndef CONFIG_NUMA
-	return __pa_symbol(pgdat);
+	VM_BUG_ON(pgdat != &contig_page_data);
+	return __pa_symbol(&contig_page_data);
 #else
 	return __pa(pgdat);
 #endif
_
