Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931D8C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjASBQS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjASBOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27C5676C6
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89630B81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FF6C433F2;
        Thu, 19 Jan 2023 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090858;
        bh=QB/zRGmOMkgx5IuLnRezG4Dk9ZTd3Pcjx/4RANJY/yQ=;
        h=Date:To:From:Subject:From;
        b=S6X0k90dw9v6I1TAh7zvs6UEVwUdxSrzxTBA/6EyNz2kLJhOpptdiNgOhMsQs8Fw8
         xUxyLRAd5f2w9h9GnClWjp7UF33J1pIfRNsvljwsJYaPPiu4770xp5q3aRg5568t7S
         xAhgtCbQQO63+mK7Zqjn6ZmcWp0BJLBsCYvyNKW8=
Date:   Wed, 18 Jan 2023 17:14:17 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        panqinglin2020@iscas.ac.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] add-parameter-huge-for-fix_size_alloc_test.patch removed from -mm tree
Message-Id: <20230119011418.28FF6C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_vmalloc.c: add parameter use_huge for fix_size_alloc_test
has been removed from the -mm tree.  Its filename was
     add-parameter-huge-for-fix_size_alloc_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Subject: lib/test_vmalloc.c: add parameter use_huge for fix_size_alloc_test
Date: Mon, 12 Dec 2022 13:56:57 +0800

Add a parameter `use_huge' for fix_size_alloc_test(), which can be used to
test allocation vie vmalloc_huge for both functionality and performance.

Link: https://lkml.kernel.org/r/20221212055657.698420-1-panqinglin2020@iscas.ac.cn
Signed-off-by: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~add-parameter-huge-for-fix_size_alloc_test
+++ a/lib/test_vmalloc.c
@@ -38,6 +38,9 @@ __param(int, test_loop_count, 1000000,
 __param(int, nr_pages, 0,
 	"Set number of pages for fix_size_alloc_test(default: 1)");
 
+__param(bool, use_huge, false,
+	"Use vmalloc_huge in fix_size_alloc_test");
+
 __param(int, run_test_mask, INT_MAX,
 	"Set tests specified in the mask.\n\n"
 		"\t\tid: 1,    name: fix_size_alloc_test\n"
@@ -264,7 +267,10 @@ static int fix_size_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		ptr = vmalloc((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE);
+		if (use_huge)
+			ptr = vmalloc_huge((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE, GFP_KERNEL);
+		else
+			ptr = vmalloc((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE);
 
 		if (!ptr)
 			return -1;
_

Patches currently in -mm which might be from panqinglin2020@iscas.ac.cn are


