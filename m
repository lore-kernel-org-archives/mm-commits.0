From: akpm@linux-foundation.org
Subject: [patch 68/84] mm: make vm_munmap killable
Date: Mon, 23 May 2016 16:25:33 -0700
Message-ID: <5743916d.r/qDxaNkzOAq3Wj3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbcEWXZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, oleg@redhat.com, vbabka@suse.cz, viro@zeniv.linux.org.uk

From: Michal Hocko <mhocko@suse.com>
Subject: mm: make vm_munmap killable

Almost all current users of vm_munmap are ignoring the return value and so
they do not handle potential error.  This means that some VMAs might stay
behind.  This patch doesn't try to solve those potential problems.  Quite
contrary it adds a new failure mode by using down_write_killable in
vm_munmap.  This should be safer than other failure modes, though, because
the process is guaranteed to die as soon as it leaves the kernel and
exit_mmap will clean the whole address space.

This will help in the OOM conditions when the oom victim might be stuck
waiting for the mmap_sem for write which in turn can block oom_reaper
which relies on the mmap_sem for read to make a forward progress and
reclaim the address space of the victim.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~mm-make-vm_munmap-killable mm/mmap.c
--- a/mm/mmap.c~mm-make-vm_munmap-killable
+++ a/mm/mmap.c
@@ -2494,11 +2494,9 @@ int vm_munmap(unsigned long start, size_
 	int ret;
 	struct mm_struct *mm = current->mm;
 
-	/*
-	 * XXX convert to down_write_killable as soon as all users are able
-	 * to handle the error.
-	 */
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	ret = do_munmap(mm, start, len);
 	up_write(&mm->mmap_sem);
 	return ret;
_
