Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57661E7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjJDUTC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244466AbjJDUS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1A1C0
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC7EC433C8;
        Wed,  4 Oct 2023 20:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450733;
        bh=aOuJsW293Fa+7+YDbB4r66bn9Asmnas3WXOT9TsCb6U=;
        h=Date:To:From:Subject:From;
        b=j5PkwcuGMsEKAOZGK9zl8b9qSnxo757c+1bv1UgVRqUBElG0aAsjyWTfh3ZdO2aBw
         BiIhC/t4FlxYlBbNBHHOTPn5TblgGMtuMbROAytcVL1WJCSqGYyvGXgYNbq2xF6B/O
         FSOcdveFx2c6gfMJ3yeg7NkINjMs46yxCHY8Ap3A=
Date:   Wed, 04 Oct 2023 13:18:51 -0700
To:     mm-commits@vger.kernel.org, renyanjie01@gmail.com,
        sunying@nj.iscas.ac.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem.patch removed from -mm tree
Message-Id: <20231004201853.4AC7EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: remove dead code can not be satisfied by "(CONFIG_SHMEM)&&(!(CONFIG_SHMEM))"
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ying Sun <sunying@nj.iscas.ac.cn>
Subject: mm/shmem: remove dead code can not be satisfied by "(CONFIG_SHMEM)&&(!(CONFIG_SHMEM))"
Date: Wed, 6 Sep 2023 12:50:12 +0800

The value of “.fs_flags” in line 4608 is a dead code which will never
be implemented，because its conditions of line 47 "#ifdef CONFIG_SHMEM"
and line 4607 are mutually exclusive.  It is recommended to delete
redundant code.

Link: https://lkml.kernel.org/r/20230906045012.14999-1-sunying@nj.iscas.ac.cn
Signed-off-by: Ying Sun <sunying@nj.iscas.ac.cn>
Suggested-by: Yanjie Ren <renyanjie01@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem
+++ a/mm/shmem.c
@@ -4585,11 +4585,7 @@ static struct file_system_type shmem_fs_
 	.parameters	= shmem_fs_parameters,
 #endif
 	.kill_sb	= kill_litter_super,
-#ifdef CONFIG_SHMEM
 	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
-#else
-	.fs_flags	= FS_USERNS_MOUNT,
-#endif
 };
 
 void __init shmem_init(void)
_

Patches currently in -mm which might be from sunying@nj.iscas.ac.cn are


