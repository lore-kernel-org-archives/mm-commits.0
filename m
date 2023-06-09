Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646CDC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjFIXaM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjFIX2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B913F3C39
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 500C765CF3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7200C433D2;
        Fri,  9 Jun 2023 23:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353298;
        bh=yUXnne9P4X0JV9xsauE6Scz+AwxsS4wftCWvshILls8=;
        h=Date:To:From:Subject:From;
        b=YOLumOGVmfrQnTZMZx7TXdqlUyDvkYFww+8XLfACdK2+LYizpx2nwZK4Q5FD7G9jy
         5MtNZiqd4ljrd/8LeU+pdwDKruoYP2BZksB8XwBTK1jgLjMFTBjgFvtUI3WZD8r0cG
         P2C9cpsS75F7mI2RieeRKfuq7VWODPdoRGCEBdR8=
Date:   Fri, 09 Jun 2023 16:28:18 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch removed from -mm tree
Message-Id: <20230609232818.A7200C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: use MAS_WR_BUG_ON() in mas_store_prealloc()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: use MAS_WR_BUG_ON() in mas_store_prealloc()
Date: Thu, 18 May 2023 10:55:22 -0400

mas_store_prealloc() should never fail, but if it does due to internal
tree issues then get as much debug information as possible prior to
crashing the kernel.

Link: https://lkml.kernel.org/r/20230518145544.1722059-14-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc
+++ a/lib/maple_tree.c
@@ -5756,7 +5756,7 @@ void mas_store_prealloc(struct ma_state
 	mas_wr_store_setup(&wr_mas);
 	trace_ma_write(__func__, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
-	BUG_ON(mas_is_err(mas));
+	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
 	mas_destroy(mas);
 }
 EXPORT_SYMBOL_GPL(mas_store_prealloc);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

