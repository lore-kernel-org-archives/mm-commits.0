Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55544C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 14:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiI2OIu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbiI2OIt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 10:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1A31616D2
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 07:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D29BB824AF
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 14:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF3EC433D6;
        Thu, 29 Sep 2022 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664460526;
        bh=WF+JhykySwv2MfsLrxJ2rWnMX1WgsQOcY0R8QDV57A8=;
        h=Date:To:From:Subject:From;
        b=XacPr4KrO1cI6WpQT2z2tUfaAMj+isYPrVFKfUKPfyDT2/gIsfIsvtbV1R4WrPWQ3
         0BoYa7nsFTyZQ3soceGe/YJKdfczU2UAWZ9Z8CaCLvDA88QW9ac/R2Ae7GOrjVUyNL
         5VdI0AXcFU0z2CjdHv4kv8WqvApMBeccMrOKjQPQ=
Date:   Thu, 29 Sep 2022 07:08:44 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        renzhijie2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-fix-unmet-direct-dependencies.patch added to mm-nonmm-unstable branch
Message-Id: <20220929140845.EAF3EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: fix unmet direct dependencies
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-kconfig-fix-unmet-direct-dependencies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-fix-unmet-direct-dependencies.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ren Zhijie <renzhijie2@huawei.com>
Subject: init/Kconfig: fix unmet direct dependencies
Date: Thu, 29 Sep 2022 07:00:57 +0000

Commit 3c07bfce92a5 ("proc: make config PROC_CHILDREN depend on PROC_FS")
make config PROC_CHILDREN depend on PROC_FS.

When CONFIG_PROC_FS is not set and CONFIG_CHECKPOINT_RESTORE=y,
make menuconfig screams like this:

WARNING: unmet direct dependencies detected for PROC_CHILDREN
  Depends on [n]: PROC_FS [=n]
  Selected by [y]:
  - CHECKPOINT_RESTORE [=y]

CHECKPOINT_RESTORE would select PROC_CHILDREN which depends on PROC_FS,
so add depends on PROC_FS to CHECKPOINT_RESTORE to fix this.

Link: https://lkml.kernel.org/r/20220929070057.59044-1-renzhijie2@huawei.com
Fixes: 3c07bfce92a5 ("proc: make config PROC_CHILDREN depend on PROC_FS")
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
Reviewed-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/init/Kconfig~init-kconfig-fix-unmet-direct-dependencies
+++ a/init/Kconfig
@@ -1256,6 +1256,7 @@ endif # NAMESPACES
 
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
+	depends on PROC_FS
 	select PROC_CHILDREN
 	select KCMP
 	default n
_

Patches currently in -mm which might be from renzhijie2@huawei.com are

init-kconfig-fix-unmet-direct-dependencies.patch

