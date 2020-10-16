Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CA5C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7EBF21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881619;
	bh=byszXFQCEHC2S3NN8ZZkUjlNo0pgC2ndGlAqqaa0h/U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yXvdBMraQVSEwNgBHyCbTqGbMdG2D9YUImN2+noG40JLihguOkx5QnHAjdXIcdUxT
	 YUz+0B4Pmh1D9iuOjRvaj+BYSUyw9jobjc6kGgcY/SqY/keULphxVxZGdvW6BoDHSy
	 H5frxsg3kOJGgfto/bjpUqLqOFhZCqPzToLJX08w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409144AbgJPUxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E662145D;
        Fri, 16 Oct 2020 20:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881618;
        bh=byszXFQCEHC2S3NN8ZZkUjlNo0pgC2ndGlAqqaa0h/U=;
        h=Date:From:To:Subject:From;
        b=d2oeW2TKu+mIxfSYIFDOooPNV+g01/ppDW2MXr9EnazvK5skiubXi/nP8HZREK/++
         5pLodBOCoqw1RY036kE7yMsSPp1ndSSSLJf5Sk6Ig/tf9whXPIF1VDxoOaVZUQ31ES
         CV9JTw7Rz4D4i2s+im+5mF2QF64je6dJ4M+ybQ5k=
Date:   Fri, 16 Oct 2020 13:53:38 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com
Subject:  [merged] bitops-simplify-get_count_order_long.patch
 removed from -mm tree
Message-ID: <20201016205338.uT4T2GpxF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: simplify get_count_order_long()
has been removed from the -mm tree.  Its filename was
     bitops-simplify-get_count_order_long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: bitops: simplify get_count_order_long()

These two cases could be unified into one.

Link: https://lkml.kernel.org/r/20200807085837.11697-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/bitops.h~bitops-simplify-get_count_order_long
+++ a/include/linux/bitops.h
@@ -206,10 +206,7 @@ static inline int get_count_order_long(u
 {
 	if (l == 0UL)
 		return -1;
-	else if (l & (l - 1UL))
-		return (int)fls_long(l);
-	else
-		return (int)fls_long(l) - 1;
+	return (int)fls_long(--l);
 }
 
 /**
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


