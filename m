From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-move-get_vmalloc_info-to-vmallocc.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:22 -0700
Message-ID: <20130430184722.98CDF5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62042 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3D3SrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:24 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so84972vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: move get_vmalloc_info() to vmalloc.c
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-get_vmalloc_info-to-vmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: move get_vmalloc_info() to vmalloc.c

Now get_vmalloc_info() is in fs/proc/mmu.c.  There is no reason that this
code must be here and it's implementation needs vmlist_lock and it iterate
a vmlist which may be internal data structure for vmalloc.

It is preferable that vmlist_lock and vmlist is only used in vmalloc.c
for maintainability. So move the code to vmalloc.c

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile        |    2 -
 fs/proc/internal.h      |   18 -----------
 fs/proc/meminfo.c       |    1 
 fs/proc/mmu.c           |   60 --------------------------------------
 include/linux/vmalloc.h |   18 +++++++++++
 mm/vmalloc.c            |   44 +++++++++++++++++++++++++++
 6 files changed, 64 insertions(+), 79 deletions(-)

diff -puN fs/proc/Makefile~mm-vmalloc-move-get_vmalloc_info-to-vmallocc fs/proc/Makefile
--- a/fs/proc/Makefile~mm-vmalloc-move-get_vmalloc_info-to-vmallocc
+++ a/fs/proc/Makefile
@@ -5,7 +5,7 @@
 obj-y   += proc.o
 
 proc-y			:= nommu.o task_nommu.o
-proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
+proc-$(CONFIG_MMU)	:= task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
 		fd.o
diff -puN fs/proc/internal.h~mm-vmalloc-move-get_vmalloc_info-to-vmallocc fs/proc/internal.h
--- a/fs/proc/internal.h~mm-vmalloc-move-get_vmalloc_info-to-vmallocc
+++ a/fs/proc/internal.h
@@ -30,24 +30,6 @@ extern int proc_net_init(void);
 static inline int proc_net_init(void) { return 0; }
 #endif
 
-struct vmalloc_info {
-	unsigned long	used;
-	unsigned long	largest_chunk;
-};
-
-#ifdef CONFIG_MMU
-#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
-extern void get_vmalloc_info(struct vmalloc_info *vmi);
-#else
-
-#define VMALLOC_TOTAL 0UL
-#define get_vmalloc_info(vmi)			\
-do {						\
-	(vmi)->used = 0;			\
-	(vmi)->largest_chunk = 0;		\
-} while(0)
-#endif
-
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
diff -puN fs/proc/meminfo.c~mm-vmalloc-move-get_vmalloc_info-to-vmallocc fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-vmalloc-move-get_vmalloc_info-to-vmallocc
+++ a/fs/proc/meminfo.c
@@ -11,6 +11,7 @@
 #include <linux/swap.h>
 #include <linux/vmstat.h>
 #include <linux/atomic.h>
+#include <linux/vmalloc.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include "internal.h"
diff -puN fs/proc/mmu.c~mm-vmalloc-move-get_vmalloc_info-to-vmallocc /dev/null
--- a/fs/proc/mmu.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/* mmu.c: mmu memory info files
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#include <linux/spinlock.h>
-#include <linux/vmalloc.h>
-#include <linux/highmem.h>
-#include <asm/pgtable.h>
-#include "internal.h"
-
-void get_vmalloc_info(struct vmalloc_info *vmi)
-{
-	struct vm_struct *vma;
-	unsigned long free_area_size;
-	unsigned long prev_end;
-
-	vmi->used = 0;
-
-	if (!vmlist) {
-		vmi->largest_chunk = VMALLOC_TOTAL;
-	}
-	else {
-		vmi->largest_chunk = 0;
-
-		prev_end = VMALLOC_START;
-
-		read_lock(&vmlist_lock);
-
-		for (vma = vmlist; vma; vma = vma->next) {
-			unsigned long addr = (unsigned long) vma->addr;
-
-			/*
-			 * Some archs keep another range for modules in vmlist
-			 */
-			if (addr < VMALLOC_START)
-				continue;
-			if (addr >= VMALLOC_END)
-				break;
-
-			vmi->used += vma->size;
-
-			free_area_size = addr - prev_end;
-			if (vmi->largest_chunk < free_area_size)
-				vmi->largest_chunk = free_area_size;
-
-			prev_end = vma->size + addr;
-		}
-
-		if (VMALLOC_END - prev_end > vmi->largest_chunk)
-			vmi->largest_chunk = VMALLOC_END - prev_end;
-
-		read_unlock(&vmlist_lock);
-	}
-}
diff -puN include/linux/vmalloc.h~mm-vmalloc-move-get_vmalloc_info-to-vmallocc include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-move-get_vmalloc_info-to-vmallocc
+++ a/include/linux/vmalloc.h
@@ -158,4 +158,22 @@ pcpu_free_vm_areas(struct vm_struct **vm
 # endif
 #endif
 
+struct vmalloc_info {
+	unsigned long   used;
+	unsigned long   largest_chunk;
+};
+
+#ifdef CONFIG_MMU
+#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
+extern void get_vmalloc_info(struct vmalloc_info *vmi);
+#else
+
+#define VMALLOC_TOTAL 0UL
+#define get_vmalloc_info(vmi)			\
+do {						\
+	(vmi)->used = 0;			\
+	(vmi)->largest_chunk = 0;		\
+} while (0)
+#endif
+
 #endif /* _LINUX_VMALLOC_H */
diff -puN mm/vmalloc.c~mm-vmalloc-move-get_vmalloc_info-to-vmallocc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-move-get_vmalloc_info-to-vmallocc
+++ a/mm/vmalloc.c
@@ -2645,5 +2645,49 @@ static int __init proc_vmalloc_init(void
 	return 0;
 }
 module_init(proc_vmalloc_init);
+
+void get_vmalloc_info(struct vmalloc_info *vmi)
+{
+	struct vm_struct *vma;
+	unsigned long free_area_size;
+	unsigned long prev_end;
+
+	vmi->used = 0;
+
+	if (!vmlist) {
+		vmi->largest_chunk = VMALLOC_TOTAL;
+	} else {
+		vmi->largest_chunk = 0;
+
+		prev_end = VMALLOC_START;
+
+		read_lock(&vmlist_lock);
+
+		for (vma = vmlist; vma; vma = vma->next) {
+			unsigned long addr = (unsigned long) vma->addr;
+
+			/*
+			 * Some archs keep another range for modules in vmlist
+			 */
+			if (addr < VMALLOC_START)
+				continue;
+			if (addr >= VMALLOC_END)
+				break;
+
+			vmi->used += vma->size;
+
+			free_area_size = addr - prev_end;
+			if (vmi->largest_chunk < free_area_size)
+				vmi->largest_chunk = free_area_size;
+
+			prev_end = vma->size + addr;
+		}
+
+		if (VMALLOC_END - prev_end > vmi->largest_chunk)
+			vmi->largest_chunk = VMALLOC_END - prev_end;
+
+		read_unlock(&vmlist_lock);
+	}
+}
 #endif
 
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

