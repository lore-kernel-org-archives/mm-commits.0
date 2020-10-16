Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDC1C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 227702087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817905;
	bh=1p2WGIZu9/zLv2jaihLdekpGlwjlNasd31lW4kWG3Hk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IAo8EQ+OVwP+9ARioO5sA9Vl+4NcUWEzc25uaEsdZA+wRdhCmPfapEj51x2WjrIPr
	 itthVIlw07OeWv4RlxDXDzZWrnCErIhi8ZUpjiJqx/cH1hZ1IBDckAailRXprfpCvo
	 gYja5mVYG6Nnl64YQJ7+8VZmTV3iZCoLwWxjRdCc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbgJPDLo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7FF120789;
        Fri, 16 Oct 2020 03:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817904;
        bh=1p2WGIZu9/zLv2jaihLdekpGlwjlNasd31lW4kWG3Hk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aug0McEm6R5SUBUvz/hZRowMeNObdDm/PJgmWDTMWZxf5IIL1ResKcYWiWEVsZ7u5
         JVA3gUgg86faHjLx8PSM/muG1c1RXrcvJtrCJ/XGJ0kTFOIGBYH8eUtFrPpz7cpHZY
         OeljHKuP/EF301yxFZEu40xoosXOHi7u2wyJ4QSc=
Date:   Thu, 15 Oct 2020 20:11:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        christian.brauner@ubuntu.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org
Subject:  [patch 119/156] bitops: simplify get_count_order_long()
Message-ID: <20201016031141.7uqv3SWXq%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
