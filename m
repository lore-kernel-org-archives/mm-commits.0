Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D739EC2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDEE22D49
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgLPAAI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729917AbgLOX0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:42 -0500
Date:   Tue, 15 Dec 2020 15:16:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074215;
        bh=1U0JjFb8glJQVFLVV4l+uj+v5o+JqkQmNMNFN+p3c4Q=;
        h=From:To:Subject:From;
        b=cS3Q47m5Xk7iG+UynvBpXNKgo0qx7nWGviOFNYFWUoauTIvJpy0X8tX1TaL31aXig
         re9XynOxpjlx5ML6AWQvrh4bJXAY5nKn9H2NbINHdCbFMpx8idKVCO3ecEOClJ95sk
         98+awE44v8cKpVyfS6ggvJEfPnSfHTEnXcanH+30=
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [merged] device-dax-kmem-use-struct_size.patch removed
 from -mm tree
Message-ID: <20201215231655.RMSBuP6Zw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax/kmem: use struct_size()
has been removed from the -mm tree.  Its filename was
     device-dax-kmem-use-struct_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax/kmem: use struct_size()

Linus notes the kernel has had a nice helper for the 'size of struct with
variable array member at the end' operation for a couple years now, use
it.

Link: http://lore.kernel.org/r/CAHk-=wgNTLbvAD8mNTvh+GQyapNWeX20PXhU_+frqEvVq4298w@mail.gmail.com
Link: https://lkml.kernel.org/r/160288261564.3242821.6055291930923876456.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/kmem.c~device-dax-kmem-use-struct_size
+++ a/drivers/dax/kmem.c
@@ -61,7 +61,7 @@ static int dev_dax_kmem_probe(struct dev
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(*data) + sizeof(struct resource *) * dev_dax->nr_range, GFP_KERNEL);
+	data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


