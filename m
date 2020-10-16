Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28F5C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C1220897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816429;
	bh=MOwBn7uyTm9K7UmqBlaGtuzE+7F7Cw2yfpiXSrjcnTA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OnfU51ooJlx8O8CWbQ6w0q6lf3oeIbFTXNwzjFU9ABMNsJVEiX3F0GF/2sNnlEeKI
	 j+EYZnCBKBE8XEM0gwKUx0s5dWpDSl+qpcRgXYgf+4HQmF8WsFiXhqA1CcuS5s2sbF
	 ZX8ayU3RBGRfJQZxMDGqD2doLmtBRPO5WBXgQoSs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404340AbgJPCrJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404339AbgJPCrJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A6E2087D;
        Fri, 16 Oct 2020 02:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816427;
        bh=MOwBn7uyTm9K7UmqBlaGtuzE+7F7Cw2yfpiXSrjcnTA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2udBzwR8peHlvt5EV06Kj1QKxpdCUcMwjbzgAzgtWVd8HLo/2D+DIWSpZG876rLww
         YvyB1T1pMFRi5ASv+rNgHjOxV4t5zLl3UgvrqTPr2jgkySQeMi/iR49SUc5zjRLKjy
         R8Gu+0QZmcaOrRftMpZqWDCPqk4MLc2LUFTlZQ0g=
Date:   Thu, 15 Oct 2020 19:47:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 093/156] include/linux/mmzone.h: remove unused
 early_pfn_valid()
Message-ID: <20201016024706.GTTxN-Clb%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
