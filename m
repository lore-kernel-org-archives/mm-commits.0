Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F21C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF97420878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817909;
	bh=T+KSVLW0CtKXuHJFkCWzj/3QsjxObjKS5AWx0E+8b64=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gCrOFiNQbEj2wKdB+OjPr/7fVmbjEm020WnVY9ulEjL3RWpqDpCvjKTc7MSDuMrAj
	 oA5wBbltxZxxW4RGBXiggeMMzhRd51PgIzLoiQjQ2I6YnNdhb5Pc4f1ewbPMHRBm8t
	 MSdnMFhKxVRI5PW16SA6lBFDfG2skxg/S/Ba3mog=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388665AbgJPDLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EFDA20878;
        Fri, 16 Oct 2020 03:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817907;
        bh=T+KSVLW0CtKXuHJFkCWzj/3QsjxObjKS5AWx0E+8b64=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ub3CtUfUS/z8Pmho6BUXm+SQgTGquBg30YozJyN3soRkYdN18N0RHfkcYxEu6/Wkt
         avvH+PrXiBBXelV5wqlolJz3vWjaQi4J6LMUf3EPGUkWPirNttuhOIUqPqwDIgUc5f
         IevowNkZ6h/yWxTYof//JoyOqi5b5WGJLC/l306c=
Date:   Thu, 15 Oct 2020 20:11:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        christian.brauner@ubuntu.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org
Subject:  [patch 120/156] bitops: use the same mechanism for
 get_count_order[_long]
Message-ID: <20201016031146.MsjOfSEIH%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: bitops: use the same mechanism for get_count_order[_long]

These two functions share the same logic.

Link: https://lkml.kernel.org/r/20200807085837.11697-3-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/bitops.h~bitops-use-the-same-mechanism-for-get_count_order
+++ a/include/linux/bitops.h
@@ -188,12 +188,10 @@ static inline unsigned fls_long(unsigned
 
 static inline int get_count_order(unsigned int count)
 {
-	int order;
+	if (count == 0)
+		return -1;
 
-	order = fls(count) - 1;
-	if (count & (count - 1))
-		order++;
-	return order;
+	return fls(--count);
 }
 
 /**
_
