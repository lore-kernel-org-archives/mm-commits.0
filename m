From: akpm@linux-foundation.org
Subject: +
 mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch
 added to -mm tree
Date: Fri, 07 Mar 2014 15:02:28 -0800
Message-ID: <531a5004.mn2shN4P/eAbYWfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaCGXC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2014 18:02:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yong@gnoy.org

Subject: + mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch added to -mm tree
To: yong@gnoy.org
From: akpm@linux-foundation.org
Date: Fri, 07 Mar 2014 15:02:28 -0800


The patch titled
     Subject: mm/nommu.c: fix 'ERROR: do not initialise globals to 0 or NULL' and coding style
has been added to the -mm tree.  Its filename is
     mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Choi Gi-yong <yong@gnoy.org>
Subject: mm/nommu.c: fix 'ERROR: do not initialise globals to 0 or NULL' and coding style

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN mm/nommu.c~mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style mm/nommu.c
--- a/mm/nommu.c~mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style
+++ a/mm/nommu.c
@@ -298,7 +298,7 @@ long vwrite(char *buf, char *addr, unsig
 		count = -(unsigned long) addr;
 
 	memcpy(addr, buf, count);
-	return(count);
+	return count;
 }
 
 /*
@@ -1012,8 +1012,7 @@ static int validate_mmap_request(struct
 
 			/* we mustn't privatise shared mappings */
 			capabilities &= ~BDI_CAP_MAP_COPY;
-		}
-		else {
+		} else {
 			/* we're going to read the file into private memory we
 			 * allocate */
 			if (!(capabilities & BDI_CAP_MAP_COPY))
@@ -1044,23 +1043,20 @@ static int validate_mmap_request(struct
 		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
 			if (prot & PROT_EXEC)
 				return -EPERM;
-		}
-		else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
+		} else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
 			/* handle implication of PROT_EXEC by PROT_READ */
 			if (current->personality & READ_IMPLIES_EXEC) {
 				if (capabilities & BDI_CAP_EXEC_MAP)
 					prot |= PROT_EXEC;
 			}
-		}
-		else if ((prot & PROT_READ) &&
+		} else if ((prot & PROT_READ) &&
 			 (prot & PROT_EXEC) &&
 			 !(capabilities & BDI_CAP_EXEC_MAP)
 			 ) {
 			/* backing file is not executable, try to copy */
 			capabilities &= ~BDI_CAP_MAP_DIRECT;
 		}
-	}
-	else {
+	} else {
 		/* anonymous mappings are always memory backed and can be
 		 * privately mapped
 		 */
@@ -1668,7 +1664,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	/* find the first potentially overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma) {
-		static int limit = 0;
+		static int limit;
 		if (limit < 5) {
 			printk(KERN_WARNING
 			       "munmap of memory not mmapped by process %d"
_

Patches currently in -mm which might be from yong@gnoy.org are

mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch

