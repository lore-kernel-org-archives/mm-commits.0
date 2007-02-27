From: akpm@linux-foundation.org
Subject: + uml-fix-host-ldt-lookup-initialization-locking-try-2.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:34:03 -0800
Message-ID: <200702272034.l1RKY7uc027541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXB0UeS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:34:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: fix host LDT lookup initialization locking, try 2
has been added to the -mm tree.  Its filename is
     uml-fix-host-ldt-lookup-initialization-locking-try-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix host LDT lookup initialization locking, try 2
From: Jeff Dike <jdike@addtoit.com>

Add some locking to host_ldt_entries to prevent racing when reading LDT
information from the host.

The locking is somewhat more careful than my previous attempt.  Now, only
the check of host_ldt_entries is locked.  The lock is dropped immediately
afterwards, and if the LDT needs initializing, that (and the memory
allocations needed) proceed outside the lock.

Also fixed some style violations.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/ldt.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff -puN arch/um/sys-i386/ldt.c~uml-fix-host-ldt-lookup-initialization-locking-try-2 arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-fix-host-ldt-lookup-initialization-locking-try-2
+++ a/arch/um/sys-i386/ldt.c
@@ -7,6 +7,7 @@
 #include "linux/slab.h"
 #include "linux/types.h"
 #include "linux/errno.h"
+#include "linux/spinlock.h"
 #include "asm/uaccess.h"
 #include "asm/smp.h"
 #include "asm/ldt.h"
@@ -386,23 +387,33 @@ static long do_modify_ldt_skas(int func,
 	return ret;
 }
 
-short dummy_list[9] = {0, -1};
-short * host_ldt_entries = NULL;
+static DEFINE_SPINLOCK(host_ldt_lock);
+static short dummy_list[9] = {0, -1};
+static short * host_ldt_entries = NULL;
 
-void ldt_get_host_info(void)
+static void ldt_get_host_info(void)
 {
 	long ret;
-	struct ldt_entry * ldt;
+	struct ldt_entry * ldt, *tmp;
 	int i, size, k, order;
 
+	spin_lock(&host_ldt_lock);
+
+	if(host_ldt_entries != NULL){
+		spin_unlock(&host_ldt_lock);
+		return;
+	}
 	host_ldt_entries = dummy_list+1;
 
+	spin_unlock(&host_ldt_lock);
+
 	for(i = LDT_PAGES_MAX-1, order=0; i; i>>=1, order++);
 
 	ldt = (struct ldt_entry *)
 	      __get_free_pages(GFP_KERNEL|__GFP_ZERO, order);
 	if(ldt == NULL) {
-		printk("ldt_get_host_info: couldn't allocate buffer for host ldt\n");
+		printk("ldt_get_host_info: couldn't allocate buffer for host "
+		       "ldt\n");
 		return;
 	}
 
@@ -426,11 +437,13 @@ void ldt_get_host_info(void)
 		host_ldt_entries = dummy_list;
 	else {
 		size = (size + 1) * sizeof(dummy_list[0]);
-		host_ldt_entries = kmalloc(size, GFP_KERNEL);
-		if(host_ldt_entries == NULL) {
-			printk("ldt_get_host_info: couldn't allocate host ldt list\n");
+		tmp = kmalloc(size, GFP_KERNEL);
+		if(tmp == NULL) {
+			printk("ldt_get_host_info: couldn't allocate host ldt "
+			       "list\n");
 			goto out_free;
 		}
+		host_ldt_entries = tmp;
 	}
 
 	for(i=0, k=0; i<ret/LDT_ENTRY_SIZE; i++){
@@ -480,8 +493,7 @@ long init_new_ldt(struct mmu_context_ska
 			 * inherited from the host. All ldt-entries found
 			 * will be reset in the following loop
 			 */
-			if(host_ldt_entries == NULL)
-				ldt_get_host_info();
+			ldt_get_host_info();
 			for(num_p=host_ldt_entries; *num_p != -1; num_p++){
 				desc.entry_number = *num_p;
 				err = write_ldt_entry(&new_mm->id, 1, &desc,
@@ -560,6 +572,6 @@ void free_ldt(struct mmu_context_skas * 
 
 int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
 {
-	return(CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
-	                        ptr, bytecount));
+	return CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
+	                        ptr, bytecount);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-host-ldt-lookup-initialization-locking-try-2.patch
uml-add-back-accidentally-removed-error.patch
uml-enable-raw.patch
uml-host-vdso-fix.patch
uml-pte_mkread-fix.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
