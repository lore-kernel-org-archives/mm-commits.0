Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F12C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D41A2250F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgLODFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbgLODFY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:24 -0500
Date:   Mon, 14 Dec 2020 19:04:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001484;
        bh=oon/jmCvhSG3h4Spqd5o3pYPf5Atg6qhH/qQLFeGy+I=;
        h=From:To:Subject:In-Reply-To:From;
        b=cQShu/wN+fDKwR56RAJFOgHdGu5v5R5iaBB7olQRyIYqAz500QmeNQPJE4FLuyne3
         +opi4ypfeTDP9K5cudL3lYF7KvQCL5opH5gemPnTRRM3fVEB4XcgL/xjG0uv52Tan+
         j4rgEk2KHio9aSwQwytFGziHQsKLWsqQtVxGfPuI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 025/200] device-dax/kmem: use struct_size()
Message-ID: <20201215030443.71rF8LQE_%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
