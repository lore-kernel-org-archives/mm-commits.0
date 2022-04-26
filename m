Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242B0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 19:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiDZTid (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 15:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354250AbiDZTib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 15:38:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F6DE005
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 12:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A95161AB3
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 19:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A5C385AA;
        Tue, 26 Apr 2022 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651001721;
        bh=rl+8UEp/LmcgrjqM22BVdnpvPhpzoInOM2vUbW2qcSQ=;
        h=Date:To:From:Subject:From;
        b=z7Yo0xiAt7k7khAsFW/VZWsIYjxU2vAG8xznCVE3yVwS+o2APJjrJJYI5NmXroAn6
         1NdoXPHbXQX6JLCtgEBdqdqWsi02XReqhLyuBlg5Z5xUAQZxfjsFD60TxcewsvREZu
         gq6Zm/baYchH6bcV7tf2XYjA15o8MJnEbYfc9O/A=
Date:   Tue, 26 Apr 2022 12:35:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, pcc@google.com,
        ira.weiny@intel.com, catalin.marinas@arm.com,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-vm_bug_on-if-offset-len-page_size.patch added to -mm tree
Message-Id: <20220426193521.901A5C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: VM_BUG_ON() if offset + len > PAGE_SIZE
has been added to the -mm tree.  Its filename is
     mm-highmem-vm_bug_on-if-offset-len-page_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-vm_bug_on-if-offset-len-page_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-vm_bug_on-if-offset-len-page_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: VM_BUG_ON() if offset + len > PAGE_SIZE

Add VM_BUG_ON() bounds checking to make sure that, if "offset + len>
PAGE_SIZE", memset() does not corrupt data in adjacent pages.

Mainly to match all the similar functions in highmem.h.

Link: https://lkml.kernel.org/r/20220426193020.8710-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
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
@@ -349,6 +349,8 @@ static inline void memcpy_to_page(struct
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

mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch
documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch
documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch
documentation-vm-rework-temporary-virtual-mappings.patch
mm-highmem-vm_bug_on-if-offset-len-page_size.patch

