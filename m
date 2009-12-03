From: akpm@linux-foundation.org
Subject: + security-do-not-check-mmap_min_addr-on-nommu-systems.patch added to -mm tree
Date: Thu, 03 Dec 2009 15:05:22 -0800
Message-ID: <200912032305.nB3N5Mmw022560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbZLCXGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 18:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, dhowells@redhat.com, graf.yang@analog.com, jmorris@namei.org, vapier.adi@gmail.com


The patch titled
     security: do not check mmap_min_addr on nommu systems
has been added to the -mm tree.  Its filename is
     security-do-not-check-mmap_min_addr-on-nommu-systems.patch

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
Subject: security: do not check mmap_min_addr on nommu systems
From: Eric Paris <eparis@redhat.com>

nommu systems can do anything with memory they please and so they already
win.  mmap_min_addr is the least of their worries.  Currently the
mmap_min_addr implementation is problamatic on such systems.  This patch
changes the addr_only argument to be a flags which can take the arguments
for addr_only or not_addr.  LSMs then need to properly implement these two
flags.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Reported-by: Graff Yang <graf.yang@analog.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |   18 +++++++++++++-----
 mm/mmap.c                |    6 ++++--
 mm/mremap.c              |    6 ++++--
 mm/nommu.c               |    3 ++-
 security/commoncap.c     |    7 ++++---
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    9 +++++----
 7 files changed, 35 insertions(+), 19 deletions(-)

diff -puN include/linux/security.h~security-do-not-check-mmap_min_addr-on-nommu-systems include/linux/security.h
--- a/include/linux/security.h~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/include/linux/security.h
@@ -43,6 +43,12 @@
 #define SECURITY_CAP_NOAUDIT 0
 #define SECURITY_CAP_AUDIT 1
 
+/* sec_flags for security_file_mmap */
+/* Only check the address portion */
+#define SECURITY_MMAP_ADDR_ONLY	0x01
+/* Do not do the address checks */
+#define SECURITY_MMAP_NOT_ADDR	0x02
+
 struct ctl_table;
 struct audit_krule;
 
@@ -69,7 +75,7 @@ extern int cap_inode_need_killpriv(struc
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags,
-			 unsigned long addr, unsigned long addr_only);
+			 unsigned long addr, unsigned long sec_flags);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -609,6 +615,8 @@ static inline void security_free_mnt_opt
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr address vm will map to
+ *	@sec_flags what security checks should be done
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
@@ -1556,7 +1564,7 @@ struct security_operations {
 	int (*file_mmap) (struct file *file,
 			  unsigned long reqprot, unsigned long prot,
 			  unsigned long flags, unsigned long addr,
-			  unsigned long addr_only);
+			  unsigned long sec_flags);
 	int (*file_mprotect) (struct vm_area_struct *vma,
 			      unsigned long reqprot,
 			      unsigned long prot);
@@ -1826,7 +1834,7 @@ void security_file_free(struct file *fil
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-			unsigned long addr, unsigned long addr_only);
+			unsigned long addr, unsigned long sec_flags);
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			   unsigned long prot);
 int security_file_lock(struct file *file, unsigned int cmd);
