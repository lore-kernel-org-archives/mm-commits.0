Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B09C54EE9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIGWxB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIGWw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB4ABD13F
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41A1EB81F53
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC5EC433C1;
        Wed,  7 Sep 2022 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662591175;
        bh=qzlBz9yR+EnN3VahrCjO91IXtF/MdE+3IZ4Gfq4zTPo=;
        h=Date:To:From:Subject:From;
        b=Ux9UYowuRRb1u7yNSZF+CBO4FLxDonJ90Dg6UbxFmzD4C9MJLDe5BZu7NbG3XrvnB
         3z3SnTzlkq3bsW4OgLs3HOeEu8uPZJtO2xPP2X3vzOaWrH2Y440XBXYeCRu48iMgwW
         lAheXNfcjbYRLYOr9p7eZUZWLxV/luvzRd0Om91c=
Date:   Wed, 07 Sep 2022 15:52:55 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch added to mm-unstable branch
Message-Id: <20220907225255.DBC5EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: add __init/__exit annotations to module init/exit funcs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hwpoison: add __init/__exit annotations to module init/exit funcs
Date: Tue, 6 Sep 2022 17:35:30 +0800

Add missing __init/__exit annotations to module init/exit funcs.

Link: https://lkml.kernel.org/r/20220906093530.243262-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch

