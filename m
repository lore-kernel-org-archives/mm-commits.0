From: akpm@google.com
Subject: + mm-add-vm_area_add_early.patch added to -mm tree
Date: Thu, 06 Oct 2011 16:11:00 -0700
Message-ID: <201110062311.p96NB0WV029623@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14819 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1JFXLE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 19:11:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.pitre@linaro.org


The patch titled
     Subject: mm: add vm_area_add_early()
has been added to the -mm tree.  Its filename is
     mm-add-vm_area_add_early.patch

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
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: mm: add vm_area_add_early()

Patches currently in -mm which might be from nicolas.pitre@linaro.org are

origin.patch
linux-next.patch
mm-add-vm_area_add_early.patch
binfmt_elf-fix-pie-execution-with-randomization-disabled.patch

