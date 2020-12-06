Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B07EC4167B
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367EA22D0B
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgLFGQE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Dec 2020 01:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgLFGQE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 6 Dec 2020 01:16:04 -0500
Date:   Sat, 05 Dec 2020 22:15:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235309;
        bh=u/TZ0/sDMhzVQKE+Iuw6n1atZMzd/neqVZblPQVEQBg=;
        h=From:To:Subject:In-Reply-To:From;
        b=c/YNVtoIndRk+SMcNiliiQPEr6EEd6fmeW/J3odFvjElvfcEqgy3aigChMtw3pU1z
         ITc4Iya7ARpxOreSx9LEkI8E6LVixDoWh76l9CJ5HRF4r2M0flzogux11nvJKZCVV8
         EJc8z2BGRSpjou9AcYnmsmhtgeymUpr3KM3R1a2o=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jrdr.linux@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 10/12] mm/filemap: add static for function
 __add_to_page_cache_locked
Message-ID: <20201206061509.ktTlES2yY%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/filemap: add static for function __add_to_page_cache_locked

../mm/filemap.c:830:14: warning: no previous prototype for
`__add_to_page_cache_locked' [-Wmissing-prototypes]
 noinline int __add_to_page_cache_locked(struct page *page,

Link: https://lkml.kernel.org/r/1604661895-5495-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-add-static-for-function-__add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -827,7 +827,7 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-noinline int __add_to_page_cache_locked(struct page *page,
+static noinline int __add_to_page_cache_locked(struct page *page,
 					struct address_space *mapping,
 					pgoff_t offset, gfp_t gfp,
 					void **shadowp)
_
