From: akpm@linux-foundation.org
Subject: + kexec-vmalloc-export-additional-vmalloc-layer-information.patch added to -mm tree
Date: Mon, 18 Mar 2013 15:14:53 -0700
Message-ID: <20130318221453.BFA6431C26C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:55099 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3CRWOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 18:14:55 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so343277qah.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 15:14:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, js1304@gmail.com, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com


The patch titled
     Subject: kexec, vmalloc: export additional vmalloc layer information
has been added to the -mm tree.  Its filename is
     kexec-vmalloc-export-additional-vmalloc-layer-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/linux/vmalloc.h |   12 ++++++++++++
 kernel/kexec.c          |    3 ++-
 mm/vmalloc.c            |   11 -----------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/vmalloc.h~kexec-vmalloc-export-additional-vmalloc-layer-information include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~kexec-vmalloc-export-additional-vmalloc-layer-information
+++ a/include/linux/vmalloc.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <asm/page.h>		/* pgprot_t */
+#include <linux/rbtree.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
@@ -35,6 +36,17 @@ struct vm_struct {
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
@@ -1523,7 +1523,8 @@ static int __init crash_save_vmcoreinfo_
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
