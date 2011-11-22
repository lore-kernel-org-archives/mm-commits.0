From: akpm@linux-foundation.org
Subject: [merged] mm-add-vm_area_add_early.patch removed from -mm tree
Date: Tue, 22 Nov 2011 11:24:25 -0800
Message-ID: <201111221924.pAMJOPNF011408@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40851 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab1KVTY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 14:24:28 -0500
Received: by mail-ww0-f74.google.com with SMTP id 5so20047wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 11:24:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.pitre@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vm_area_add_early()
has been removed from the -mm tree.  Its filename was
     mm-add-vm_area_add_early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: mm: add vm_area_add_early()

The existing vm_area_register_early() allows for early vmalloc space
allocation.  However upcoming cleanups in the ARM architecture require
that some fixed locations in the vmalloc area be reserved also very early.

The name "vm_area_register_early" would have been a good name for the
reservation part without the allocation.  Since it is already in use with

Both vm_area_register_early() and vm_area_add_early() can be used together
meaning that the former is now implemented using the later where it is
ensured that no conflicting areas are added, but no attempt is made to
make the allocation scheme in vm_area_register_early() more sophisticated.
After all, you must know what you're doing when using those functions.

Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff -puN include/linux/vmalloc.h~mm-add-vm_area_add_early include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-add-vm_area_add_early
+++ a/include/linux/vmalloc.h
@@ -131,6 +131,7 @@ extern long vwrite(char *buf, char *addr
  */
 extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
+extern __init void vm_area_add_early(struct vm_struct *vm);
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
 #ifdef CONFIG_SMP
diff -puN mm/vmalloc.c~mm-add-vm_area_add_early mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-vm_area_add_early
+++ a/mm/vmalloc.c
@@ -1118,6 +1118,31 @@ void *vm_map_ram(struct page **pages, un
 EXPORT_SYMBOL(vm_map_ram);
 
 /**
+ * vm_area_add_early - add vmap area early during boot
+ * @vm: vm_struct to add
+ *
+ * This function is used to add fixed kernel vm area to vmlist before
+ * vmalloc_init() is called.  @vm->addr, @vm->size, and @vm->flags
+ * should contain proper values and the other fields should be zero.
+ *
+ * DO NOT USE THIS FUNCTION UNLESS YOU KNOW WHAT YOU'RE DOING.
+ */
+void __init vm_area_add_early(struct vm_struct *vm)
+{
+	struct vm_struct *tmp, **p;
+
+	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
+		if (tmp->addr >= vm->addr) {
+			BUG_ON(tmp->addr < vm->addr + vm->size);
+			break;
+		} else
+			BUG_ON(tmp->addr + tmp->size > vm->addr);
+	}
+	vm->next = *p;
+	*p = vm;
+}
+
+/**
  * vm_area_register_early - register vmap area early during boot
  * @vm: vm_struct to register
  * @align: requested alignment
@@ -1139,8 +1164,7 @@ void __init vm_area_register_early(struc
 
 	vm->addr = (void *)addr;
 
-	vm->next = vmlist;
-	vmlist = vm;
+	vm_area_add_early(vm);
 }
 
 void __init vmalloc_init(void)
_

Patches currently in -mm which might be from nicolas.pitre@linaro.org are

linux-next.patch

