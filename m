From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 104/118] fs/binfmt_elf.c: fix ->start_code
 calculation
Date: Thu, 30 Jan 2020 22:16:52 -0800
Message-ID: <20200131061652.8dMCZIWC2%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGQy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:16:54 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
