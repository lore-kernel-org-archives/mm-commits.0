From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 109/118] fs/binfmt_elf.c: coredump: delete
 duplicated overflow check
Date: Thu, 30 Jan 2020 22:17:07 -0800
Message-ID: <20200131061707.ZBLDkEugH%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:08 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
