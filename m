Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282BEC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 20:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbiKQUOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbiKQUOl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 15:14:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CB031369
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 12:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6300DB821F5
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 20:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15162C433D6;
        Thu, 17 Nov 2022 20:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668716077;
        bh=w9yJRyOs6xZPvatyOhGUdAEHNBo/QU5ViZ5K7f+qhyE=;
        h=Date:To:From:Subject:From;
        b=bezoMSzJszfFMyk6eXyJUW9fhV5BYBAvuqYKIetmL9b9lb90UPKT8j0TKAWlWkbfH
         7efzdXcWAKyb2+xZwHBu311YRquCYTxQEbRpfwEH+l2FgLdzM1+cQ03IIFTtZ9hTrY
         gnidjrY+gzxMRvVxG+2b6j5pDyXe4DXg7tRXHXEs=
Date:   Thu, 17 Nov 2022 12:14:36 -0800
To:     mm-commits@vger.kernel.org, Chao.Xu9@zeekrlife.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-vmstat-correct-some-wrong-comments-based-on-fls.patch removed from -mm tree
Message-Id: <20221117201437.15162C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmstat: correct some wrong comments based-on fls()
has been removed from the -mm tree.  Its filename was
     mm-vmstat-correct-some-wrong-comments-based-on-fls.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Chao Xu <Chao.Xu9@zeekrlife.com>
Subject: mm/vmstat: correct some wrong comments based-on fls()
Date: Sat, 29 Oct 2022 12:44:36 +0800

The threshold should grow logarithmically, using fls() as an easy
approximation.  But there are some errors in fls(mem) and fls(Processors).
It is misleading so let's correct it.

Link: https://lkml.kernel.org/r/20221029044436.198169-1-xuchao066@163.com
Signed-off-by: Chao Xu <Chao.Xu9@zeekrlife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-correct-some-wrong-comments-based-on-fls
+++ a/mm/vmstat.c
@@ -241,17 +241,17 @@ int calculate_normal_threshold(struct zo
 	 * 28		2		2	4-8 GB		7
 	 * 32		2		2	8-16 GB		8
 	 * 4		2		2	<128M		1
-	 * 30		4		3	2-4 GB		5
+	 * 30		4		3	2-4 GB		6
 	 * 48		4		3	8-16 GB		8
-	 * 32		8		4	1-2 GB		4
+	 * 32		8		4	1-2 GB		5
 	 * 32		8		4	0.9-1GB		4
 	 * 10		16		5	<128M		1
 	 * 40		16		5	900M		4
-	 * 70		64		7	2-4 GB		5
-	 * 84		64		7	4-8 GB		6
-	 * 108		512		9	4-8 GB		6
-	 * 125		1024		10	8-16 GB		8
-	 * 125		1024		10	16-32 GB	9
+	 * 70		64		7	2-4 GB		6
+	 * 84		64		7	4-8 GB		7
+	 * 108		512		10	4-8 GB		7
+	 * 125		1024		11	8-16 GB		8
+	 * 125		1024		11	16-32 GB	9
 	 */
 
 	mem = zone_managed_pages(zone) >> (27 - PAGE_SHIFT);
_

Patches currently in -mm which might be from Chao.Xu9@zeekrlife.com are


