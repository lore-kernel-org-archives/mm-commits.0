Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E29C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiI0Cxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiI0Cvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2E3FAD8D
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7017A615AA
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6882C433D7;
        Tue, 27 Sep 2022 02:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246967;
        bh=/DFkZhNid/FuUaDbiqbkx2GlDsjp5COi5ZqmjfMrh2Q=;
        h=Date:To:From:Subject:From;
        b=KDob7KQxbZnHFAoWbR3Cipk0J0C/6w/TnQTTq7l3fgyhVBM0P5JyBYQ3e7kHfSDau
         9bauMoxP6h8KqpQ5Zy0O6X/gS7KsxamUNPXXwJ2HRhkUuRv0EpLcs+RO/Ifok3HpeD
         nKtHwdldwHGvcpzEknLGcG0DMUqEHHW3B0u3p/dU=
Date:   Mon, 26 Sep 2022 19:49:27 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-base-use-the-vma-iterators-in-place-of-linked-list.patch removed from -mm tree
Message-Id: <20220927024927.C6882C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/base: use the vma iterators in place of linked list
has been removed from the -mm tree.  Its filename was
     fs-proc-base-use-the-vma-iterators-in-place-of-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: fs/proc/base: use the vma iterators in place of linked list
Date: Tue, 6 Sep 2022 19:48:56 +0000

Use the vma iterator instead of a for loop across the linked list.  The
link list of vmas will be removed in this patch set.

Link: https://lkml.kernel.org/r/20220906194824.2110408-43-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c~fs-proc-base-use-the-vma-iterators-in-place-of-linked-list
+++ a/fs/proc/base.c
@@ -2350,6 +2350,7 @@ proc_map_files_readdir(struct file *file
 	GENRADIX(struct map_files_info) fa;
 	struct map_files_info *p;
 	int ret;
+	struct vma_iterator vmi;
 
 	genradix_init(&fa);
 
@@ -2388,7 +2389,9 @@ proc_map_files_readdir(struct file *file
 	 * routine might require mmap_lock taken in might_fault().
 	 */
 
-	for (vma = mm->mmap, pos = 2; vma; vma = vma->vm_next) {
+	pos = 2;
+	vma_iter_init(&vmi, mm, 0);
+	for_each_vma(vmi, vma) {
 		if (!vma->vm_file)
 			continue;
 		if (++pos <= ctx->pos)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


