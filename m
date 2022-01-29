Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2C7C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353195AbiA2VlG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352738AbiA2VlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C83C061714
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 13:41:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9EE9B827EE
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A77C340EF;
        Sat, 29 Jan 2022 21:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492462;
        bh=zSDHBCH3P+O3RfADVkHf3HrCwZThcIKMpyMGSUaHFTE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ajVnHrAzTfRGvISu0hsTXjwtD20AhQKhFtw3ozkj2Fj7RZwLUUkg9Z8WR185+tsXk
         5xMEstpmxslkuudso4Om7RkMkIT+hRDjmlYD55UxCGXEXZS0KijV4vWFoNrpN5wsxr
         NEpY6bt29GYQQFsZRgZtKDjkPLAHXCusfGBhAs0I=
Date:   Sat, 29 Jan 2022 13:41:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        jane.chu@oracle.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 04/12] memory-failure: fetch compound_head after
 pgmap_pfn_valid()
Message-ID: <20220129214101.N9rZeRVSg%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
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
