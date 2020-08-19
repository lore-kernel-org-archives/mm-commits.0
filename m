Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BAAC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 323232063A
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597869355;
	bh=nneJ7t6tp/8OayRy2FWJXpHJEJUG7o5dGd2Ql69INl4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xSdEd+JudQkOaVVoXp7Uf8Th81ZxsijSkXQy+3KWT9TW5+bBU3LxVJ4pK+80Y/fdV
	 NlSrXKII6cnzSVVtHE25Uz1VqXe0AFsKMHlrmnbnyy2zat10+u5rhjbJWAWwD+QdD+
	 DnhXjwUBf57aP2AbS+ITmrY9/vV/1boM/rAgou1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHSUfs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHSUfq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 16:35:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4BD2063A;
        Wed, 19 Aug 2020 20:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597869345;
        bh=nneJ7t6tp/8OayRy2FWJXpHJEJUG7o5dGd2Ql69INl4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wCRfpG+gAQQL/2DFmySM44yym2+v3ul9jm+2KDKHuym8LR4+EkLsdCluOKx1ihMKU
         jgQWRnTunJIAK193CPLn80nr6KoMhjOiJ+lbUqaXkW438dXcaVPiEiiVLFR9nTsTQW
         atBxrteFr62RkEHekPQzFrTS5r0hq4+aC1OBnVhM=
Date:   Wed, 19 Aug 2020 13:35:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com
Subject:  + bitops-use-the-same-mechanism-for-get_count_order.patch
 added to -mm tree
Message-ID: <20200819203545.cdBthcGHm%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: use the same mechanism for get_count_order[_long]
has been added to the -mm tree.  Its filename is
     bitops-use-the-same-mechanism-for-get_count_order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitops-use-the-same-mechanism-for-get_count_order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitops-use-the-same-mechanism-for-get_count_order.patch

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

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

