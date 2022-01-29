Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C52C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 02:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344877AbiA2COY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jan 2022 21:14:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiA2COX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jan 2022 21:14:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA1DB82763
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 02:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBDCC340E7;
        Sat, 29 Jan 2022 02:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643422461;
        bh=zSDHBCH3P+O3RfADVkHf3HrCwZThcIKMpyMGSUaHFTE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YFq1zRnBSOi8iwOaTSyjn5rD2tAyTEYdtTwEnzTspJ19oi4olrLgiiDocO5nWsrhH
         v0JaI4R4QK5Flt6XoGX5fHNAmAKvZ+ZZAdAw5JHO3CJOafKPJE6QmLaVDsYiK7rGFX
         4mZzhXO+eeZw+MlYQzAw0XQSAXJw9wflOFjR4MqU=
Date:   Fri, 28 Jan 2022 18:14:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        jane.chu@oracle.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 3/7] memory-failure: fetch compound_head after
 pgmap_pfn_valid()
Message-ID: <20220129021420.PgBIZm-q9%akpm@linux-foundation.org>
In-Reply-To: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: memory-failure: fetch compound_head after pgmap_pfn_valid()

memory_failure_dev_pagemap() at the moment assumes base pages (e.g. 
dax_lock_page()).  For devmap with compound pages fetch the compound_head
in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Without this fix memory-failure handling (i.e.  MCEs on pmem) with
device-dax configured namespaces will regress (and crash).  

Link: https://lkml.kernel.org/r/20211202204422.26777-2-joao.m.martins@oracle.com
Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory-failure.c~memory-failure-fetch-compound_head-after-pgmap_pfn_valid
+++ a/mm/memory-failure.c
@@ -1596,6 +1596,12 @@ static int memory_failure_dev_pagemap(un
 	}
 
 	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
+	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
 	 * lock_page(), but dax pages do not use the page lock. This
_
