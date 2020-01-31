From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 107/118] fs/binfmt_elf.c: make BAD_ADDR() unlikely
Date: Thu, 30 Jan 2020 22:17:01 -0800
Message-ID: <20200131061701.HImshoCG3%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:03 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
