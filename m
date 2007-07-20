From: akpm@linux-foundation.org
Subject: + fs-proc-mmuc-headers-butchery.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:09:22 -0700
Message-ID: <200707200109.l6K19Mrb032473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759782AbXGTBJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     fs/proc/mmu.c: headers butchery
has been added to the -mm tree.  Its filename is
     fs-proc-mmuc-headers-butchery.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/proc/mmu.c: headers butchery
From: Alexey Dobriyan <adobriyan@gmail.com>

fs/proc/mmu.c consists of only one function which uses only:
1) struct vmalloc_info *
2) struct vm_struct *
3) struct vmalloc_info
4) vmlist
5) VMALLOC_TOTAL, VMALLOC_START, VMALLOC_END
6) read_lock, read_unlock
7) vmlist_lock
8) struct vm_struct

This gives us linux/spinlock.h, asm/pgtable.h, "internal.h", linux/vmalloc.h.
asm/pgtable.h uses PKMAP_BASE on i386, for which asm/highmem.h is needed.
But, linux/highmem.h is actually used to make it compile everywhere.
I'll deal later with this particular i386 surprise.

Cross-compile tested on many archs and configs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/mmu.c |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff -puN fs/proc/mmu.c~fs-proc-mmuc-headers-butchery fs/proc/mmu.c
--- a/fs/proc/mmu.c~fs-proc-mmuc-headers-butchery
+++ a/fs/proc/mmu.c
@@ -8,27 +8,10 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/time.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/mman.h>
-#include <linux/proc_fs.h>
-#include <linux/mm.h>
-#include <linux/mmzone.h>
-#include <linux/pagemap.h>
-#include <linux/swap.h>
-#include <linux/slab.h>
-#include <linux/smp.h>
-#include <linux/seq_file.h>
-#include <linux/hugetlb.h>
+#include <linux/spinlock.h>
 #include <linux/vmalloc.h>
-#include <asm/uaccess.h>
+#include <linux/highmem.h>
 #include <asm/pgtable.h>
-#include <asm/tlb.h>
-#include <asm/div64.h>
 #include "internal.h"
 
 void get_vmalloc_info(struct vmalloc_info *vmi)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
revert-faster-ext2_clear_inode.patch
