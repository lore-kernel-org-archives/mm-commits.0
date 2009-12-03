From: akpm@linux-foundation.org
Subject: [to-be-updated] nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch removed from -mm tree
Date: Thu, 03 Dec 2009 15:04:03 -0800
Message-ID: <200912032304.nB3N43gV019313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbZLCXEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 18:04:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, eparis@redhat.com, graf.yang@analog.com, jmorris@namei.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nommu: ignore the address parameter in the file_mmap() security check
has been removed from the -mm tree.  Its filename was
     nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: ignore the address parameter in the file_mmap() security check
From: David Howells <dhowells@redhat.com>

Ignore the address parameter in the various file_mmap() security checks
when CONFIG_MMU=n as the address hint is ignored under those
circumstances, and in any case the minimum mapping address check is
pointless in NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Graff Yang <graf.yang@analog.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    1 +
 mm/nommu.c               |    2 +-
 security/commoncap.c     |    2 ++
 security/selinux/hooks.c |    2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/security.h~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check include/linux/security.h
--- a/include/linux/security.h~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/include/linux/security.h
@@ -593,6 +593,7 @@ static inline void security_free_mnt_opt
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr contains the mapping address, and should be ignored in NOMMU mode.
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
diff -puN mm/nommu.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check mm/nommu.c
--- a/mm/nommu.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/mm/nommu.c
@@ -974,7 +974,7 @@ static int validate_mmap_request(struct 
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
+	ret = security_file_mmap(file, reqprot, prot, flags, 0, 0);
 	if (ret < 0)
 		return ret;
 
diff -puN security/commoncap.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check security/commoncap.c
--- a/security/commoncap.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/security/commoncap.c
@@ -1005,6 +1005,7 @@ int cap_file_mmap(struct file *file, uns
 {
 	int ret = 0;
 
+#ifdef CONFIG_MMU
 	if (addr < dac_mmap_min_addr) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
@@ -1012,5 +1013,6 @@ int cap_file_mmap(struct file *file, uns
 		if (ret == 0)
 			current->flags |= PF_SUPERPRIV;
 	}
+#endif
 	return ret;
 }
diff -puN security/selinux/hooks.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check security/selinux/hooks.c
--- a/security/selinux/hooks.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/security/selinux/hooks.c
@@ -3046,6 +3046,7 @@ static int selinux_file_mmap(struct file
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
+#ifdef CONFIG_MMU
 	u32 sid = current_sid();
 
 	/*
@@ -3060,6 +3061,7 @@ static int selinux_file_mmap(struct file
 		if (rc)
 			return rc;
 	}
+#endif
 
 	/* do DAC check on address space usage */
 	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
_

Patches currently in -mm which might be from dhowells@redhat.com are

bsdacct-fix-uid-gid-misreporting.patch
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
linux-next.patch
mm-make-totalhigh_pages-unsigned-long.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-fix-malloc-performance-by-adding-uninitialized-flag.patch
procfs-use-proper-units-for-nommu-statm.patch
procfs-use-proper-units-for-nommu-statm-fix.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

