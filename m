From: akpm@linux-foundation.org
Subject: [merged] kexec-vmalloc-export-additional-vmalloc-layer-information.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:43 -0700
Message-ID: <20130430184743.9F2C931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:44853 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3Srp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:45 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75733ves.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, js1304@gmail.com, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec, vmalloc: export additional vmalloc layer information
has been removed from the -mm tree.  Its filename was
     kexec-vmalloc-export-additional-vmalloc-layer-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: kexec, vmalloc: export additional vmalloc layer information

Now, vmap_area_list is exported as VMCOREINFO for makedumpfile to get the
start address of vmalloc region (vmalloc_start).  The address which
contains vmalloc_start value is represented as below:

  vmap_area_list.next - OFFSET(vmap_area.list) + OFFSET(vmap_area.va_start)

However, both OFFSET(vmap_area.va_start) and OFFSET(vmap_area.list) aren't
exported as VMCOREINFO.

So this patch exports them externally with small cleanup.

[akpm@linux-foundation.org: vmalloc.h should include list.h for list_head]
Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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

 include/linux/vmalloc.h |   13 +++++++++++++
 kernel/kexec.c          |    3 ++-
 mm/vmalloc.c            |   11 -----------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff -puN include/linux/vmalloc.h~kexec-vmalloc-export-additional-vmalloc-layer-information include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~kexec-vmalloc-export-additional-vmalloc-layer-information
+++ a/include/linux/vmalloc.h
@@ -3,7 +3,9 @@
 
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <asm/page.h>		/* pgprot_t */
+#include <linux/rbtree.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
@@ -35,6 +37,17 @@ struct vm_struct {
 	const void		*caller;
 };
 
+struct vmap_area {
+	unsigned long va_start;
+	unsigned long va_end;
+	unsigned long flags;
+	struct rb_node rb_node;         /* address sorted rbtree */
+	struct list_head list;          /* address sorted list */
+	struct list_head purge_list;    /* "lazy purge" list */
+	struct vm_struct *vm;
+	struct rcu_head rcu_head;
+};
+
 /*
  *	Highlevel APIs for driver use
  */
diff -puN kernel/kexec.c~kexec-vmalloc-export-additional-vmalloc-layer-information kernel/kexec.c
--- a/kernel/kexec.c~kexec-vmalloc-export-additional-vmalloc-layer-information
+++ a/kernel/kexec.c
@@ -1615,7 +1615,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(free_area, free_list);
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
-	VMCOREINFO_OFFSET(vm_struct, addr);
+	VMCOREINFO_OFFSET(vmap_area, va_start);
+	VMCOREINFO_OFFSET(vmap_area, list);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
 	log_buf_kexec_setup();
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
diff -puN mm/vmalloc.c~kexec-vmalloc-export-additional-vmalloc-layer-information mm/vmalloc.c
--- a/mm/vmalloc.c~kexec-vmalloc-export-additional-vmalloc-layer-information
+++ a/mm/vmalloc.c
@@ -249,17 +249,6 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 #define VM_LAZY_FREEING	0x02
 #define VM_VM_AREA	0x04
 
-struct vmap_area {
-	unsigned long va_start;
-	unsigned long va_end;
-	unsigned long flags;
-	struct rb_node rb_node;		/* address sorted rbtree */
-	struct list_head list;		/* address sorted list */
-	struct list_head purge_list;	/* "lazy purge" list */
-	struct vm_struct *vm;
-	struct rcu_head rcu_head;
-};
