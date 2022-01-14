Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE7FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiANWE2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46174 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiANWE2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C7361FFA
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87504C36AE5;
        Fri, 14 Jan 2022 22:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197867;
        bh=nGm195y+2axTOVVS2KA7kxHcTPl6Wpu5+3z5X6bVCaI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aO03WhQ0D9GKW4QeShEdrx2K7hyzRQXInYZ08vceFlNtJvSKx7V/RUfTu78bpUCU+
         X0M1b5v3nHeF9FkmP91i9FqYBxBfPGoTOOZdgp5zPjCTd3DbwvMdKz6ylih8uzt4Bs
         kluxQEHsBuOr8rM50M2ZnF1kZRz1m32XbIiJOPVg=
Date:   Fri, 14 Jan 2022 14:04:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 029/146] device-dax: use ALIGN() for determining
 pgoff
Message-ID: <20220114220426.P_C9Y0zWa%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: use ALIGN() for determining pgoff

Rather than calculating @pgoff manually, switch to ALIGN() instead.

Link: https://lkml.kernel.org/r/20211202204422.26777-6-joao.m.martins@oracle.com
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

 drivers/dax/device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dax/device.c~device-dax-use-align-for-determining-pgoff
+++ a/drivers/dax/device.c
@@ -234,8 +234,8 @@ static vm_fault_t dev_dax_huge_fault(str
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma, vmf->address
-				& ~(fault_size - 1));
+		pgoff = linear_page_index(vmf->vma,
+				ALIGN(vmf->address, fault_size));
 		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
 			struct page *page;
 
_
