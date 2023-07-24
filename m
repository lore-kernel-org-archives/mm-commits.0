Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B89CEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjGXTHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjGXTGz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A429D19AF
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:06:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A7D61316
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C54CC433C7;
        Mon, 24 Jul 2023 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225599;
        bh=UsJylffnOkAYzZVNh6errWkPTouwmFt2wAv5wf3ik98=;
        h=Date:To:From:Subject:From;
        b=ZCQ+zzAtjGhjg1CycOgB/3bjLHzUuccgZdfIitHuzkfQpjusXrbBDDzdohg5uxQRc
         MTeQD7Vu+ZTQ8IYbArVwarK1yP0gWpOSt/r/Bcpjibx1jZkOw3kCYrVkR84+ZGuqV9
         0RCWyBVOBgqwBbk5yZjM/nYkdgOc+YyB4janM4OM=
Date:   Mon, 24 Jul 2023 12:06:38 -0700
To:     mm-commits@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        jirislaby@kernel.org, axboe@kernel.dk, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch removed from -mm tree
Message-Id: <20230724190639.3C54CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: mmap: consider pgoff when searching for free mapping
has been removed from the -mm tree.  Its filename was
     ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


