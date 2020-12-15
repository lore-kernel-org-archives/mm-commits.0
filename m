Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B414FC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6625322473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgLODHp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgLODHi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:38 -0500
Date:   Mon, 14 Dec 2020 19:07:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001642;
        bh=ZmTu6F9g9m50+q6fO5uy9AEIXIVh3H+jUaoywHDzpk4=;
        h=From:To:Subject:In-Reply-To:From;
        b=GCaK5LLk53mo29ieHUbhPa22znHiEcrEvwHFJOCx8i++Vi/bmCM/OiV1+xLsQtu0z
         40n4p6CzQh7Cl9NN0rmwQag8gDqU8wZxnVMb3Ohk7mWKK6oceQQgevEJHByuhnpRJw
         4+aVoihuvY7saBZayrp2bQZPU745/nAqLXR/VX+I=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        dan.j.williams@intel.com, jgross@suse.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sstabellini@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 073/200] xen/unpopulated-alloc: consolidate pgmap
 manipulation
Message-ID: <20201215030721.mb4trkGgL%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Subject: xen/unpopulated-alloc: consolidate pgmap manipulation

Cleanup fill_list() to keep all the pgmap manipulations in a single
location of the function.  Update the exit unwind path accordingly.

Link: http://lore.kernel.org/r/6186fa28-d123-12db-6171-a75cb6e615a5@oracle.com
Link: https://lkml.kernel.org/r/160272253442.3136502.16683842453317773487.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/unpopulated-alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/xen/unpopulated-alloc.c~xen-unpopulated-alloc-consolidate-pgmap-manipulation
+++ a/drivers/xen/unpopulated-alloc.c
@@ -27,11 +27,6 @@ static int fill_list(unsigned int nr_pag
 	if (!res)
 		return -ENOMEM;
 
-	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
-	if (!pgmap)
-		goto err_pgmap;
-
-	pgmap->type = MEMORY_DEVICE_GENERIC;
 	res->name = "Xen scratch";
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
@@ -43,6 +38,11 @@ static int fill_list(unsigned int nr_pag
 		goto err_resource;
 	}
 
+	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
+	if (!pgmap)
+		goto err_pgmap;
+
+	pgmap->type = MEMORY_DEVICE_GENERIC;
 	pgmap->range = (struct range) {
 		.start = res->start,
 		.end = res->end,
@@ -92,10 +92,10 @@ static int fill_list(unsigned int nr_pag
 	return 0;
 
 err_memremap:
-	release_resource(res);
-err_resource:
 	kfree(pgmap);
 err_pgmap:
+	release_resource(res);
+err_resource:
 	kfree(res);
 	return ret;
 }
_
