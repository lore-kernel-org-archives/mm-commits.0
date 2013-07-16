From: akpm@linux-foundation.org
Subject: + mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch added to -mm tree
Date: Tue, 16 Jul 2013 14:43:30 -0700
Message-ID: <51e5be82.zKQ2rJDUzj5im3TZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab3GPVnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 17:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, ccross@android.com, oleg@redhat.com

Subject: + mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch added to -mm tree
To: oleg@redhat.com,ccross@android.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 14:43:30 -0700


The patch titled
     Subject: mm: do_mmap_pgoff: cleanup the usage of file_inode()
has been added to the -mm tree.  Its filename is
     mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
