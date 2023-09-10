Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467B2C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 21:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjIJVvY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 17:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjIJVvX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 17:51:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84249F
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 14:51:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FBAC433C7;
        Sun, 10 Sep 2023 21:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694382679;
        bh=adK7sHbNTBS6yCdOKezQTSFtUKUIHcQSSxs8xfe6338=;
        h=Date:To:From:Subject:From;
        b=D2udjuZ+NTClgHS4A7Nn45cQfwO80j7S4/I9nnGT37owxyYTr2ImvG8mHUB5hjSyY
         2nHptge3abSzcLRimvEQvMKO2fZRGrK8ulaU2IOIgtBxfEMdrciN8gnSyBmreQAW3w
         STjb/Mxc2gK0oW6cKuAVIw/bptLJ1FpSuvGyauBw=
Date:   Sun, 10 Sep 2023 14:51:18 -0700
To:     mm-commits@vger.kernel.org, renyanjie01@gmail.com,
        sunying@nj.iscas.ac.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem.patch added to mm-unstable branch
Message-Id: <20230910215119.46FBAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: remove dead code can not be satisfied by "(CONFIG_SHMEM)&&(!(CONFIG_SHMEM))"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem.patch

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
From: Ying Sun <sunying@nj.iscas.ac.cn>
Subject: mm/shmem: remove dead code can not be satisfied by "(CONFIG_SHMEM)&&(!(CONFIG_SHMEM))"
Date: Wed, 6 Sep 2023 12:50:12 +0800

The value of “.fs_flags” in line 4608 is a dead code which will never
be implemented，because its conditions of line 47 "#ifdef CONFIG_SHMEM"
and line 4607 are mutually exclusive.  It is recommended to delete
redundant code.

Link: https://lkml.kernel.org/r/20230906045012.14999-1-sunying@nj.iscas.ac.cn
Suggested-by: Yanjie Ren <renyanjie01@gmail.com>
Signed-off-by: Ying Sun <sunying@nj.iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem
+++ a/mm/shmem.c
@@ -4602,11 +4602,7 @@ static struct file_system_type shmem_fs_
 	.parameters	= shmem_fs_parameters,
 #endif
 	.kill_sb	= kill_litter_super,
-#ifdef CONFIG_SHMEM
 	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME,
-#else
-	.fs_flags	= FS_USERNS_MOUNT,
-#endif
 };
 
 void __init shmem_init(void)
_

Patches currently in -mm which might be from sunying@nj.iscas.ac.cn are

mm-shmem-remove-dead-code-can-not-be-satisfied-by-config_shmemconfig_shmem.patch

