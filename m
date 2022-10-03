Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A852C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJCVP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJCVN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7C14E860
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB10611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E26EC433D6;
        Mon,  3 Oct 2022 21:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831363;
        bh=q3RISkJKphyEJkooD+4Y/oI8ljKH+6e57qnznUa8I+g=;
        h=Date:To:From:Subject:From;
        b=2W1QpAqqjyUkDAdihfdIRbuxLi9/m/mzswLQWQjR51XUiC2qsrtUzNCSOEMxqT5Jx
         nK8EYeeFhHGmHAJA6/ULO5yIQMgbZD0C0tdBWpQBf+LJhDbWPvV7IvDUSEidfOAzaZ
         J0CS3uzgc9sX/sEpdsgEDYYsLv2jJG0BKQqFFeKs=
Date:   Mon, 03 Oct 2022 14:09:22 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-add-__init-annotation-to-secretmem_init.patch removed from -mm tree
Message-Id: <20221003210923.3E26EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/secretmem: add __init annotation to secretmem_init()
has been removed from the -mm tree.  Its filename was
     mm-secretmem-add-__init-annotation-to-secretmem_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/secretmem: add __init annotation to secretmem_init()
Date: Thu, 15 Sep 2022 09:16:02 +0800

It's a fs_initcall entry, add __init annotation to it.

Link: https://lkml.kernel.org/r/20220915011602.176967-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-add-__init-annotation-to-secretmem_init
+++ a/mm/secretmem.c
@@ -276,7 +276,7 @@ static struct file_system_type secretmem
 	.kill_sb	= kill_anon_super,
 };
 
-static int secretmem_init(void)
+static int __init secretmem_init(void)
 {
 	int ret = 0;
 
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


