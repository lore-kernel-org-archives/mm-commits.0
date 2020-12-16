Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49D3C2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B126D2313C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLPEnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLPEnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Date:   Tue, 15 Dec 2020 20:42:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093778;
        bh=nThs9RVIrQdVfMrXId6okYn+xOiC3u90oCUK/3zAIn8=;
        h=From:To:Subject:In-Reply-To:From;
        b=dkpbO1O95EJAhoc1osrO9JO6VwjHOgE4//pp8fyN5eyJJ6THnE0d1g38z2ZbUl6d8
         zxCxViaKUWeKQgeLwgDc7slTG8zhxiB/Tr4+qukMXK8cXRFOcjZ2R7i5MmQJSAKopu
         wywBFJsS08B71zm6JIBki0iySQxmIPcZhmaixRoI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        jianpeng.ma@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yury.norov@gmail.com
Subject:  [patch 12/95] bitmap: remove unused function declaration
Message-ID: <20201216044257.kMGpNO_Si%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Ma, Jianpeng" <jianpeng.ma@intel.com>
Subject: bitmap: remove unused function declaration

Link: https://lkml.kernel.org/r/BN7PR11MB26097166B6B46387D8A1ABA4FDE30@BN7PR11MB2609.namprd11.prod.outlook.com
Fixes: 2afe27c718b6 ("lib/bitmap.c: bitmap_[empty,full]: remove code duplication")
Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/bitmap.h~bitmap-remove-unused-function-declaration
+++ a/include/linux/bitmap.h
@@ -126,8 +126,6 @@ extern void bitmap_free(const unsigned l
  * lib/bitmap.c provides these functions:
  */
 
-extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
-extern int __bitmap_full(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern bool __pure __bitmap_or_equal(const unsigned long *src1,
_
