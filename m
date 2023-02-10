Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5B5C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjBJAzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBJAy2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D95721E9
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F2261BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921B3C433EF;
        Fri, 10 Feb 2023 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990411;
        bh=NVRTCj+bcxIzDXPFAKVwxmfwSWVI3TkkcFuD7QV9iro=;
        h=Date:To:From:Subject:From;
        b=lToqv+D38r3Jb3XUuVpLfcDEBkHki0kEHLAp34ZvG+NxqMKNlny1BxBvcqkcT5QJk
         Ld5y250Uf+9kXlKn3HeBkUXdW6oCjJJ6LrQuUMQ5/g/tcgMEYrtXRW3aFp/2KFQ6+a
         JyC8Hw8jbAs3GkY5VoE9kgvYwwv9AqQCSYY8lWzI=
Date:   Thu, 09 Feb 2023 16:53:31 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch removed from -mm tree
Message-Id: <20230210005331.921B3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: convert do_brk_flags() to use vma_prepare() and vma_complete()
has been removed from the -mm tree.  Its filename was
     mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: convert do_brk_flags() to use vma_prepare() and vma_complete()
Date: Fri, 20 Jan 2023 11:26:48 -0500

Use the abstracted vma locking for do_brk_flags()

Link: https://lkml.kernel.org/r/20230120162650.984577-48-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete
+++ a/mm/mmap.c
@@ -2936,6 +2936,7 @@ static int do_brk_flags(struct vma_itera
 		unsigned long addr, unsigned long len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vma_prepare vp;
 
 	validate_mm_mt(mm);
 	/*
@@ -2963,18 +2964,13 @@ static int do_brk_flags(struct vma_itera
 			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
-		if (vma->anon_vma) {
-			anon_vma_lock_write(vma->anon_vma);
-			anon_vma_interval_tree_pre_update_vma(vma);
-		}
+		init_vma_prep(&vp, vma);
+		vma_prepare(&vp);
 		vma->vm_end = addr + len;
 		vma->vm_flags |= VM_SOFTDIRTY;
 		vma_iter_store(vmi, vma);
 
-		if (vma->anon_vma) {
-			anon_vma_interval_tree_post_update_vma(vma);
-			anon_vma_unlock_write(vma->anon_vma);
-		}
+		vma_complete(&vp, vmi, mm);
 		khugepaged_enter_vma(vma, flags);
 		goto out;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


