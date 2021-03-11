Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D87C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F1564F8D
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCKVFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:05:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhCKVEx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:04:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F4964E44;
        Thu, 11 Mar 2021 21:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615496693;
        bh=BnZtHqbYhnjCvyuU65Fe8YZ8d8O9tNVUwsPTETY4qfA=;
        h=Date:From:To:Subject:From;
        b=Len2cMOa19YQ/m9CzR1S2zqt/+Zb0bSG9xMylM3ZFrd929QsiLaTKG+pNtUH7yubg
         V8lv6j+9bAV5GNLlWIZ6VMUrx4SpKbzNO/2A0vS3M7QzozOyDA6ZXCniVhcZavBwdv
         AFILrKH5zWeV93oKhhfhRQpqF+WOgLphXdcx3hEI=
Date:   Thu, 11 Mar 2021 13:04:52 -0800
From:   akpm@linux-foundation.org
To:     chaitanya.kulkarni@wdc.com, clm@fb.com, dsterba@suse.com,
        ira.weiny@intel.com, josef@toxicpanda.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 mm-highmem-convert-memzero_page-to-kmap_local_page.patch added to -mm tree
Message-ID: <20210311210452.aXOnV7oGW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: convert memzero_page() to kmap_local_page()
has been added to the -mm tree.  Its filename is
     mm-highmem-convert-memzero_page-to-kmap_local_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-convert-memzero_page-to-kmap_local_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-convert-memzero_page-to-kmap_local_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-highmem-convert-memzero_page-to-kmap_local_page.patch
btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern.patch
mm-highmem-remove-deprecated-kmap_atomic.patch

