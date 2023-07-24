Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24A2C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjGXRY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjGXRYy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDFE1728
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55DF0612D2
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EEBC433C8;
        Mon, 24 Jul 2023 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690219481;
        bh=qJD1fLtPngyld8bXeTFSe4T48S+QK3YfzKkWSKx8aA0=;
        h=Date:To:From:Subject:From;
        b=qqo779VhWHPwVQEWm9c1+ZUh3zTQGG+jzlOQrojelI8kts9z++jl4XYY9MYv+HNlY
         4AxnGjfZ1bROVsScaa0iAhMrtEjMYVmgxiVBe6nC6rbGYg9tUmRyb+ZA4Bp2nVhDbg
         yYMLo8qiztLh4lHQognPxOjucZYzleECf5NzM9/Y=
Date:   Mon, 24 Jul 2023 10:24:40 -0700
To:     mm-commits@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        jirislaby@kernel.org, axboe@kernel.dk, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch added to mm-nonmm-unstable branch
Message-Id: <20230724172441.A6EEBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mmap: consider pgoff when searching for free mapping
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch

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
From: Helge Deller <deller@gmx.de>
Subject: ia64: mmap: consider pgoff when searching for free mapping
Date: Fri, 21 Jul 2023 17:24:32 +0200

IA64 is the only architecture which does not consider the pgoff value when
searching for a possible free memory region with vm_unmapped_area(). 
Adding this seems to have no negative side effect on IA64, so add it now
to make IA64 consistent with all other architectures.

Link: https://lkml.kernel.org/r/20230721152432.196382-3-deller@gmx.de
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/sys_ia64.c~ia64-mmap-consider-pgoff-when-searching-for-free-mapping
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -63,7 +63,7 @@ arch_get_unmapped_area (struct file *fil
 	info.low_limit = addr;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = align_mask;
-	info.align_offset = 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
 
_

Patches currently in -mm which might be from deller@gmx.de are

ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch

