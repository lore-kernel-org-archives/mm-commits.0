From: akpm@linux-foundation.org
Subject: + nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch added to -mm tree
Date: Thu, 15 Oct 2009 16:36:13 -0700
Message-ID: <200910152336.n9FNaDFR021459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbZJOXhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 19:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, graf.yang@analog.com, jmorris@namei.org


The patch titled
     nommu: ignore the address parameter in the file_mmap() security check
has been added to the -mm tree.  Its filename is
     nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch

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
Subject: nommu: ignore the address parameter in the file_mmap() security check
From: David Howells <dhowells@redhat.com>

Ignore the address parameter in the various file_mmap() security checks
when CONFIG_MMU=n as the address hint is ignored under those
circumstances, and in any case the minimum mapping address check is
pointless in NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Graff Yang <graf.yang@analog.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/security.h~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check include/linux/security.h
--- a/include/linux/security.h~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/include/linux/security.h
@@ -609,6 +609,7 @@ static inline void security_free_mnt_opt
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
@@ -3045,6 +3045,7 @@ static int selinux_file_mmap(struct file
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
+#ifdef CONFIG_MMU
 	u32 sid = current_sid();
 
 	/*
@@ -3059,6 +3060,7 @@ static int selinux_file_mmap(struct file
 		if (rc)
 			return rc;
 	}
+#endif
 
 	/* do DAC check on address space usage */
 	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
keys-get_instantiation_keyring-should-inc-the-keyring-refcount-in-all-cases.patch
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
frv-duplicate-output_buffer-of-e03.patch
rwsem-spinlock-remove-useless-function-exports.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

