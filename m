Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01040C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjG0RG6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjG0RG5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4266A9E
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 10:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4F6161EEF
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 17:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35187C433C8;
        Thu, 27 Jul 2023 17:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477615;
        bh=jj+JrrpveI5sRW37Hje9tfIAT7kLZAzTvJ0hR9zYI30=;
        h=Date:To:From:Subject:From;
        b=E2UqZFJdCPGIvMViqvS2b1yTp2VuiZAoU+UY+Z/3CauvVcUED+51WzgPD+Gc3OnjR
         NwqYozl1BhTIOwlQEEsORJOGGMSaQ9e+tnKheepUncWMS3ZA19xWR0XpHK7iYD5WQZ
         y0HxNO1vzun15kwnOrH2tNZuoVwcUZXMUYY2SM08=
Date:   Thu, 27 Jul 2023 10:06:54 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + a.patch added to mm-unstable branch
Message-Id: <20230727170655.35187C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix some kernel-doc comments
has been added to the -mm mm-unstable branch.  Its filename is
     a.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/a.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/memory.c: fix some kernel-doc comments
Date: Thu, 27 Jul 2023 09:55:58 +0800

Add description of @mas and @tree_end, remove @mt in unmap_vmas().  to
silence the warnings:

mm/memory.c:1837: warning: Function parameter or member 'mas' not described in 'unmap_vmas'
mm/memory.c:1837: warning: Function parameter or member 'tree_end' not described in 'unmap_vmas'
mm/memory.c:1837: warning: Excess function parameter 'mt' description in 'unmap_vmas'

Link: https://lkml.kernel.org/r/20230727015558.69554-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5996
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~a
+++ a/mm/memory.c
@@ -1825,10 +1825,11 @@ static void unmap_single_vma(struct mmu_
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
- * @mt: the maple tree
+ * @mas: the maple state
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
+ * @tree_end: The maximum index to check
  * @mm_wr_locked: lock flag
  *
  * Unmap all pages in the vma list.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-fix-some-kernel-doc-comments.patch
a.patch

