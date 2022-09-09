Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048A1ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIIVhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIIVhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:37:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BE0138137
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D500D620D6
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3181DC433D6;
        Fri,  9 Sep 2022 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759423;
        bh=WB/0jh/sQrv2yRNdNUbA7EOeketlESjb0iRIzo2rVf4=;
        h=Date:To:From:Subject:From;
        b=oZ2x2BFjTHFBtE+meaRyZ47X4Hdk98JMOhBanbcM+ORVz5Duzv9Qnou7VfYRUXMlk
         4ujptE5+2xD0X30+JpCwiGrhsF2Y1RjkB3ZHaCl6qdZIResg6BeMh7et++DlekduuD
         qtwu3T/CKSuzxQmBxFKIOAnQAQI2DsLXzmi833Hw=
Date:   Fri, 09 Sep 2022 14:37:02 -0700
To:     mm-commits@vger.kernel.org, iago@endocode.com, adobriyan@gmail.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-make-config-proc_children-depend-on-proc_fs.patch added to mm-nonmm-unstable branch
Message-Id: <20220909213703.3181DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make config PROC_CHILDREN depend on PROC_FS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-make-config-proc_children-depend-on-proc_fs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-make-config-proc_children-depend-on-proc_fs.patch

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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: proc: make config PROC_CHILDREN depend on PROC_FS
Date: Fri, 9 Sep 2022 14:25:29 +0200

Commit 2e13ba54a268 ("fs, proc: introduce CONFIG_PROC_CHILDREN")
introduces the config PROC_CHILDREN to configure kernels to provide the
/proc/<pid>/task/<tid>/children file.

When one deselects PROC_FS for kernel builds without /proc/, the config
PROC_CHILDREN has no effect anymore, but is still visible in menuconfig.

Add the dependency on PROC_FS to make the PROC_CHILDREN option disappear
for kernel builds without /proc/.

Link: https://lkml.kernel.org/r/20220909122529.1941-1-lukas.bulwahn@gmail.com
Fixes: 2e13ba54a268 ("fs, proc: introduce CONFIG_PROC_CHILDREN")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Cc: Iago López Galeiras <iago@endocode.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/Kconfig~proc-make-config-proc_children-depend-on-proc_fs
+++ a/fs/proc/Kconfig
@@ -92,6 +92,7 @@ config PROC_PAGE_MONITOR
 
 config PROC_CHILDREN
 	bool "Include /proc/<pid>/task/<tid>/children file"
+	depends on PROC_FS
 	default n
 	help
 	  Provides a fast way to retrieve first level children pids of a task. See
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch
proc-make-config-proc_children-depend-on-proc_fs.patch

