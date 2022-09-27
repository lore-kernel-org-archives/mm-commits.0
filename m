Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C92C6FA90
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiI0CyI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiI0CwV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:52:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2026564
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C397C615B5
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE00C433D7;
        Tue, 27 Sep 2022 02:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246978;
        bh=T2wJLjxCVpRhO8v55Ox05F7k+Rk9QvDJYjBnhlsBY6s=;
        h=Date:To:From:Subject:From;
        b=taZ6sg503Jy1wSvwYGfT9ZouA9OEJqIlwKHpy9r+VFCRDwjTe+wbF/f+H0ZYJ4AIl
         bBzm5Zaxc/LF7dD9MVSQYjuhYvlmIrxkGIjHnsdjNjQ1WY1kUnLXtON1mTXYiBQ/mi
         CFe0WMZtUMgx/dyNEK1bYJUL8uYXvoaFx3eha3LA=
Date:   Mon, 26 Sep 2022 19:49:37 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bpf-remove-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024938.2DE00C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bpf: remove VMA linked list
has been removed from the -mm tree.  Its filename was
     bpf-remove-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: bpf: remove VMA linked list
Date: Tue, 6 Sep 2022 19:48:59 +0000

Use vma_next() and remove reference to the start of the linked list

Link: https://lkml.kernel.org/r/20220906194824.2110408-51-Liam.Howlett@oracle.com
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

 kernel/bpf/task_iter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/bpf/task_iter.c~bpf-remove-vma-linked-list
+++ a/kernel/bpf/task_iter.c
@@ -299,8 +299,8 @@ struct bpf_iter_seq_task_vma_info {
 };
 
 enum bpf_task_vma_iter_find_op {
-	task_vma_iter_first_vma,   /* use mm->mmap */
-	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
+	task_vma_iter_first_vma,   /* use find_vma() with addr 0 */
+	task_vma_iter_next_vma,    /* use vma_next() with curr_vma */
 	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
 };
 
@@ -400,10 +400,10 @@ again:
 
 	switch (op) {
 	case task_vma_iter_first_vma:
-		curr_vma = curr_task->mm->mmap;
+		curr_vma = find_vma(curr_task->mm, 0);
 		break;
 	case task_vma_iter_next_vma:
-		curr_vma = curr_vma->vm_next;
+		curr_vma = find_vma(curr_task->mm, curr_vma->vm_end);
 		break;
 	case task_vma_iter_find_vma:
 		/* We dropped mmap_lock so it is necessary to use find_vma
@@ -417,7 +417,7 @@ again:
 		if (curr_vma &&
 		    curr_vma->vm_start == info->prev_vm_start &&
 		    curr_vma->vm_end == info->prev_vm_end)
-			curr_vma = curr_vma->vm_next;
+			curr_vma = find_vma(curr_task->mm, curr_vma->vm_end);
 		break;
 	}
 	if (!curr_vma) {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


