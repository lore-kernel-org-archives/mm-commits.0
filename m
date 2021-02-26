Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E25C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC27B64EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhBZBXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBZBWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC9E664EE1;
        Fri, 26 Feb 2021 01:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302543;
        bh=ffuApzQHIWKWY/j/xFPHkObXjodTFLYr7HMtdtFeOx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yeWRxltJn9xB3WaJtaGvDhFYCxSS8JJNCFJFGFrhqRfq50TpXExmlE0GZ7pxHAqH+
         g2IYy3yS8BGqjAz0LLH3xdsB44MPA/YsMB0bkvaSuJwjSj8Opg5Kf51ffWDr89gw4z
         +6KVvevMBr0r3j+qsvvfj0nlIq2g89ydqqKg5VIs=
Date:   Thu, 25 Feb 2021 17:22:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 111/118] fs/coredump: use kmap_local_page()
Message-ID: <20210226012222.PVvo5D3vN%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>
Subject: fs/coredump: use kmap_local_page()

In dump_user_range() there is no reason for the mapping to be global.  Use
kmap_local_page() rather than kmap.

Link: https://lkml.kernel.org/r/20210203223328.558945-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/coredump.c~fs-coredump-use-kmap_local_page
+++ a/fs/coredump.c
@@ -897,10 +897,10 @@ int dump_user_range(struct coredump_para
 		 */
 		page = get_dump_page(addr);
 		if (page) {
-			void *kaddr = kmap(page);
+			void *kaddr = kmap_local_page(page);
 
 			stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
-			kunmap(page);
+			kunmap_local(kaddr);
 			put_page(page);
 		} else {
 			stop = !dump_skip(cprm, PAGE_SIZE);
_
