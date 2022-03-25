Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C9DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357378AbiCYBdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357430AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAB9BF01F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 483AE61947
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9C2C340EC;
        Fri, 25 Mar 2022 01:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171866;
        bh=T4IvWXLCADV7aD0ZfUZURVntjjomonqvgwtsLdPKkHo=;
        h=Date:To:From:Subject:From;
        b=MURIaUgam2pF21frjXm5hwViuBsBWLYeusmx9WjmNj1s+ZHJ/8cxk3sph4ijIT84+
         i926Cx2SN11+ZQ2j86PKrPrUMT0Sw38wwzM46R30+HAKPn8Q+YYB7Zlni5EdepwVEK
         QqQCI5sd5QZwTUc/59OeYVNLfV7MuUB0P406fffc=
Date:   Thu, 24 Mar 2022 18:31:06 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch removed from -mm tree
Message-Id: <20220325013106.9C9C2C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: remove obsolete comment in ksys_mmap_pgoff
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmap: remove obsolete comment in ksys_mmap_pgoff

RLIMIT_MEMLOCK is already reimplemented on top of ucounts now.  And since
commit 83c1fd763b32 ("mm,hugetlb: remove mlock ulimit for SHM_HUGETLB"),
mlock ulimit for SHM_HUGETLB is further removed.  So we should remove this
obsolete comment.

Link: https://lkml.kernel.org/r/20220309090623.13036-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1616,8 +1616,6 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
-		 * A dummy user value is used because we are not locking
-		 * memory so no accounting is necessary
 		 */
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 				VM_NORESERVE,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

