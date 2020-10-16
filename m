Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C82C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5428C208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816515;
	bh=1p2WGIZu9/zLv2jaihLdekpGlwjlNasd31lW4kWG3Hk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lNuUys7o3kkuEJcnRPpZaw4gmR610ulLx/XNTzIf5wAK8Yw/TV5tR/18tuXizSAOx
	 lQVVYLx5gY52XTl91vCiHlsWwm94d7QpkviM3R/frL7rruZURQ2thVxG0X2/E1jj0i
	 Rs782E9gPTET2YSLelas9uziSE4wY4x/i3rzmeWs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393918AbgJPCse (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388865AbgJPCse (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E45882087D;
        Fri, 16 Oct 2020 02:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816514;
        bh=1p2WGIZu9/zLv2jaihLdekpGlwjlNasd31lW4kWG3Hk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P3Fo3hUaaYavzqlzgEJbOpOslFNX7vnbcgj1hgXSBZthGPTsuLpqLkLdGQ+5OdqBO
         wE0nXFKZiaEwbmVvle2bM3mQ73chbnovXwB9U+rHkjE3n6un8tnt+HRMjBJ7069zFn
         C/Iv1qPQaknPruDvkLALowS14hQJ69pizYx8CnAQ=
Date:   Thu, 15 Oct 2020 19:48:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        christian.brauner@ubuntu.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 119/156] bitops: simplify get_count_order_long()
Message-ID: <20201016024833._HHE9Nf8E%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
