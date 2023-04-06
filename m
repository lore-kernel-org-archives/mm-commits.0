Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C63AC77B74
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjDFCgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbjDFCfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:35:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAB35BA0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634EB62D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF0FC433D2;
        Thu,  6 Apr 2023 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748553;
        bh=Gh2RJRuxiejNQ3EU8TaoT5PMs1FaoZBTzuun7L7qffc=;
        h=Date:To:From:Subject:From;
        b=sDjwxitBmlHUZDmjDDOZPbUc/nKSL3A/hu41QjxuFITcLDXlp27FCAKbGdoW3pndr
         LqGnLmXVaAkGsb1zOgVLZMSqz5N8tbtY9S2RuhxKMQNcsRekZvrkWT2oZOIH+vneEo
         VsL7VPsFFs4tATMlPm034DiIupT+KzWXg/X7I28A=
Date:   Wed, 05 Apr 2023 19:35:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch removed from -mm tree
Message-Id: <20230406023553.BBF0FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.
has been removed from the -mm tree.  Its filename was
     mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch

This patch was dropped because it was folded into mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.

adjust comment as suggested by Lorenzo

Link: https://lkml.kernel.org/r/74f2ea6c-f1a9-6dd7-260c-25e660f42379@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix
+++ a/mm/mmap.c
@@ -755,8 +755,8 @@ int vma_shrink(struct vma_iterator *vmi,
 
 /*
  * If the vma has a ->close operation then the driver probably needs to release
- * per-vma resources, so we don't attempt to merge those in case the caller
- * indicates the current vma may be removed as part of the merge.
+ * per-vma resources, so we don't attempt to merge those if the caller indicates
+ * the current vma may be removed as part of the merge.
  */
 static inline bool is_mergeable_vma(struct vm_area_struct *vma,
 		struct file *file, unsigned long vm_flags,
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mremap-simplify-vma-expansion-again.patch
mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

