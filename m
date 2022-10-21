Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA655C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJUEfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJUEfH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:35:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28FA45F51
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB6CB82A49
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7EC433C1;
        Fri, 21 Oct 2022 04:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326894;
        bh=6WcSYGLAIW5Xd0uHmu4MakzbHdys416yFEx99VcaiKE=;
        h=Date:To:From:Subject:From;
        b=c48d98bV+tOwc54+wwRaqDRG9GzgfYXP1D9Go/YEVZP0RXBN+Ada7QLp8dMO7GBjh
         oXXMznGJhGOXBIiP33sY/Mb53JulRx1EbxKVCYeqcMr85zcGRdJI18t4PUvlRSE56k
         WuXgIZqi+O9sAG3eqXZJ/oI00dbyFy18RXUGV3t4=
Date:   Thu, 20 Oct 2022 21:34:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        Liam.Howlett@oracle.com, adobriyan@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-proc-pid-smaps_rollup-fix-maple-tree-search.patch removed from -mm tree
Message-Id: <20221021043454.17A7EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: /proc/pid/smaps_rollup: fix maple tree search
has been removed from the -mm tree.  Its filename was
     mm-proc-pid-smaps_rollup-fix-maple-tree-search.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: /proc/pid/smaps_rollup: fix maple tree search
Date: Tue, 18 Oct 2022 20:18:38 -0700 (PDT)

/proc/pid/smaps_rollup showed 0 kB for everything: now find first vma.

Link: https://lkml.kernel.org/r/3011bee7-182-97a2-1083-d5f5b688e54b@google.com
Fixes: c4c84f06285e ("fs/proc/task_mmu: stop using linked list and highest_vm_end")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
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


