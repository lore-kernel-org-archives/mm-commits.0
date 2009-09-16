From: akpm@linux-foundation.org
Subject: + nommu-add-support-for-memory-protection-units-mpu.patch added to -mm tree
Date: Wed, 16 Sep 2009 15:02:31 -0700
Message-ID: <200909162202.n8GM2VUX015820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbZIPWDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 18:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernds_cb1@t-online.de, cooloney@kernel.org, dhowells@redhat.com, gerg@snapgear.com, vapier@gentoo.org


The patch titled
     nommu: add support for Memory Protection Units (MPU)
has been added to the -mm tree.  Its filename is
     nommu-add-support-for-memory-protection-units-mpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: add support for Memory Protection Units (MPU)
From: Bernd Schmidt <bernds_cb1@t-online.de>

Some architectures (like the Blackfin arch) implement some of the
"simpler" features that one would expect out of a MMU such as memory
protection.

In our case, we actually get read/write/exec protection down to the page
boundary so processes can't stomp on each other let alone the kernel.

There is a performance decrease (which depends greatly on the workload)
however as the hardware/software interaction was not optimized at design
time.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    5 +++++
 mm/nommu.c      |   21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff -puN kernel/module.c~nommu-add-support-for-memory-protection-units-mpu kernel/module.c
--- a/kernel/module.c~nommu-add-support-for-memory-protection-units-mpu
+++ a/kernel/module.c
@@ -47,6 +47,7 @@
 #include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
@@ -1535,6 +1536,10 @@ static void free_module(struct module *m
 
 	/* Finally, free the core (containing the module structure) */
 	module_free(mod, mod->module_core);
+
+#ifdef CONFIG_MPU
+	update_protections(current->mm);
+#endif
 }
 
 void *__symbol_get(const char *symbol)
diff -puN mm/nommu.c~nommu-add-support-for-memory-protection-units-mpu mm/nommu.c
--- a/mm/nommu.c~nommu-add-support-for-memory-protection-units-mpu
+++ a/mm/nommu.c
@@ -33,6 +33,7 @@
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
 #include "internal.h"
 
 static inline __attribute__((format(printf, 1, 2)))
@@ -583,6 +584,22 @@ static void put_nommu_region(struct vm_r
 }
 
 /*
+ * update protection on a vma
+ */
+static void protect_vma(struct vm_area_struct *vma, unsigned long flags)
+{
+#ifdef CONFIG_MPU
+	struct mm_struct *mm = vma->vm_mm;
+	long start = vma->vm_start & PAGE_MASK;
+	while (start < vma->vm_end) {
+		protect_page(mm, start, flags);
+		start += PAGE_SIZE;
+	}
+	update_protections(mm);
+#endif
+}
+
+/*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
  * page
@@ -601,6 +618,8 @@ static void add_vma_to_mm(struct mm_stru
 	mm->map_count++;
 	vma->vm_mm = mm;
 
+	protect_vma(vma, vma->vm_flags);
+
 	/* add the VMA to the mapping */
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
@@ -663,6 +682,8 @@ static void delete_vma_from_mm(struct vm
 
 	kenter("%p", vma);
 
+	protect_vma(vma, 0);
+
 	mm->map_count--;
 	if (mm->mmap_cache == vma)
 		mm->mmap_cache = NULL;
_

Patches currently in -mm which might be from bernds_cb1@t-online.de are

nommu-add-support-for-memory-protection-units-mpu.patch

