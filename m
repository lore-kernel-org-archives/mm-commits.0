From: akpm@linux-foundation.org
Subject: - nfsd-fix-vm-overcommit-crash-fix-2.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:28:35 -0800
Message-ID: <200812032028.mB3KSZSt027980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757875AbYLCU3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hooanon05@yahoo.co.jp, alan@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     nfsd: fix vm overcommit crash fix #2
has been removed from the -mm tree.  Its filename was
     nfsd-fix-vm-overcommit-crash-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfsd: fix vm overcommit crash fix #2
From: Junjiro R. Okajima <hooanon05@yahoo.co.jp>

The previous patch from Alan Cox (Subject: nfsd: fix vm overcommit
crash) fixed the problem where knfsd crashes on exported shmemfs
objects and strict overcommit is set.  But the patch forgot supporting
the case when CONFIG_SECURITY is disabled.

This patch copies a part of his fix which is mainly for detecting a bug
earlier.

Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Junjiro R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/security.h~nfsd-fix-vm-overcommit-crash-fix-2 include/linux/security.h
--- a/include/linux/security.h~nfsd-fix-vm-overcommit-crash-fix-2
+++ a/include/linux/security.h
@@ -1818,17 +1818,21 @@ static inline int security_settime(struc
 
 static inline int security_vm_enough_memory(long pages)
 {
+	WARN_ON(current->mm == NULL);
 	return cap_vm_enough_memory(current->mm, pages);
 }
 
-static inline int security_vm_enough_memory_kern(long pages)
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
-	return cap_vm_enough_memory(current->mm, pages);
+	WARN_ON(mm == NULL);
+	return cap_vm_enough_memory(mm, pages);
 }
 
-static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
+static inline int security_vm_enough_memory_kern(long pages)
 {
-	return cap_vm_enough_memory(mm, pages);
+	/* If current->mm is a kernel thread then we will pass NULL,
+	   for this specific case that is fine */
+	return cap_vm_enough_memory(current->mm, pages);
 }
 
 static inline int security_bprm_alloc(struct linux_binprm *bprm)
_

Patches currently in -mm which might be from hooanon05@yahoo.co.jp are

origin.patch
loop-add-ioctl-to-resize-a-loop-device.patch

