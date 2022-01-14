Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1090AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiANWEe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57902 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00ACBB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19962C36AEC;
        Fri, 14 Jan 2022 22:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197870;
        bh=8nC/w8mWUpbJk/PkjV0z0DwCUUddZmUk1HY3vqhKk5E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=N1NINCSpbM0rBaQ0WEgO2zNyzJKP34ACLR6XPXK9voptACX5ewoNI3XDGboZYMDo6
         StTDD66j/4BZea93Ws3aq4HNn2ENmgazdYEwcYXsMl5DwlaLTBfInUhQCl5OtxVwfj
         +fDtuKC2lznpk65tjk66A4yr4Ge3EigJs3NfSNR0=
Date:   Fri, 14 Jan 2022 14:04:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 030/146] device-dax: use struct_size()
Message-ID: <20220114220429.X7CsCUn1o%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: use struct_size()

Use the struct_size() helper for the size of a struct with variable array
member at the end, rather than manually calculating it.

Link: https://lkml.kernel.org/r/20211202204422.26777-7-joao.m.martins@oracle.com
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dax/device.c~device-dax-use-struct_size
+++ a/drivers/dax/device.c
@@ -404,8 +404,9 @@ int dev_dax_probe(struct dev_dax *dev_da
 		return -EINVAL;
 
 	if (!pgmap) {
-		pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
-				* (dev_dax->nr_range - 1), GFP_KERNEL);
+		pgmap = devm_kzalloc(dev,
+                       struct_size(pgmap, ranges, dev_dax->nr_range - 1),
+                       GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
 		pgmap->nr_range = dev_dax->nr_range;
_
