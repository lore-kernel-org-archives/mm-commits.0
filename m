Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C24EC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B943D218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881622;
	bh=Sfy+Ux3BaNOwNN6K6NFBVG/WMB9rHiboDmnILsx6SKY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yEDPzZNUnYjz2B9FZozt4b62TPqaRiODNstlJBGaevbrlergcxzZCvQC/ZzBVwNEn
	 fFMDIjd6XC93WH2A9da1tMl941/G8aq69Z1alEhhTqXLPwvRrfw/Z/iHKIbu6ZgzBm
	 nddcPH2Kf2YwesYOrepfIuPPh4U4firnyLTGvGGc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409149AbgJPUxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A90132076C;
        Fri, 16 Oct 2020 20:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881621;
        bh=Sfy+Ux3BaNOwNN6K6NFBVG/WMB9rHiboDmnILsx6SKY=;
        h=Date:From:To:Subject:From;
        b=bfwS1RcGZ5+2FJRqQf2uL3PWC74a+pnB5mNgJvyQdnfz5LMhVcANrC3pKyzNde82M
         jOQ6uaaYsM8vlm4C4DKamQ3qyiPvyv5QtWpi4lM3k9poZrj58pYiAGN2VZsZBQZXO7
         22t63Cx5n4xIviVBTOXmw3962SXiKqUH4yxYNKIg=
Date:   Fri, 16 Oct 2020 13:53:41 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com
Subject:  [merged]
 bitops-use-the-same-mechanism-for-get_count_order.patch removed from -mm
 tree
Message-ID: <20201016205341.7Ry2hs3PA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: use the same mechanism for get_count_order[_long]
has been removed from the -mm tree.  Its filename was
     bitops-use-the-same-mechanism-for-get_count_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


