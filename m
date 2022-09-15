Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0F6ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 22:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIOWKl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 18:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIOWKk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 18:10:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7724DB6E
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 15:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42531B8228A
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 22:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76B7C433D6;
        Thu, 15 Sep 2022 22:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663279837;
        bh=473E/uM8LZGFXIw5dEGN0oXxS74I9HS+rIKr9x1hFaU=;
        h=Date:To:From:Subject:From;
        b=eVisSD4QZL7lkPFhgeJJF/X+qdZS2dDnc/ZfdlOfdQ+sZjL64b1Kw9ScI97iyszgE
         jKpg8WaGS/plZVfQpfUkPsmBUQ61zl92hqoXqilKEImBhemO61lEsPPOQlOh+Kcmx2
         kaUoZup/wfIDjNDSBfNkvsJNrQwTgiU0S7lyivFk=
Date:   Thu, 15 Sep 2022 15:10:36 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-add-__init-annotation-to-secretmem_init.patch added to mm-unstable branch
Message-Id: <20220915221036.E76B7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: add __init annotation to secretmem_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-add-__init-annotation-to-secretmem_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-add-__init-annotation-to-secretmem_init.patch

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

mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch
mm-rodata_test-use-page_aligned-helper.patch
mm-secretmem-add-__init-annotation-to-secretmem_init.patch

