From: akpm@linux-foundation.org
Subject: [merged] elf-make-bad_addr-unlikely.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:20:50 -0800
Message-ID: <20200131232050.wcLZglgKo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXUw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: make BAD_ADDR() unlikely
has been removed from the -mm tree.  Its filename was
     elf-make-bad_addr-unlikely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: make BAD_ADDR() unlikely

If some mapping goes past TASK_SIZE it will be rejected by kernel which
means no such userspace binaries exist.

Mark every such check as unlikely.

Link: http://lkml.kernel.org/r/20191215124355.GA21124@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~elf-make-bad_addr-unlikely
+++ a/fs/binfmt_elf.c
@@ -97,7 +97,7 @@ static struct linux_binfmt elf_format =
 	.min_coredump	= ELF_EXEC_PAGESIZE,
 };
 
-#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
+#define BAD_ADDR(x) (unlikely((unsigned long)(x) >= TASK_SIZE))
 
 static int set_brk(unsigned long start, unsigned long end, int prot)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-decouple-proc-from-vfs-with-struct-proc_ops.patch
proc-convert-everything-to-struct-proc_ops.patch
