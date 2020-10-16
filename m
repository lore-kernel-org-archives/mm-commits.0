Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C1EC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A702087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817813;
	bh=MOwBn7uyTm9K7UmqBlaGtuzE+7F7Cw2yfpiXSrjcnTA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Nex1mBhxLsxn1fhG+fqVjO3D2EziP5A8mjOw6xjINK+/ogaCsgGgVLrUyvO5Iofx2
	 uDi58C2gSD2IneSL7aTvAERRJy1tonddV6C2A57mxLQdv/k23C/BGbkCz2tTRACs1h
	 4jy3OFWPgf57ynKttUgjjpEJd4OyJxBXblwTD2SE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbgJPDKN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgJPDKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D94020789;
        Fri, 16 Oct 2020 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817812;
        bh=MOwBn7uyTm9K7UmqBlaGtuzE+7F7Cw2yfpiXSrjcnTA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DjNU/u/ArALXh/oF7GW0m244weqiNShBxz6/NeOywVgsGdgMmdPpSSOHmt5pg97b1
         bzp62i5ltz2IIXrkvgjLe9RTlsASJEopk/DVCyr6iw0e5s7aeN1rt6Ego5TbFQpasu
         QI4yyKV5ZNRIZyomEJy9NSBDytpNkK0sthjhIsOE=
Date:   Thu, 15 Oct 2020 20:10:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 093/156] include/linux/mmzone.h: remove unused
 early_pfn_valid()
Message-ID: <20201016031011.n3NLUlK2v%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
