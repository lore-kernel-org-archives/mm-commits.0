Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9ABC32771
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJCVR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiJCVPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD7A558DD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39126610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90561C433C1;
        Mon,  3 Oct 2022 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831416;
        bh=JYI5A7PcfAUEzhUCb9LTQrICXwCAGQkvsKud1/64eCM=;
        h=Date:To:From:Subject:From;
        b=cfOR0PT+VOLIl/i8stz9CWku48YNWu9LqD6jCJMLBcXj7/eLrUoS13pVguJ16/9oB
         NtiuvpArt59gyLwnszRmfo3HCPWSZiMSkAn0I1X6S71V7Jda0Y2D/7mZQTEulGJwwa
         5XpjVo6VDkBNRaWVIlzDV9PZxXbNbB2N3JEBTISQ=
Date:   Mon, 03 Oct 2022 14:10:15 -0700
To:     mm-commits@vger.kernel.org, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-remove-reduntant-return-value.patch removed from -mm tree
Message-Id: <20221003211016.90561C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/secretmem: remove reduntant return value
has been removed from the -mm tree.  Its filename was
     mm-secretmem-remove-reduntant-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/secretmem: remove reduntant return value
Date: Tue, 20 Sep 2022 09:22:05 +0800

The return value @ret is always 0, so remove it and return 0 directly.

Link: https://lkml.kernel.org/r/20220920012205.246217-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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


