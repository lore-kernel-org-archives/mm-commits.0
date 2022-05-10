Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926D2C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbiEJEWn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiEJEUf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA7F2AED82
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E7BB81B07
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53C7C385C2;
        Tue, 10 May 2022 04:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156129;
        bh=t5M3V2zkkjwtzsL5jx7AcOKhX1J3i/wxjhtBLya2rro=;
        h=Date:To:From:Subject:From;
        b=DLXEBW7c7HjSj/ZTrj3h5BdERld/yrH2r7tfSuvfnVg5DwGlkgbZMCGgC/tTwUOuz
         6S0IHnxQyvwXwioe4s99D22dAmB7bHcLbEm+o66mqC80iJ/XBI7ST2AygfyKfzxHEK
         ZD1DZQe9EIrWHgLQ/LQt9ADqtC5uh6x/H4M8iUmI=
Date:   Mon, 09 May 2022 21:15:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, pcc@google.com,
        ira.weiny@intel.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-highmem-vm_bug_on-if-offset-len-page_size.patch removed from -mm tree
Message-Id: <20220510041528.E53C7C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/highmem: VM_BUG_ON() if offset + len > PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     mm-highmem-vm_bug_on-if-offset-len-page_size.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: VM_BUG_ON() if offset + len > PAGE_SIZE

Add VM_BUG_ON() bounds checking to make sure that, if "offset + len>
PAGE_SIZE", memset() does not corrupt data in adjacent pages.

Mainly to match all the similar functions in highmem.h.

Link: https://lkml.kernel.org/r/20220426193020.8710-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/highmem.h~mm-highmem-vm_bug_on-if-offset-len-page_size
+++ a/include/linux/highmem.h
@@ -358,6 +358,8 @@ static inline void memcpy_to_page(struct
 static inline void memzero_page(struct page *page, size_t offset, size_t len)
 {
 	char *addr = kmap_local_page(page);
+
+	VM_BUG_ON(offset + len > PAGE_SIZE);
 	memset(addr + offset, 0, len);
 	flush_dcache_page(page);
 	kunmap_local(addr);
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


