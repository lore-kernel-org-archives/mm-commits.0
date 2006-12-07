From: akpm@osdl.org
Subject: - kernel-core-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:04 -0800
Message-ID: <200612072307.kB7N74Zh030330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163928AbWLGXHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel core: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     kernel-core-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel core: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 ipc/sem.c            |    3 +--
 kernel/auditfilter.c |    3 +--
 kernel/futex.c       |    3 +--
 kernel/kexec.c       |    3 +--
 lib/kobject.c        |    3 +--
 mm/nommu.c           |    6 ++----
 6 files changed, 7 insertions(+), 14 deletions(-)

diff -puN ipc/sem.c~kernel-core-replace-kmallocmemset-with-kzalloc ipc/sem.c
--- a/ipc/sem.c~kernel-core-replace-kmallocmemset-with-kzalloc
+++ a/ipc/sem.c
@@ -1070,14 +1070,13 @@ static struct sem_undo *find_undo(struct
 	ipc_rcu_getref(sma);
 	sem_unlock(sma);
 
-	new = (struct sem_undo *) kmalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
+	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
 		ipc_lock_by_ptr(&sma->sem_perm);
 		ipc_rcu_putref(sma);
 		sem_unlock(sma);
 		return ERR_PTR(-ENOMEM);
 	}
-	memset(new, 0, sizeof(struct sem_undo) + sizeof(short)*nsems);
 	new->semadj = (short *) &new[1];
 	new->semid = semid;
 
diff -puN kernel/auditfilter.c~kernel-core-replace-kmallocmemset-with-kzalloc kernel/auditfilter.c
--- a/kernel/auditfilter.c~kernel-core-replace-kmallocmemset-with-kzalloc
+++ a/kernel/auditfilter.c
@@ -636,10 +636,9 @@ static struct audit_rule *audit_krule_to
 	struct audit_rule *rule;
 	int i;
 
-	rule = kmalloc(sizeof(*rule), GFP_KERNEL);
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
 	if (unlikely(!rule))
 		return NULL;
-	memset(rule, 0, sizeof(*rule));
 
 	rule->flags = krule->flags | krule->listnr;
 	rule->action = krule->action;
diff -puN kernel/futex.c~kernel-core-replace-kmallocmemset-with-kzalloc kernel/futex.c
--- a/kernel/futex.c~kernel-core-replace-kmallocmemset-with-kzalloc
+++ a/kernel/futex.c
@@ -324,12 +324,11 @@ static int refill_pi_state_cache(void)
 	if (likely(current->pi_state_cache))
 		return 0;
 
-	pi_state = kmalloc(sizeof(*pi_state), GFP_KERNEL);
+	pi_state = kzalloc(sizeof(*pi_state), GFP_KERNEL);
 
 	if (!pi_state)
 		return -ENOMEM;
 
-	memset(pi_state, 0, sizeof(*pi_state));
 	INIT_LIST_HEAD(&pi_state->list);
 	/* pi_mutex gets initialized later */
 	pi_state->owner = NULL;
diff -puN kernel/kexec.c~kernel-core-replace-kmallocmemset-with-kzalloc kernel/kexec.c
--- a/kernel/kexec.c~kernel-core-replace-kmallocmemset-with-kzalloc
+++ a/kernel/kexec.c
@@ -108,11 +108,10 @@ static int do_kimage_alloc(struct kimage
 
 	/* Allocate a controlling structure */
 	result = -ENOMEM;
-	image = kmalloc(sizeof(*image), GFP_KERNEL);
+	image = kzalloc(sizeof(*image), GFP_KERNEL);
 	if (!image)
 		goto out;
 
-	memset(image, 0, sizeof(*image));
 	image->head = 0;
 	image->entry = &image->head;
 	image->last_entry = &image->head;
diff -puN lib/kobject.c~kernel-core-replace-kmallocmemset-with-kzalloc lib/kobject.c
--- a/lib/kobject.c~kernel-core-replace-kmallocmemset-with-kzalloc
+++ a/lib/kobject.c
@@ -111,10 +111,9 @@ char *kobject_get_path(struct kobject *k
 	len = get_kobj_path_length(kobj);
 	if (len == 0)
 		return NULL;
-	path = kmalloc(len, gfp_mask);
+	path = kzalloc(len, gfp_mask);
 	if (!path)
 		return NULL;
-	memset(path, 0x00, len);
 	fill_kobj_path(kobj, path, len);
 
 	return path;
diff -puN mm/nommu.c~kernel-core-replace-kmallocmemset-with-kzalloc mm/nommu.c
--- a/mm/nommu.c~kernel-core-replace-kmallocmemset-with-kzalloc
+++ a/mm/nommu.c
@@ -808,10 +808,9 @@ unsigned long do_mmap_pgoff(struct file 
 	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
 
 	/* we're going to need to record the mapping if it works */
-	vml = kmalloc(sizeof(struct vm_list_struct), GFP_KERNEL);
+	vml = kzalloc(sizeof(struct vm_list_struct), GFP_KERNEL);
 	if (!vml)
 		goto error_getting_vml;
-	memset(vml, 0, sizeof(*vml));
 
 	down_write(&nommu_vma_sem);
 
@@ -887,11 +886,10 @@ unsigned long do_mmap_pgoff(struct file 
 	}
 
 	/* we're going to need a VMA struct as well */
-	vma = kmalloc(sizeof(struct vm_area_struct), GFP_KERNEL);
+	vma = kzalloc(sizeof(struct vm_area_struct), GFP_KERNEL);
 	if (!vma)
 		goto error_getting_vma;
 
-	memset(vma, 0, sizeof(*vma));
 	INIT_LIST_HEAD(&vma->anon_vma_node);
 	atomic_set(&vma->vm_usage, 1);
 	if (file)
_

Patches currently in -mm which might be from yan_952@hotmail.com are

origin.patch
acpi-replace-kmallocmemset-with-kzalloc.patch
git-mtd.patch
serial-replace-kmallocmemset-with-kzalloc.patch
usb-auerswald-replace-kmallocmemset-with-kzalloc.patch
isdn-replace-kmallocmemset-with-kzalloc.patch

