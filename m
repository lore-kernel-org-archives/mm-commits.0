Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05691C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 22:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbiCBW1X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 17:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiCBW1X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 17:27:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B04E4D29
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 14:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B33AFB82287
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 22:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323B6C004E1;
        Wed,  2 Mar 2022 22:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646259996;
        bh=lylAYzh/sxipibS6m7epxDQbkeNLtsZDpsB1D4KSiRg=;
        h=Date:To:From:Subject:From;
        b=rZZrFUj4Y9YvtXpSyZeU8A8fcxGXjdeG2ztMfPgYV1SW0I2K72K1JPa9MYkc55snh
         kImBpCWmr6ZCloNDCktfIK7CzqrIQw4Hpf8sMhoWR1ufrhJvf1GtW9HEiIWUUVzyc1
         /hEWZ2ZTIM3BL7WubTKD6msRCFUhRE3XVHcfQCBI=
Date:   Wed, 02 Mar 2022 14:26:35 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch added to -mm tree
Message-Id: <20220302222636.323B6C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: fix missing error code in damon_sysfs_attrs_add_dirs()
has been added to the -mm tree.  Its filename is
     mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface-fix.patch

