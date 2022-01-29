Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21DEC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353202AbiA2VlI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47818 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352738AbiA2VlH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29E3B827EE
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A97C340E5;
        Sat, 29 Jan 2022 21:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492465;
        bh=qEIr/IPucsKWv1MDGWAxkAVSGCf1AA6mpXIOsHuBXkk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rl+5taXV6QT0gqwmYnP6xujVRE4hEEYrETUDdNOKf5+e/h64I8t8TPev1Eu2SoTzI
         LGKHcgT5Os5tE52Vkz8m0yuf3EajP7dWj7tw9rTsQwKYYADCZu5pdGFbEuf1JW+aNV
         jj6mOnsDMUhEuSv4ghB8uWvLJS/W5aAwcLfrGUN4=
Date:   Sat, 29 Jan 2022 13:41:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 05/12] mm: page->mapping folio->mapping should
 have the same offset
Message-ID: <20220129214104.3DnS3zSIS%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: page->mapping folio->mapping should have the same offset

As with the other members of folio, the offset of page->mapping and
folio->mapping must be the same.  The compile-time check was
inadvertently removed during development.  Add it back.

[willy@infradead.org: changelog redo]
Link: https://lkml.kernel.org/r/20220104011734.21714-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm_types.h~mm-page-mapping-folio-mapping-should-have-the-same-offset
+++ a/include/linux/mm_types.h
@@ -261,6 +261,7 @@ static_assert(sizeof(struct page) == siz
 	static_assert(offsetof(struct page, pg) == offsetof(struct folio, fl))
 FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
+FOLIO_MATCH(mapping, mapping);
 FOLIO_MATCH(compound_head, lru);
 FOLIO_MATCH(index, index);
 FOLIO_MATCH(private, private);
_
