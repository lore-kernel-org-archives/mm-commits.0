Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D63C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 00:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113FD2083B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 00:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602806585;
	bh=u/PeVZ7ll2BFWkpd95NA6dXzpqOub3PKyfNTaS2qdwk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WK/aohGs97mzuoM9WIRG/c3Pk7m+yBJ60c3CIBSvyMk5Bg3vkldXL3uvzuNMshPwZ
	 8BBRrDstLxY0+ZRVgoCa3BCVhGGnPEzHsdbVGbwGmsierW7AETaTSD7KPNQcMMaLzE
	 n49Hy4RojZaAxwjUpsdq249SabI+Op60cVyKndxg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgJPADE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 20:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgJPADE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 20:03:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F424208C7;
        Fri, 16 Oct 2020 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602806583;
        bh=u/PeVZ7ll2BFWkpd95NA6dXzpqOub3PKyfNTaS2qdwk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tQilElCpf850BCQLqmJ6z6jA6ezecnwjws5skWjWovtySUCV3rML26hsVpPxQR4lP
         26Fs9oudMPlKOTcM+9PM+uR1NcdEDtVRadQ0ha1IJM4imqReeibHMj4nXhm4nnviVN
         1zKJMfdkiIRjNwgC/pL2cgJUjFTaJzJIRnI2qnHQ=
Date:   Thu, 15 Oct 2020 17:03:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     boris.ostrovsky@oracle.com, dan.j.williams@intel.com,
        jgross@suse.com, mm-commits@vger.kernel.org, sstabellini@kernel.org
Subject:  +
 xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch added to -mm
 tree
Message-ID: <20201016000302.EM97W-_LP%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xen/unpopulated-alloc: consolidate pgmap manipulation
has been added to the -mm tree.  Its filename is
     xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -91,10 +91,10 @@ static int fill_list(unsigned int nr_pag
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

device-dax-kmem-fix-resource-release.patch
xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch

