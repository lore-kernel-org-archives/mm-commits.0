Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1B5C43217
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 01:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiJLBvs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLBvp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 21:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D4A486B
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 18:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7851B80BFC
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 01:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A20C433D6;
        Wed, 12 Oct 2022 01:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665539502;
        bh=g4gcIGsLzgokYqB8BZ7CduEZyzxK3/g31z/ws82Fn3s=;
        h=Date:To:From:Subject:From;
        b=aTDnteRZlv0r2Jw8s/BVBVrP1UGnBRPEfY+IqQCl6jH5DkYhL1Vb6uUuskMhrrqGo
         Hr7EOp6BGQJ2To5lN/UHY8ALT/4/k2BMKUX8Fv7k+5zRuATT/JO6jqARZEdNc8s0Jr
         aHbcdcdKdcNi4uHCHUnGzH0PktaFgapSMnu+luTo=
Date:   Tue, 11 Oct 2022 18:51:41 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        renzhijie2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-kconfig-fix-unmet-direct-dependencies.patch removed from -mm tree
Message-Id: <20221012015142.85A20C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init/Kconfig: fix unmet direct dependencies
has been removed from the -mm tree.  Its filename was
     init-kconfig-fix-unmet-direct-dependencies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig~init-kconfig-fix-unmet-direct-dependencies
+++ a/init/Kconfig
@@ -1261,6 +1261,7 @@ endif # NAMESPACES
 
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
+	depends on PROC_FS
 	select PROC_CHILDREN
 	select KCMP
 	default n
_

Patches currently in -mm which might be from renzhijie2@huawei.com are


