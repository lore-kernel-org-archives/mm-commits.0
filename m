From: akpm@linux-foundation.org
Subject: + madvise_need_mmap_write-usage.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:37:08 -0700
Message-ID: <200706260437.l5Q4b84P018445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbXFZEhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, hch@lst.de, nacc@us.ibm.com, nickpiggin@yahoo.com.au


The patch titled
     speed up madvise_need_mmap_write() usage
has been added to the -mm tree.  Its filename is
     madvise_need_mmap_write-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: speed up madvise_need_mmap_write() usage
From: Jason Baron <jbaron@redhat.com>

In the new madvise_need_mmap_write() call we can avoid an extra case
statement and function call as follows.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~madvise_need_mmap_write-usage mm/madvise.c
--- a/mm/madvise.c~madvise_need_mmap_write-usage
+++ a/mm/madvise.c
@@ -287,9 +287,11 @@ asmlinkage long sys_madvise(unsigned lon
 	struct vm_area_struct * vma, *prev;
 	int unmapped_error = 0;
 	int error = -EINVAL;
+	int write;
 	size_t len;
 
-	if (madvise_need_mmap_write(behavior))
+	write = madvise_need_mmap_write(behavior);
+	if (write)
 		down_write(&current->mm->mmap_sem);
 	else
 		down_read(&current->mm->mmap_sem);
@@ -354,7 +356,7 @@ asmlinkage long sys_madvise(unsigned lon
 			vma = find_vma(current->mm, start);
 	}
 out:
-	if (madvise_need_mmap_write(behavior))
+	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
 		up_read(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from jbaron@redhat.com are

madvise_need_mmap_write-usage.patch
lockdep-sanitise-config_prove_locking.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