@@ -2323,9 +2331,9 @@ static inline int security_file_mmap(str
 				     unsigned long prot,
 				     unsigned long flags,
 				     unsigned long addr,
-				     unsigned long addr_only)
+				     unsigned long sec_flags)
 {
-	return cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
+	return cap_file_mmap(file, reqprot, prot, flags, addr, sec_flags);
 }
 
 static inline int security_file_mprotect(struct vm_area_struct *vma,
diff -puN mm/mmap.c~security-do-not-check-mmap_min_addr-on-nommu-systems mm/mmap.c
--- a/mm/mmap.c~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/mm/mmap.c
@@ -1676,7 +1676,8 @@ static int expand_downwards(struct vm_ar
 		return -ENOMEM;
 
 	address &= PAGE_MASK;
-	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, address,
+				   SECURITY_MMAP_ADDR_ONLY);
 	if (error)
 		return error;
 
@@ -2037,7 +2038,8 @@ unsigned long do_brk(unsigned long addr,
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
-	error = security_file_mmap(NULL, 0, 0, 0, addr, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, addr,
+				   SECURITY_MMAP_ADDR_ONLY);
 	if (error)
 		return error;
 
diff -puN mm/mremap.c~security-do-not-check-mmap_min_addr-on-nommu-systems mm/mremap.c
--- a/mm/mremap.c~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/mm/mremap.c
@@ -313,7 +313,8 @@ unsigned long do_mremap(unsigned long ad
 		if ((addr <= new_addr) && (addr+old_len) > new_addr)
 			goto out;
 
-		ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
+		ret = security_file_mmap(NULL, 0, 0, 0, new_addr,
+					 SECURITY_MMAP_ADDR_ONLY);
 		if (ret)
 			goto out;
 
@@ -421,7 +422,8 @@ unsigned long do_mremap(unsigned long ad
 				goto out;
 			}
 
-			ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
+			ret = security_file_mmap(NULL, 0, 0, 0, new_addr,
+						 SECURITY_MMAP_ADDR_ONLY);
 			if (ret)
 				goto out;
 		}
diff -puN mm/nommu.c~security-do-not-check-mmap_min_addr-on-nommu-systems mm/nommu.c
--- a/mm/nommu.c~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/mm/nommu.c
@@ -974,7 +974,8 @@ static int validate_mmap_request(struct 
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
+	ret = security_file_mmap(file, reqprot, prot, flags, 0,
+				 SECURITY_MMAP_NOT_ADDR);
 	if (ret < 0)
 		return ret;
 
diff -puN security/commoncap.c~security-do-not-check-mmap_min_addr-on-nommu-systems security/commoncap.c
--- a/security/commoncap.c~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/security/commoncap.c
@@ -924,7 +924,7 @@ int cap_vm_enough_memory(struct mm_struc
  * @prot: unused
  * @flags: unused
  * @addr: address attempting to be mapped
- * @addr_only: unused
+ * @sec_flags: should the addr be checked?
  *
  * If the process is attempting to map memory below mmap_min_addr they need
  * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
@@ -933,11 +933,12 @@ int cap_vm_enough_memory(struct mm_struc
  */
 int cap_file_mmap(struct file *file, unsigned long reqprot,
 		  unsigned long prot, unsigned long flags,
-		  unsigned long addr, unsigned long addr_only)
+		  unsigned long addr, unsigned long sec_flags)
 {
 	int ret = 0;
 
-	if (addr < dac_mmap_min_addr) {
+	if (!(sec_flags & SECURITY_MMAP_NOT_ADDR) &&
+	    (addr < dac_mmap_min_addr)) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
 		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
diff -puN security/security.c~security-do-not-check-mmap_min_addr-on-nommu-systems security/security.c
--- a/security/security.c~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/security/security.c
@@ -677,11 +677,12 @@ int security_file_ioctl(struct file *fil
 
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-			unsigned long addr, unsigned long addr_only)
+			unsigned long addr, unsigned long sec_flags)
 {
 	int ret;
 
-	ret = security_ops->file_mmap(file, reqprot, prot, flags, addr, addr_only);
+	ret = security_ops->file_mmap(file, reqprot, prot, flags, addr,
+				      sec_flags);
 	if (ret)
 		return ret;
 	return ima_file_mmap(file, prot);
diff -puN security/selinux/hooks.c~security-do-not-check-mmap_min_addr-on-nommu-systems security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-do-not-check-mmap_min_addr-on-nommu-systems
+++ a/security/selinux/hooks.c
@@ -3043,7 +3043,7 @@ error:
 
 static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long prot, unsigned long flags,
-			     unsigned long addr, unsigned long addr_only)
+			     unsigned long addr, unsigned long sec_flags)
 {
 	int rc = 0;
 	u32 sid = current_sid();
@@ -3054,7 +3054,8 @@ static int selinux_file_mmap(struct file
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
+	if (!(sec_flags & SECURITY_MMAP_NOT_ADDR) &&
+	    (addr < CONFIG_LSM_MMAP_MIN_ADDR)) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 		if (rc)
@@ -3062,8 +3063,8 @@ static int selinux_file_mmap(struct file
 	}
 
 	/* do DAC check on address space usage */
-	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
-	if (rc || addr_only)
+	rc = cap_file_mmap(file, reqprot, prot, flags, addr, sec_flags);
+	if (rc || (sec_flags & SECURITY_MMAP_ADDR_ONLY))
 		return rc;
 
 	if (selinux_checkreqprot)
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
security-do-not-check-mmap_min_addr-on-nommu-systems.patch

