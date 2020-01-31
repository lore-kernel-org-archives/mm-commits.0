From: akpm@linux-foundation.org
Subject: [merged]
 elf-coredump-delete-duplicated-overflow-check.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:20:54 -0800
Message-ID: <20200131232054.8gLuWwRr7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgAaXUz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: coredump: delete duplicated overflow check
has been removed from the -mm tree.  Its filename was
     elf-coredump-delete-duplicated-overflow-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: coredump: delete duplicated overflow check

array_size() macro will do overflow check anyway.

Link: http://lkml.kernel.org/r/20191222144009.GB24341@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/binfmt_elf.c~elf-coredump-delete-duplicated-overflow-check
+++ a/fs/binfmt_elf.c
@@ -2257,8 +2257,6 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	if (segs - 1 > ULONG_MAX / sizeof(*vma_filesz))
-		goto end_coredump;
 	vma_filesz = kvmalloc(array_size(sizeof(*vma_filesz), (segs - 1)),
 			      GFP_KERNEL);
 	if (ZERO_OR_NULL_PTR(vma_filesz))
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-decouple-proc-from-vfs-with-struct-proc_ops.patch
proc-convert-everything-to-struct-proc_ops.patch
