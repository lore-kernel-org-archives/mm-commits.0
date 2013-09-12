From: akpm@linux-foundation.org
Subject: [merged] mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:21 -0700
Message-ID: <5232191d.rYpJyeOAkBWCcOND%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3ILTmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, ccross@android.com, oleg@redhat.com

Subject: [merged] mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch removed from -mm tree
To: oleg@redhat.com,ccross@android.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:21 -0700


The patch titled
     Subject: mm: do_mmap_pgoff: cleanup the usage of file_inode()
has been removed from the -mm tree.  Its filename was
     mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: do_mmap_pgoff: cleanup the usage of file_inode()

Simple cleanup.  Move "struct inode *inode" variable into "if (file)"
block to simplify the code and avoid the unnecessary check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@android.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode mm/mmap.c
--- a/mm/mmap.c~mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode
+++ a/mm/mmap.c
@@ -1202,7 +1202,6 @@ unsigned long do_mmap_pgoff(struct file
 			unsigned long *populate)
 {
 	struct mm_struct * mm = current->mm;
-	struct inode *inode;
 	vm_flags_t vm_flags;
 
 	*populate = 0;
@@ -1265,9 +1264,9 @@ unsigned long do_mmap_pgoff(struct file
 			return -EAGAIN;
 	}
 
-	inode = file ? file_inode(file) : NULL;
