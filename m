From: akpm@linux-foundation.org
Subject: + powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:16:07 -0800
Message-ID: <200712042016.lB4KG7LC002971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbXLDUQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chombourger@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     powerpc: invalid size for swapper_pg_dir with CONFIG_PTE_64BIT=y
has been added to the -mm tree.  Its filename is
     powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: invalid size for swapper_pg_dir with CONFIG_PTE_64BIT=y
From: "Cedric Hombourger" <chombourger@gmail.com>

The size of swapper_pg_dir is 8k instead of 4k when using 64-bit PTEs
(CONFIG_PTE_64BIT).  Checked by printing the size of this variable from C
code.  Kernel successfuly transferred control to init with this change
while it was crashing in map_page() before.

Signed-off-by: Cedric Hombourger <chombourger@gmail.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/head_fsl_booke.S |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/head_fsl_booke.S~powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y arch/powerpc/kernel/head_fsl_booke.S
--- a/arch/powerpc/kernel/head_fsl_booke.S~powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y
+++ a/arch/powerpc/kernel/head_fsl_booke.S
@@ -1035,7 +1035,11 @@ empty_zero_page:
 	.space	4096
 	.globl	swapper_pg_dir
 swapper_pg_dir:
-	.space	4096
+#ifdef CONFIG_PTE_64BIT
+	.space  8192
+#else
+	.space  4096
+#endif
 
 /* Reserved 4k for the critical exception stack & 4k for the machine
  * check stack per CPU for kernel mode exceptions */
_

Patches currently in -mm which might be from chombourger@gmail.com are

powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch
