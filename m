Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3A8C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbjDFDEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbjDFDDv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8611A9747
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4446403D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760BCC433D2;
        Thu,  6 Apr 2023 03:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750221;
        bh=69JjmJOC5QXDTRdegH4XrCnFzqsJi3l4X8DxeiCsx3c=;
        h=Date:To:From:Subject:From;
        b=zwMIpKFFjjrQvAfK3kcwNkPz9Ujob7oUp98Kgh7OYj0xJCuQ/msf4gzXntqAw5Acs
         W0yM/LYnIP5lMFx/TKb3uqvNtSXW8fPQs5u4qVfhW/qkc2i6ifIQ81Q5gfgOhQBhlZ
         4m0GDSd4JlbKIbljcgPympoLRtLy18YeZh+XOt/M=
Date:   Wed, 05 Apr 2023 20:03:40 -0700
To:     mm-commits@vger.kernel.org, laurent.dufour@fr.ibm.com,
        42.hyeyoo@gmail.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range.patch removed from -mm tree
Message-Id: <20230406030341.760BCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: write-lock VMA while remapping it to a new address range
has been removed from the -mm tree.  Its filename was
     mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mremap: write-lock VMA while remapping it to a new address range
Date: Mon, 27 Feb 2023 09:36:16 -0800

Write-lock VMA as locked before copying it and when copy_vma produces a
new VMA.

Link: https://lkml.kernel.org/r/20230227173632.3292573-18-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Laurent Dufour <laurent.dufour@fr.ibm.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c   |    1 +
 mm/mremap.c |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/mmap.c~mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range
+++ a/mm/mmap.c
@@ -3197,6 +3197,7 @@ struct vm_area_struct *copy_vma(struct v
 			get_file(new_vma->vm_file);
 		if (new_vma->vm_ops && new_vma->vm_ops->open)
 			new_vma->vm_ops->open(new_vma);
+		vma_start_write(new_vma);
 		if (vma_link(mm, new_vma))
 			goto out_vma_link;
 		*need_rmap_locks = false;
--- a/mm/mremap.c~mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range
+++ a/mm/mremap.c
@@ -623,6 +623,7 @@ static unsigned long move_vma(struct vm_
 			return -ENOMEM;
 	}
 
+	vma_start_write(vma);
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
 			   &need_rmap_locks);
_

Patches currently in -mm which might be from surenb@google.com are


