Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0DAC43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJCVLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiJCVJg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A481A04C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A3F611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EA0C433C1;
        Mon,  3 Oct 2022 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831203;
        bh=Rxbcpk8ZKMj9ET36MHiGr5NRsabK9+MrjEhdJXs3dKc=;
        h=Date:To:From:Subject:From;
        b=YJTHY0jCBJzsnaqw3npw8IDG81p1yTk+pmLBcBEIC29mLLRYWaF6UTR6kP7Z7yE4R
         2rIDydpGsZQMBgMjGEc8dKyvKC8sVi47dEDsNhm/bHw3Ol/T99+tM3HH66YvFiFs1G
         Tp19tduWMP5nAKnmr2He4vmEG/CDQaGu3/qqKosk=
Date:   Mon, 03 Oct 2022 14:06:42 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch removed from -mm tree
Message-Id: <20221003210643.A0EA0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: add __init/__exit annotations to module init/exit funcs
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hwpoison: add __init/__exit annotations to module init/exit funcs
Date: Tue, 6 Sep 2022 17:35:30 +0800

Add missing __init/__exit annotations to module init/exit funcs.

Link: https://lkml.kernel.org/r/20220906093530.243262-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hwpoison-inject.c~mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs
+++ a/mm/hwpoison-inject.c
@@ -63,13 +63,13 @@ static int hwpoison_unpoison(void *data,
 DEFINE_DEBUGFS_ATTRIBUTE(hwpoison_fops, NULL, hwpoison_inject, "%lli\n");
 DEFINE_DEBUGFS_ATTRIBUTE(unpoison_fops, NULL, hwpoison_unpoison, "%lli\n");
 
-static void pfn_inject_exit(void)
+static void __exit pfn_inject_exit(void)
 {
 	hwpoison_filter_enable = 0;
 	debugfs_remove_recursive(hwpoison_dir);
 }
 
-static int pfn_inject_init(void)
+static int __init pfn_inject_init(void)
 {
 	hwpoison_dir = debugfs_create_dir("hwpoison", NULL);
 
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


