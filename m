From: akpm@linux-foundation.org
Subject: [merged] elf-fix-start_code-calculation.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:20:44 -0800
Message-ID: <20200131232044.BW9OZG_HR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXUq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: fix ->start_code calculation
has been removed from the -mm tree.  Its filename was
     elf-fix-start_code-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: fix ->start_code calculation

Only executable segments should be accounted to ->start_code just like
they do to ->end_code (correctly).

Link: http://lkml.kernel.org/r/20191208171410.GB19716@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~elf-fix-start_code-calculation
+++ a/fs/binfmt_elf.c
@@ -999,7 +999,7 @@ out_free_interp:
 			}
 		}
 		k = elf_ppnt->p_vaddr;
-		if (k < start_code)
+		if ((elf_ppnt->p_flags & PF_X) && k < start_code)
 			start_code = k;
 		if (start_data < k)
 			start_data = k;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-decouple-proc-from-vfs-with-struct-proc_ops.patch
proc-convert-everything-to-struct-proc_ops.patch
