Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5A9C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 078EA207DA
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450332;
	bh=fLCbFJATXGKX2PK6StlhfF3NRh3AY1TfApR4t0KzQ+o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rAn7tOuDE5TkG12l3Opl5sTz1GPCOGqHvgxO5fPqgBfk1sTT5fDUjdSf1LmWRTGpm
	 QqNS55h+YwvtoNHOLeSYnm5+dq0jj6qqy1VtuucTxVcoswgUMsQ3dYtLjJ3QlfiFqB
	 F8lvOOGVIXxA6zWeIT/VGZABhIiRxXNCKtDNG34I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgHOAML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOAML (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:12:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A9520781;
        Sat, 15 Aug 2020 00:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450330;
        bh=fLCbFJATXGKX2PK6StlhfF3NRh3AY1TfApR4t0KzQ+o=;
        h=Date:From:To:Subject:From;
        b=iFMHnmGN9JVUIw+4GnZktXd5laM0S6YutmN9NmJtzpWWNXJ1obsFqBy2ZozDl8KM4
         YzzL4ACNxLSW4wVgy/ybMmmpP7kObIm1V5CBaUAdYkG/j81NeGepDzcRx47tJUmpeJ
         pouK5r7kqIHUY2GdS93A2t0tNNi6T9Bu93mzaBTA=
Date:   Fri, 14 Aug 2020 17:12:10 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [folded-merged]
 mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch removed from -mm tree
Message-ID: <20200815001210.qvBZQTLc2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-hpage_nr_pages-with-thp_nr_pages-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch

This patch was dropped because it was folded into mm-replace-hpage_nr_pages-with-thp_nr_pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-hpage_nr_pages-with-thp_nr_pages-fix

fix mm/migrate.c

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-replace-hpage_nr_pages-with-thp_nr_pages-fix
+++ a/mm/migrate.c
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			nr_subpages = hpage_nr_pages(page);
+			nr_subpages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

