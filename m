Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E53C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjFIXbF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjFIX3E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7DD3584
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A9F465CF1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD5EC433EF;
        Fri,  9 Jun 2023 23:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353322;
        bh=YUHPJnTj9Cu3P5wH8HUp5eLNeYkC6VJ6rFP5j6UaGhw=;
        h=Date:To:From:Subject:From;
        b=BpzgnXBat9G7bjVjhO4ThFvorvF97M+SGs2Xc7fdKVatMBX2EBLv7ufyJrGeo4Csn
         YfAXZyV8ycQu6fGz1SxSFHNK/94fOIaBq5jG/+Bf1sTrGnxVaKGlRpTYaoBrUgagf+
         GE1nNjhd2lgXg+WLT9IOegy4CFgWox7EKx65+/Pw=
Date:   Fri, 09 Jun 2023 16:28:42 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch removed from -mm tree
Message-Id: <20230609232842.ACD5EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: clear up index and last setting in single entry tree
has been removed from the -mm tree.  Its filename was
     maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: clear up index and last setting in single entry tree
Date: Thu, 18 May 2023 10:55:41 -0400

When there is a single entry tree (range of 0-0 pointing to an entry),
then ensure the limit is either 0-0 or 1-oo, depending on where the user
walks.  Ensure the correct node setting as well; either MAS_ROOT or
MAS_NONE.

Link: https://lkml.kernel.org/r/20230518145544.1722059-33-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clear-up-index-and-last-setting-in-single-entry-tree
+++ a/lib/maple_tree.c
@@ -5023,24 +5023,25 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	if (mas_is_none(mas) || mas_is_paused(mas) || mas_is_ptr(mas))
+		mas->node = MAS_START;
 retry:
 	entry = mas_state_walk(mas);
-	if (mas_is_start(mas))
+	if (mas_is_start(mas)) {
 		goto retry;
-
-	if (mas_is_ptr(mas)) {
+	} else if (mas_is_none(mas)) {
+		mas->index = 0;
+		mas->last = ULONG_MAX;
+	} else if (mas_is_ptr(mas)) {
 		if (!mas->index) {
 			mas->last = 0;
-		} else {
-			mas->index = 1;
-			mas->last = ULONG_MAX;
+			return entry;
 		}
-		return entry;
-	}
 
-	if (mas_is_none(mas)) {
-		mas->index = 0;
+		mas->index = 1;
 		mas->last = ULONG_MAX;
+		mas->node = MAS_NONE;
+		return NULL;
 	}
 
 	return entry;
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

