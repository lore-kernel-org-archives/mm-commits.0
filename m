From: akpm@linux-foundation.org
Subject: + nfsd-fix-vm-overcommit-crash-fix-2.patch added to -mm tree
Date: Tue, 04 Nov 2008 15:56:57 -0800
Message-ID: <200811042356.mA4Nuv0T007665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759608AbYKDX6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 18:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hooanon05@yahoo.co.jp, alan@redhat.com, jmorris@namei.org


The patch titled
     nfsd: fix vm overcommit crash fix #2
has been added to the -mm tree.  Its filename is
     nfsd-fix-vm-overcommit-crash-fix-2.patch

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
@@ -1860,17 +1860,21 @@ static inline int security_settime(struc
 
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
 
 static inline int security_bprm_set_creds(struct linux_binprm *bprm)
_

Patches currently in -mm which might be from hooanon05@yahoo.co.jp are

nfsd-fix-vm-overcommit-crash-fix-2.patch

