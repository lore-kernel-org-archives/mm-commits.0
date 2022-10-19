Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25383C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 05:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJSFE2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 01:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJSFEZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 01:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A7DE83
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E1106173D
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 05:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6235C433D6;
        Wed, 19 Oct 2022 05:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666155862;
        bh=dxdA+rWI4FXs9KFbxfIBssTV2s28yR3I2iBEguCFIUY=;
        h=Date:To:From:Subject:From;
        b=LHtYpt8ZrKJNMVme706hhh0Ljl0mpksOWmV2j5etMwogPP4q+bkhrth0IuqvKuwj+
         rQH4SBtjfRTvjk6i2+AAOlRqBuScJkeRjWB4cfm2Z6DEhyg4vpjWY/KkagOE6yjNfw
         WATgKZjBp6ODPq/99IUiUcgdwW/OZWHnb9p1Tovc=
Date:   Tue, 18 Oct 2022 22:04:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        liam.howlett@oracle.com, adobriyan@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-proc-pid-smaps_rollup-fix-maple-tree-search.patch added to mm-hotfixes-unstable branch
Message-Id: <20221019050422.C6235C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/pid/smaps_rollup: fix maple tree search
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-proc-pid-smaps_rollup-fix-maple-tree-search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-proc-pid-smaps_rollup-fix-maple-tree-search.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: mm: /proc/pid/smaps_rollup: fix maple tree search
Date: Tue, 18 Oct 2022 20:18:38 -0700 (PDT)

/proc/pid/smaps_rollup showed 0 kB for everything: now find first vma.

Link: https://lkml.kernel.org/r/3011bee7-182-97a2-1083-d5f5b688e54b@google.com
Fixes: c4c84f06285e ("fs/proc/task_mmu: stop using linked list and highest_vm_end")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~mm-proc-pid-smaps_rollup-fix-maple-tree-search
+++ a/fs/proc/task_mmu.c
@@ -902,7 +902,7 @@ static int show_smaps_rollup(struct seq_
 		goto out_put_mm;
 
 	hold_task_mempolicy(priv);
-	vma = mas_find(&mas, 0);
+	vma = mas_find(&mas, ULONG_MAX);
 
 	if (unlikely(!vma))
 		goto empty_set;
_

Patches currently in -mm which might be from hughd@google.com are

mm-proc-pid-smaps_rollup-fix-maple-tree-search.patch

