Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A8EC04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 20:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiIYUjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 16:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYUjk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 16:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C90719B
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 13:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A0CFB8112E
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 20:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EAEC433C1;
        Sun, 25 Sep 2022 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664138367;
        bh=yjnUJjE67zBip4H+uqVw876LRXVjO7yBmXB5c6iha2c=;
        h=Date:To:From:Subject:From;
        b=frKDnsBeHtxMIJxe1sP4+PMxtjvd5x59ALI8rykeJCseA4SsTCstsQ2iT3YX8kQuw
         n8xvMs6703sIqe3muzyqq/HfysOIo33HVIIs67Ibn7aIdCFT/T6IKswqfB1ww1bxrK
         Yne+ZQ316EG9ffq+sQUg5NtRtp/+mktocQ47ChWc=
Date:   Sun, 25 Sep 2022 13:39:25 -0700
To:     mm-commits@vger.kernel.org, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-remove-reduntant-return-value.patch added to mm-unstable branch
Message-Id: <20220925203927.22EAEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: remove reduntant return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-remove-reduntant-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-remove-reduntant-return-value.patch

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
Subject: mm/secretmem: remove reduntant return value
Date: Tue, 20 Sep 2022 09:22:05 +0800

The return value @ret is always 0, so remove it and return 0 directly.

Link: https://lkml.kernel.org/r/20220920012205.246217-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/secretmem.c~mm-secretmem-remove-reduntant-return-value
+++ a/mm/secretmem.c
@@ -278,10 +278,8 @@ static struct file_system_type secretmem
 
 static int __init secretmem_init(void)
 {
-	int ret = 0;
-
 	if (!secretmem_enable)
-		return ret;
+		return 0;
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
 	if (IS_ERR(secretmem_mnt))
@@ -290,6 +288,6 @@ static int __init secretmem_init(void)
 	/* prevent secretmem mappings from ever getting PROT_EXEC */
 	secretmem_mnt->mnt_flags |= MNT_NOEXEC;
 
-	return ret;
+	return 0;
 }
 fs_initcall(secretmem_init);
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch
mm-rodata_test-use-page_aligned-helper.patch
mm-secretmem-add-__init-annotation-to-secretmem_init.patch
mm-secretmem-remove-reduntant-return-value.patch

