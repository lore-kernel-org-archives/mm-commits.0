Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18467C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE73207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597869339;
	bh=bigd0tAc24lYp5ygeIU7i4ZKQ+dBehJviByeyx1/LYU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kWYUpidVQvyQf9j4EFoBQhPHl54qxI9y8mMtIBw/icBXTT/Ej4avMLH+MpkG29glc
	 iopVnyDkmf9udHc0lxaOeCysNCNtgqjChWJrSSU7hKHKTM7x9KOADNGHhsBS/kUj5U
	 Usa5M1jDJY/rUMiMg0wh+ibpSS87+fOhRmTV8XBY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHSUfj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSUfh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 16:35:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94FC52063A;
        Wed, 19 Aug 2020 20:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597869336;
        bh=bigd0tAc24lYp5ygeIU7i4ZKQ+dBehJviByeyx1/LYU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NqWwK8+F3c0zrx7WkWVI7BaJJ7pbsdDUl0F/xe87Rk8OP8bY2zq7DnQNPd45e18Qx
         sw+Y48nhfnFm6sHjn4+T9dcOhihu/MipRbO7uryBTEJVxlLtuHQaMFlqLPSfX2xHvo
         LTkY/dLAhxiwhgVIO2hZUp+dgoy7biA4TtvRPGZs=
Date:   Wed, 19 Aug 2020 13:35:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com
Subject:  + bitops-simplify-get_count_order_long.patch added to -mm
 tree
Message-ID: <20200819203536.Ylq1X9QNk%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: simplify get_count_order_long()
has been added to the -mm tree.  Its filename is
     bitops-simplify-get_count_order_long.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitops-simplify-get_count_order_long.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitops-simplify-get_count_order_long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

