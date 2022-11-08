Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85772C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiKHX6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKHX6N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638F46034D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C2A617E4
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522C8C433D6;
        Tue,  8 Nov 2022 23:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951890;
        bh=far7+cxKyHkkm1b7WbHFqz4exeAN6mPwB2soqiASQz0=;
        h=Date:To:From:Subject:From;
        b=c1nEuNbIDoDwwtSjwtJXC/jtuusnZ88XFG1Hf0Tx4nrokAwnxvBQ2kSeZbS5jqF5k
         pm9hY8oMjVpLYlFVql2hj/ddHILzR/qy5kaLZ8k0HbHivWroC+N2M5upVSULehfE1P
         jSSMpZTuy2rUphWhAX5L+uVK6Kp4GGWDpwdq4V4w=
Date:   Tue, 08 Nov 2022 15:58:09 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        lizetao1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-fix-memory-leak-in-mmap_region.patch removed from -mm tree
Message-Id: <20221108235810.522C8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: fix memory leak in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-memory-leak-in-mmap_region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zetao <lizetao1@huawei.com>
Subject: mm/mmap: fix memory leak in mmap_region()
Date: Fri, 28 Oct 2022 15:37:17 +0800

There is a memory leak reported by kmemleak:

  unreferenced object 0xffff88817231ce40 (size 224):
    comm "mount.cifs", pid 19308, jiffies 4295917571 (age 405.880s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      60 c0 b2 00 81 88 ff ff 98 83 01 42 81 88 ff ff  `..........B....
    backtrace:
      [<ffffffff81936171>] __alloc_file+0x21/0x250
      [<ffffffff81937051>] alloc_empty_file+0x41/0xf0
      [<ffffffff81937159>] alloc_file+0x59/0x710
      [<ffffffff81937964>] alloc_file_pseudo+0x154/0x210
      [<ffffffff81741dbf>] __shmem_file_setup+0xff/0x2a0
      [<ffffffff817502cd>] shmem_zero_setup+0x8d/0x160
      [<ffffffff817cc1d5>] mmap_region+0x1075/0x19d0
      [<ffffffff817cd257>] do_mmap+0x727/0x1110
      [<ffffffff817518b2>] vm_mmap_pgoff+0x112/0x1e0
      [<ffffffff83adf955>] do_syscall_64+0x35/0x80
      [<ffffffff83c0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

The root cause was traced to an error handing path in mmap_region() when
arch_validate_flags() or mas_preallocate() fails.  In the shared anonymous
mapping sence, vma will be setuped and mapped with a new shared anonymous
file via shmem_zero_setup().  So in this case, the file resource needs to
be released.

Fix it by calling fput(vma->vm_file) and unmap_region() when
arch_validate_flags() or mas_preallocate() returns an error in the shared
anonymous mapping sence.

Link: https://lkml.kernel.org/r/20221028073717.1179380-1-lizetao1@huawei.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Fixes: c462ac288f2c ("mm: Introduce arch_validate_flags()")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-memory-leak-in-mmap_region
+++ a/mm/mmap.c
@@ -2674,6 +2674,8 @@ cannot_expand:
 		error = -EINVAL;
 		if (file)
 			goto close_and_free_vma;
+		else if (vma->vm_file)
+			goto unmap_and_free_vma;
 		else
 			goto free_vma;
 	}
@@ -2682,6 +2684,8 @@ cannot_expand:
 		error = -ENOMEM;
 		if (file)
 			goto close_and_free_vma;
+		else if (vma->vm_file)
+			goto unmap_and_free_vma;
 		else
 			goto free_vma;
 	}
@@ -2751,7 +2755,7 @@ unmap_and_free_vma:
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, mas.tree, vma, prev, next, vma->vm_start, vma->vm_end);
-	if (vm_flags & VM_SHARED)
+	if (file && (vm_flags & VM_SHARED))
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
 	vm_area_free(vma);
_

Patches currently in -mm which might be from lizetao1@huawei.com are


