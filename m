Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6190DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiEJEWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415501C906
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2116B81B0D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A708FC385C2;
        Tue, 10 May 2022 04:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156136;
        bh=EosM0vgvosGQ1Y/B42Ii1x1O66w1aLnqlO5+vFyHbv4=;
        h=Date:To:From:Subject:From;
        b=eyqDa+5HmnjbThVSL4AiAtO0y/AN38McpFTV7eibSAJ1JIlFYffdc9aCzg1cacCWQ
         YtlZwlti2c/B8DW9QFBAVtOINpVdFMJhUswrFfloHmgiCJkxD+oHdxqrzOoX5EFNRI
         R9kbaCMTGr1nuLZIxyCFyltPdKOPPJxDhepzqpus=
Date:   Mon, 09 May 2022 21:15:36 -0700
To:     mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        anshuman.khandual@arm.com, liusongtang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch removed from -mm tree
Message-Id: <20220510041536.A708FC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: use pgprot_val to get value of pgprot
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: liusongtang <liusongtang@huawei.com>
Subject: mm/memory_hotplug: use pgprot_val to get value of pgprot

pgprot.pgprot is non-portable code.  It should be replaced by portable
macro pgprot_val.

Link: https://lkml.kernel.org/r/20220426071302.220646-1-liusongtang@huawei.com
Signed-off-by: liusongtang <liusongtang@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot
+++ a/mm/memory_hotplug.c
@@ -303,7 +303,7 @@ int __ref __add_pages(int nid, unsigned
 	int err;
 	struct vmem_altmap *altmap = params->altmap;
 
-	if (WARN_ON_ONCE(!params->pgprot.pgprot))
+	if (WARN_ON_ONCE(!pgprot_val(params->pgprot)))
 		return -EINVAL;
 
 	VM_BUG_ON(!mhp_range_allowed(PFN_PHYS(pfn), nr_pages * PAGE_SIZE, false));
_

Patches currently in -mm which might be from liusongtang@huawei.com are


