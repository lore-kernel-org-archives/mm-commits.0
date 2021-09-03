Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAEBC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215646113E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhICVAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350017AbhICU75 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DDD661107;
        Fri,  3 Sep 2021 20:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702737;
        bh=8FdjSSZSKiHbl52pIbdmdd8uHjQKgfBJS10ZWzN5moU=;
        h=Date:From:To:Subject:From;
        b=jB+pCtMgLLt0pXQ8mdhsWRMcjgLJInF+OtLwh9AQQDCpDx5rGphi6Mqr622GdWFb/
         up6O6ZjGmbkfM+ClYsgoXuAfk7K7wBDPaVUTcHo+g3nJe0s37bEFIF7alBrrZ+xtMd
         IvOSS3QXIBJccq9rF9RwtW6upAGH4SMu/LuQVh/4=
Date:   Fri, 03 Sep 2021 13:58:57 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mark.rutland@arm.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged] mm-sparse-clarify-pgdat_to_phys.patch removed
 from -mm tree
Message-ID: <20210903205857.cUkVXeIUW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: clarify pgdat_to_phys
has been removed from the -mm tree.  Its filename was
     mm-sparse-clarify-pgdat_to_phys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from miles.chen@mediatek.com are


