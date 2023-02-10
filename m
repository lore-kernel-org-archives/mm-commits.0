Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5AAC636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjBJAx4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjBJAxo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB476F22F
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC6AB8239A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DF8C433D2;
        Fri, 10 Feb 2023 00:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990380;
        bh=0ZZS0zJb3pGTtqgZn2wrCoCNdwG/tFgRzZTXZA3/6As=;
        h=Date:To:From:Subject:From;
        b=ZVs8PGeyJp5CxkLXo2iz4dYMqDe4OuBAsGBxndcpqEisvwXOtHze51dJeFOsW+1o5
         QykeufbVA2e0ozB3NQ9ADuBPgPjdBPEKbc2CVdGXiDPQ8Czp9pEkBNCKRzYV0MzoOV
         +He1HYGRiepw3D4/SKyVoHW0EmPOAAl1PiL9buTQ=
Date:   Thu, 09 Feb 2023 16:52:59 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-use-vmi-version-of-vma_merge.patch removed from -mm tree
Message-Id: <20230210005300.33DF8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: use vmi version of vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-vmi-version-of-vma_merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mremap: use vmi version of vma_merge()
Date: Fri, 20 Jan 2023 11:26:27 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-27-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vmi-version-of-vma_merge
+++ a/mm/mremap.c
@@ -1018,6 +1018,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			unsigned long extension_end = addr + new_len;
 			pgoff_t extension_pgoff = vma->vm_pgoff +
 				((extension_start - vma->vm_start) >> PAGE_SHIFT);
+			VMA_ITERATOR(vmi, mm, extension_start);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
@@ -1042,10 +1043,12 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			 * when a vma would be actually removed due to a merge.
 			 */
 			if (!vma->vm_ops || !vma->vm_ops->close) {
-				vma = vma_merge(mm, vma, extension_start, extension_end,
-					vma->vm_flags, vma->anon_vma, vma->vm_file,
-					extension_pgoff, vma_policy(vma),
-					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+				vma = vmi_vma_merge(&vmi, mm, vma,
+				       extension_start, extension_end,
+				       vma->vm_flags, vma->anon_vma,
+				       vma->vm_file, extension_pgoff,
+				       vma_policy(vma), vma->vm_userfaultfd_ctx,
+				       anon_vma_name(vma));
 			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
 				   vma->vm_pgoff, NULL)) {
 				vma = NULL;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


