Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B208CC4338F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E55D60E98
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhGWTUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGWTUW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 15:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB0D60E97;
        Fri, 23 Jul 2021 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627070455;
        bh=AIo6mcLvXpJfAsFayeitUc5/gMvr4lP2BcN4eW66olw=;
        h=Date:From:To:Subject:From;
        b=iQVNIqa3/w3FybVYt2PdRcYVe56sEQba49awS2d+viOcWXMnAbumS9G2U0Y72ZISI
         Xwi3eoySEjEGMsLLhkED25ON5NwXQItFKr1PuWvCJt60aBHsPgRJNa47JLG88akyG3
         p/xnQnllyepDxBsumKSp5Nax2GX6OVMntjJWQDi4=
Date:   Fri, 23 Jul 2021 13:00:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mark.rutland@arm.com,
        david@redhat.com, miles.chen@mediatek.com
Subject:  + mm-sparse-clarify-pgdat_to_phys.patch added to -mm tree
Message-ID: <20210723200054.N4inK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: clarify pgdat_to_phys
has been added to the -mm tree.  Its filename is
     mm-sparse-clarify-pgdat_to_phys.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-clarify-pgdat_to_phys.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-clarify-pgdat_to_phys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Mike Rapoport <rppt@kernel.org>
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

Patches currently in -mm which might be from miles.chen@mediatek.com are

mm-sparse-clarify-pgdat_to_phys.patch

