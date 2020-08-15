Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B4BC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D17A20639
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529555;
	bh=++vL9+ojwEXDICxj/fe7a4hZzf7XNJzmA7W3ygUedH8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vQobe7lpmKNLiscFvtXD1pPjnOAhZfqZzGBMKaqhDvmFJkjyq8imMxgNDSVDecRAP
	 vp2iXOHyTa/G5iN5zbPfJqhIGc1MaZYv5ANHG259v7xj0i0N97bO6cKAjCmgBmOPg5
	 jKBDCZtmaftZYeukz1o76eY8cWvdFMQEAYOSxo3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgHOWMc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgHOWK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DD622B4B;
        Sat, 15 Aug 2020 00:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451444;
        bh=++vL9+ojwEXDICxj/fe7a4hZzf7XNJzmA7W3ygUedH8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VO5/8TSH2Dxp5SXA992juoQM28EkKSzAiMeWKUlGQf3qzG53hBLLfK0rjogcqg/In
         jdWPVOEQ+NqixJS8V+y8oZpDMYo0xJ52F9CRdInj9Zc53IKdTNhCOS8R+sMdu1T0rl
         u6Xdp24dsIlD6A2mTbNCuuEDijoEz+yL4tLNlHsM=
Date:   Fri, 14 Aug 2020 17:30:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 13/39] mm: introduce offset_in_thp
Message-ID: <20200815003043.SkWT1tEoI%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: introduce offset_in_thp

Mirroring offset_in_page(), this gives you the offset within this
particular page, no matter what size page it is.  It optimises down to
offset_in_page() if CONFIG_TRANSPARENT_HUGEPAGE is not set.

Link: http://lkml.kernel.org/r/20200629151959.15779-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-introduce-offset_in_thp
+++ a/include/linux/mm.h
@@ -1594,6 +1594,7 @@ static inline void clear_page_pfmemalloc
 extern void pagefault_out_of_memory(void);
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
+#define offset_in_thp(page, p)	((unsigned long)(p) & (thp_size(page) - 1))
 
 /*
  * Flags passed to show_mem() and show_free_areas() to suppress output in
_
