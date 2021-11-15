Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8F5C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5777633AE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbhKORtS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:49:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237134AbhKORrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9979963312;
        Mon, 15 Nov 2021 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997373;
        bh=AZmuvgcWCGjTPv4Zkk3isWJx4/chpMAGduFtEUrA6/I=;
        h=Date:From:To:Subject:From;
        b=Ugmzxozf9DPC/v5+IaEzAgN3w1zTXC23ZnABT/x3iCioVRSE3BBqGCeC1FLdoPcvE
         tYp0tzZEEsIGPovMgyXcGdNkTVPqy27chPWfJ6SiOSQR+tsUJowZKsW8VApgFkhMim
         tkpahGA+yF/Cdk9hFcKJUpC/jgrXocLwHRtTkkVk=
Date:   Mon, 15 Nov 2021 09:29:33 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-migrate-simplify-the-file-backed-pages-validation-when?=
 =?US-ASCII?Q?-migrating-its-mapping.patch?= removed from -mm tree
Message-ID: <20211115172933.rXPQLKGeW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: simplify the file-backed pages validation when migrating its mapping
has been removed from the -mm tree.  Its filename was
     mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: simplify the file-backed pages validation when migrating its mapping

There is no need to validate the file-backed page's refcount before trying
to freeze the page's expected refcount, instead we can rely on the
folio_ref_freeze() to validate if the page has the expected refcount
before migrating its mapping.

Moreover we are always under the page lock when migrating the page
mapping, which means nowhere else can remove it from the page cache, so we
can remove the xas_load() validation under the i_pages lock.

Link: https://lkml.kernel.org/r/cover.1629447552.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/df4c129fd8e86a95dbc55f4663d77441cc0d3bd1.1629447552.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping
+++ a/mm/migrate.c
@@ -404,12 +404,6 @@ int folio_migrate_mapping(struct address
 	newzone = folio_zone(newfolio);
 
 	xas_lock_irq(&xas);
-	if (folio_ref_count(folio) != expected_count ||
-	    xas_load(&xas) != folio) {
-		xas_unlock_irq(&xas);
-		return -EAGAIN;
-	}
-
 	if (!folio_ref_freeze(folio, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


