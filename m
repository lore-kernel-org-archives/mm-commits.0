From: akpm@linux-foundation.org
Subject: +
 procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch added
 to -mm tree
Date: Mon, 14 Oct 2013 14:54:09 -0700
Message-ID: <525c6801.cSF0Rdn7/cXCE989%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3JNVyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 17:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, d.hatayama@jp.fujitsu.com

Subject: + procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch added to -mm tree
To: d.hatayama@jp.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 14:54:09 -0700


The patch titled
     Subject: procfs: clean up proc_reg_get_unmapped_area for 80-column limit
has been added to the -mm tree.  Its filename is
     procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: procfs: clean up proc_reg_get_unmapped_area for 80-column limit

Clean up proc_reg_get_unmapped_area due to its 80-column limit
violation.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/proc/inode.c~procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit
+++ a/fs/proc/inode.c
@@ -285,19 +285,23 @@ static int proc_reg_mmap(struct file *fi
 	return rv;
 }
 
-static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
+static unsigned long
+proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
+			   unsigned long len, unsigned long pgoff,
+			   unsigned long flags)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned long rv = -EIO;
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long) = NULL;
+	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
+				  unsigned long, unsigned long) = NULL;
 	if (use_pde(pde)) {
 #ifdef CONFIG_MMU
-		get_unmapped_area = current->mm->get_unmapped_area;
+		get_area = current->mm->get_unmapped_area;
 #endif
 		if (pde->proc_fops->get_unmapped_area)
-			get_unmapped_area = pde->proc_fops->get_unmapped_area;
-		if (get_unmapped_area)
-			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
+			get_area = pde->proc_fops->get_unmapped_area;
+		if (get_area)
+			rv = get_area(file, orig_addr, len, pgoff, flags);
 		unuse_pde(pde);
 	}
 	return rv;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

procfs-fix-unintended-truncation-of-returned-mapped-address.patch
procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch
procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch

