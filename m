Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A10C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5298964DE5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCOXS1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229897AbhCOXST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C82A364F5F;
        Mon, 15 Mar 2021 23:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615850299;
        bh=ONNAzXoBP1H98zamtNsGmrHHrVENhNeb7FNfvK27tWY=;
        h=Date:From:To:Subject:From;
        b=acIzlO6QdX1qLuFTFSrBTONZj28kgNxVoVJuXrjWCunxFFdGUanyVN38N+5uH3p+p
         BzG5NmjafWntgLx0ucP2xkq2YIXNTEUX/T4gXx1LHy53m5AooN4bemkzGxSAq2zUHJ
         00TTpe7pNlHaWzNBelOqS5Cs8NUEHrXcbsJsXP8s=
Date:   Mon, 15 Mar 2021 16:18:18 -0700
From:   akpm@linux-foundation.org
To:     chaitanya.kulkarni@wdc.com, clm@fb.com, dsterba@suse.com,
        ira.weiny@intel.com, josef@toxicpanda.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [to-be-updated]
 mm-highmem-convert-memzero_page-to-kmap_local_page.patch removed from -mm
 tree
Message-ID: <20210315231818.p7YfLhnW8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: convert memzero_page() to kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-highmem-convert-memzero_page-to-kmap_local_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem: convert memzero_page() to kmap_local_page()

The memset() does not need to be performed atomically.  Use
kmap_local_page() which will improved performance for this call.

Link: https://lkml.kernel.org/r/20210309212137.2610186-3-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-convert-memzero_page-to-kmap_local_page
+++ a/include/linux/highmem.h
@@ -334,9 +334,9 @@ static inline void memcpy_to_page(struct
 
 static inline void memzero_page(struct page *page, size_t offset, size_t len)
 {
-	char *addr = kmap_atomic(page);
+	char *addr = kmap_local_page(page);
 	memset(addr + offset, 0, len);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
_

Patches currently in -mm which might be from ira.weiny@intel.com are

iov_iter-lift-memzero_page-to-highmemh.patch
btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern.patch
mm-highmem-remove-deprecated-kmap_atomic.patch

