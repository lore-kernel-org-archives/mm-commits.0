Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7012EC3E8C5
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F7A2224F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvtZFvq6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKPVCq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgKPVCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:02:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF30A207BC;
        Mon, 16 Nov 2020 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560565;
        bh=6Y2+JeKd1u0rjdqZ/W0UbUKdhzVTULPVkcWKZu4TPck=;
        h=Date:From:To:Subject:From;
        b=JvtZFvq6OCKna7zzoeVKqsuQ0pnsgS7vqO6ZrizkNmlWyzqq7k5KVBJ0OdAGPXjMH
         F7qlyDIRaoQozrxLg3WhRf1vsqxA8P6Q63+YYBcNOtcHkb/zRuI9o5kCdDXoL1PszV
         fFQvT6W9sqR9m5/6/dLrHvx0rJy1PmPrD6JiUarQ=
Date:   Mon, 16 Nov 2020 13:02:45 -0800
From:   akpm@linux-foundation.org
To:     jianpeng.ma@intel.com, mm-commits@vger.kernel.org,
        yury.norov@gmail.com
Subject:  + bitmap-remove-unused-function-declaration.patch added
 to -mm tree
Message-ID: <20201116210245.Fo1rEmajm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: remove unused function declaration
has been added to the -mm tree.  Its filename is
     bitmap-remove-unused-function-declaration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitmap-remove-unused-function-declaration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitmap-remove-unused-function-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Ma, Jianpeng" <jianpeng.ma@intel.com>
Subject: bitmap: remove unused function declaration

Link: https://lkml.kernel.org/r/BN7PR11MB26097166B6B46387D8A1ABA4FDE30@BN7PR11MB2609.namprd11.prod.outlook.com
Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
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

Patches currently in -mm which might be from jianpeng.ma@intel.com are

bitmap-remove-unused-function-declaration.patch

