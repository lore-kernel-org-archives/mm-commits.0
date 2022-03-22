Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD811C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiCVTTM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiCVTTM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:19:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F1626AF1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B0D61652
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FD6C340EC;
        Tue, 22 Mar 2022 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976663;
        bh=j2f4SwH9Kw8js2cW36Pa5Da1w3K4NOC5Unjlr3qwASc=;
        h=Date:To:From:Subject:From;
        b=FlPzsZpNPkGRwS8B0TA17m5kwjZzE+kULxQwDBI+IUlleCmqH976ZrLl1JrQ9nuU6
         5g+gnbM50llnrWCY49g4xILapr2Jr0l16seCK9lL13NPOglMWNOcEusNzVB76v6/nv
         sGjPzBoxSiSiwe1aRhetIyhWW3Lf96c2QvURi9Zw=
Date:   Tue, 22 Mar 2022 12:17:42 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch removed from -mm tree
Message-Id: <20220322191743.83FD6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: fix missing error code in damon_sysfs_attrs_add_dirs()
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch

This patch was dropped because it was folded into mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface.patch

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/damon/sysfs: fix missing error code in damon_sysfs_attrs_add_dirs()

The error code is missing in this code scenario, add the error code
'-ENOMEM' to the return value 'err'.

Eliminate the follow smatch warning:

mm/damon/sysfs.c:1647 damon_sysfs_attrs_add_dirs() warn: missing error
code 'err'.

Link: https://lkml.kernel.org/r/20220302111120.24984-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix
+++ a/mm/damon/sysfs.c
@@ -452,8 +452,10 @@ static int damon_sysfs_attrs_add_dirs(st
 	attrs->intervals = intervals;
 
 	nr_regions_range = damon_sysfs_ul_range_alloc(10, 1000);
-	if (!nr_regions_range)
+	if (!nr_regions_range) {
+		err = -ENOMEM;
 		goto put_intervals_out;
+	}
 
 	err = kobject_init_and_add(&nr_regions_range->kobj,
 			&damon_sysfs_ul_range_ktype, &attrs->kobj,
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

mm-vmallocc-fix-unused-function-warning.patch
mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface.patch

