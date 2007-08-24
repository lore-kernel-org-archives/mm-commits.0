From: akpm@linux-foundation.org
Subject: - fix-null-pointer-dereference-in-__vm_enough_memory.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:55 -0700
Message-ID: <200708242055.l7OKttlh013993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbXHXU46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jmorris@redhat.com, ranma+kernel@tdiedrich.de, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     fix NULL pointer dereference in __vm_enough_memory()
has been removed from the -mm tree.  Its filename was
     fix-null-pointer-dereference-in-__vm_enough_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix NULL pointer dereference in __vm_enough_memory()
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The new exec code inserts an accounted vma into an mm struct which is not
current->mm.  The existing memory check code has a hard coded assumption
that this does not happen as does the security code.

As the correct mm is known we pass the mm to the security method and the
helper function.  A new security test is added for the case where we need
to pass the mm and the existing one is modified to pass current->mm to
avoid the need to change large amounts of code.

(Thanks to Tobias for fixing rejects and testing)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: James Morris <jmorris@redhat.com>
Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 +-
 include/linux/security.h |   20 +++++++++++++++-----
 mm/mmap.c                |    6 +++---
 mm/nommu.c               |    2 +-
 security/commoncap.c     |    4 ++--
 security/dummy.c         |    4 ++--
 security/selinux/hooks.c |    4 ++--
 7 files changed, 26 insertions(+), 16 deletions(-)

diff -puN include/linux/mm.h~fix-null-pointer-dereference-in-__vm_enough_memory include/linux/mm.h
--- a/include/linux/mm.h~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/include/linux/mm.h
@@ -1042,7 +1042,7 @@ static inline void vma_nonlinear_insert(
 }
 
 /* mmap.c */
-extern int __vm_enough_memory(long pages, int cap_sys_admin);
+extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
 extern void vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
diff -puN include/linux/security.h~fix-null-pointer-dereference-in-__vm_enough_memory include/linux/security.h
--- a/include/linux/security.h~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/include/linux/security.h
@@ -54,7 +54,7 @@ extern int cap_inode_removexattr(struct 
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_syslog (int type);
-extern int cap_vm_enough_memory (long pages);
+extern int cap_vm_enough_memory (struct mm_struct *mm, long pages);
 
 struct msghdr;
 struct sk_buff;
@@ -1125,6 +1125,7 @@ struct request_sock;
  *	Return 0 if permission is granted.
  * @vm_enough_memory:
  *	Check permissions for allocating a new virtual mapping.
+ *	@mm contains the mm struct it is being added to.
  *      @pages contains the number of pages.
  *	Return 0 if permission is granted.
  *
@@ -1169,7 +1170,7 @@ struct security_operations {
 	int (*quota_on) (struct dentry * dentry);
 	int (*syslog) (int type);
 	int (*settime) (struct timespec *ts, struct timezone *tz);
-	int (*vm_enough_memory) (long pages);
+	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
 	int (*bprm_alloc_security) (struct linux_binprm * bprm);
 	void (*bprm_free_security) (struct linux_binprm * bprm);
@@ -1469,10 +1470,14 @@ static inline int security_settime(struc
 	return security_ops->settime(ts, tz);
 }
 
-
 static inline int security_vm_enough_memory(long pages)
 {
-	return security_ops->vm_enough_memory(pages);
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
+{
+	return security_ops->vm_enough_memory(mm, pages);
 }
 
 static inline int security_bprm_alloc (struct linux_binprm *bprm)
@@ -2219,7 +2224,12 @@ static inline int security_settime(struc
 
 static inline int security_vm_enough_memory(long pages)
 {
-	return cap_vm_enough_memory(pages);
+	return cap_vm_enough_memory(current->mm, pages);
+}
+
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
+{
+	return cap_vm_enough_memory(mm, pages);
 }
 
 static inline int security_bprm_alloc (struct linux_binprm *bprm)
diff -puN mm/mmap.c~fix-null-pointer-dereference-in-__vm_enough_memory mm/mmap.c
--- a/mm/mmap.c~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/mm/mmap.c
@@ -93,7 +93,7 @@ atomic_t vm_committed_space = ATOMIC_INI
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(long pages, int cap_sys_admin)
+int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	unsigned long free, allowed;
 
@@ -166,7 +166,7 @@ int __vm_enough_memory(long pages, int c
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
@@ -2077,7 +2077,7 @@ int insert_vm_struct(struct mm_struct * 
 	if (__vma && __vma->vm_start < vma->vm_end)
 		return -ENOMEM;
 	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory(vma_pages(vma)))
+	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
 		return -ENOMEM;
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
diff -puN mm/nommu.c~fix-null-pointer-dereference-in-__vm_enough_memory mm/nommu.c
--- a/mm/nommu.c~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/mm/nommu.c
@@ -1270,7 +1270,7 @@ EXPORT_SYMBOL(get_unmapped_area);
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(long pages, int cap_sys_admin)
+int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	unsigned long free, allowed;
 
diff -puN security/commoncap.c~fix-null-pointer-dereference-in-__vm_enough_memory security/commoncap.c
--- a/security/commoncap.c~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/security/commoncap.c
@@ -315,13 +315,13 @@ int cap_syslog (int type)
 	return 0;
 }
 
-int cap_vm_enough_memory(long pages)
+int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int cap_sys_admin = 0;
 
 	if (cap_capable(current, CAP_SYS_ADMIN) == 0)
 		cap_sys_admin = 1;
-	return __vm_enough_memory(pages, cap_sys_admin);
+	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
 EXPORT_SYMBOL(cap_capable);
diff -puN security/dummy.c~fix-null-pointer-dereference-in-__vm_enough_memory security/dummy.c
--- a/security/dummy.c~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/security/dummy.c
@@ -108,13 +108,13 @@ static int dummy_settime(struct timespec
 	return 0;
 }
 
-static int dummy_vm_enough_memory(long pages)
+static int dummy_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int cap_sys_admin = 0;
 
 	if (dummy_capable(current, CAP_SYS_ADMIN) == 0)
 		cap_sys_admin = 1;
-	return __vm_enough_memory(pages, cap_sys_admin);
+	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
 static int dummy_bprm_alloc_security (struct linux_binprm *bprm)
diff -puN security/selinux/hooks.c~fix-null-pointer-dereference-in-__vm_enough_memory security/selinux/hooks.c
--- a/security/selinux/hooks.c~fix-null-pointer-dereference-in-__vm_enough_memory
+++ a/security/selinux/hooks.c
@@ -1584,7 +1584,7 @@ static int selinux_syslog(int type)
  * Do not audit the selinux permission check, as this is applied to all
  * processes that allocate mappings.
  */
-static int selinux_vm_enough_memory(long pages)
+static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int rc, cap_sys_admin = 0;
 	struct task_security_struct *tsec = current->security;
@@ -1600,7 +1600,7 @@ static int selinux_vm_enough_memory(long
 	if (rc == 0)
 		cap_sys_admin = 1;
 
-	return __vm_enough_memory(pages, cap_sys_admin);
+	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
 /* binprm security operations */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
