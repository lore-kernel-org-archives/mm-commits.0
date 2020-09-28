Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDA1C2D0A8
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC3C721775
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601327691;
	bh=Eto67hFpQA5ktD1vfKxNi3anS0vcXdjqb+0Zpb3GMAQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mAT/AuacnR3B3C3IQsIGU2yXKmrU1Qg8pnZBnUM6lOJSvqRSUXBHcfjuRKHIIEOxg
	 c1R1BDtshafdZXX8uyc+Cw9LvTDgfe0AonrE/wrKeKgy0CrKZlObE4+lklpaDWFfIm
	 o3UC3XXgFkRZpJdDe8vDCWvCKLzvNHFryE81ikiM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgI1VOu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1VOu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 17:14:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85FEB2083B;
        Mon, 28 Sep 2020 21:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327688;
        bh=Eto67hFpQA5ktD1vfKxNi3anS0vcXdjqb+0Zpb3GMAQ=;
        h=Date:From:To:Subject:From;
        b=N5T9DbYAzV7o0HsTggsatsWoGnSV/0931oV5qYQiOGJMlb1WZn5HNYEH/tSExmsVD
         vBkdxcGFNE5R8UttNv5+rihUtleozcI2g3B5iuBScIV9ewjyWzG/QE9yZcH+cbtfEN
         hbuJbMz+akVszhs+eST7o65EmS7mFfHgYzqKdLSo=
Date:   Mon, 28 Sep 2020 14:14:48 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com
Subject:  [merged] lib-include-memregionh-in-memregionc.patch
 removed from -mm tree
Message-ID: <20200928211448.JoTDRc9t-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/memregion.c: include memregion.h
has been removed from the -mm tree.  Its filename was
     lib-include-memregionh-in-memregionc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: lib/memregion.c: include memregion.h

This addresses the following sparse warning:

lib/memregion.c:8:5: warning: symbol 'memregion_alloc' was not declared.
Should it be static?
lib/memregion.c:14:6: warning: symbol 'memregion_free' was not declared.
Should it be static?

Link: https://lkml.kernel.org/r/20200921142852.875312-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/memregion.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/memregion.c~lib-include-memregionh-in-memregionc
+++ a/lib/memregion.c
@@ -2,6 +2,7 @@
 /* identifiers for device / performance-differentiated memory regions */
 #include <linux/idr.h>
 #include <linux/types.h>
+#include <linux/memregion.h>
 
 static DEFINE_IDA(memregion_ids);
 
_

Patches currently in -mm which might be from yanaijie@huawei.com are


