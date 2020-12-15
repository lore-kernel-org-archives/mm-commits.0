Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00294C3526A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F9B22DA9
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgLPAAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgLOXae (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:30:34 -0500
Date:   Tue, 15 Dec 2020 15:18:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074335;
        bh=idpXBYrs2OyHIFO+2g5DEKVikaE4kPSL3l1REwoy8NU=;
        h=From:To:Subject:From;
        b=UIlh9QRT/i38Sh/uM3vv1pUowtsa0sCOjhRFiAvLXHdcIPbbuO4nQOKjLVihn01Ag
         42d43ygboMju/0Ym6J+rSGcJSnttY2VUHA6s7QL3z3e9quUkSXh/xSfFdojAekdkFe
         uOSJ81euIiwJb94OUkCjcAVB559d9vsKI3M6hqqQ=
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, dan.j.williams@intel.com,
        jgross@suse.com, mm-commits@vger.kernel.org, sstabellini@kernel.org
Subject:  [merged]
 xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch removed from -mm
 tree
Message-ID: <20201215231855.cqKCmaV2m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xen/unpopulated-alloc: consolidate pgmap manipulation
has been removed from the -mm tree.  Its filename was
     xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dan.j.williams@intel.com are


