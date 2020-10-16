Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6E9C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FEBA2063A
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881544;
	bh=A3l7wKMB9w7906QMwUZxR4dDp5KoaCGnpdxjMm0QdD4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gETd6Ryv6AGHhnRfNBP7JHJtwOA/mXiNM0s9pXhdKPxXZ9ZOzP+knD7AB17N3qVFb
	 UNjyAaOnFZCyd/h4/i0GS2OHsqoZWou5Bem/t0BOv9HUiQ8dBdOHCLw2KmiWmSdmSi
	 rc2USh8QsKIWvqSjYpPUF/BBzs3OihSVramSe4eA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408689AbgJPUwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E89B2205CB;
        Fri, 16 Oct 2020 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881543;
        bh=A3l7wKMB9w7906QMwUZxR4dDp5KoaCGnpdxjMm0QdD4=;
        h=Date:From:To:Subject:From;
        b=nOkmOKU9bYv5a72RF5jXz+ARUloejG0hrvn0jClkvw+CfAwS4LwPSHBPP4C0YJ6SL
         hXGCsbC4+jBUDFDBQywgDAPA4W3mOoCnBdYHChSsuzc8BLJISzxdp35auRejhSNT8a
         FB9ICR/QVGrWErchbDroY/9hnUweFroq6ZF1rbpQ=
Date:   Fri, 16 Oct 2020 13:52:22 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged] mm-remove-unused-early_pfn_valid.patch removed
 from -mm tree
Message-ID: <20201016205222.BBK6Z4tvO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove unused early_pfn_valid()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-early_pfn_valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: include/linux/mmzone.h: remove unused early_pfn_valid()

The early_pfn_valid() macro is defined but it is never used.  Remove it.

Link: https://lkml.kernel.org/r/20200923162915.26935-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-unused-early_pfn_valid
+++ a/include/linux/mmzone.h
@@ -1420,7 +1420,6 @@ static inline unsigned long next_present
 #define pfn_to_nid(pfn)		(0)
 #endif
 
-#define early_pfn_valid(pfn)	pfn_valid(pfn)
 void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
@@ -1440,10 +1439,6 @@ struct mminit_pfnnid_cache {
 	int last_nid;
 };
 
-#ifndef early_pfn_valid
-#define early_pfn_valid(pfn)	(1)
-#endif
-
 /*
  * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
  * need to check pfn validity within that MAX_ORDER_NR_PAGES block.
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


