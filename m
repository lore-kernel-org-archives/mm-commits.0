From: akpm@linux-foundation.org
Subject: [patch 71/84] mm: make vm_brk killable
Date: Mon, 23 May 2016 16:25:42 -0700
Message-ID: <57439176.rkG7G13EeEyhfKE8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbcEWXZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, oleg@redhat.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: make vm_brk killable

Now that all the callers handle vm_brk failure we can change it wait for
mmap_sem killable to help oom_reaper to not get blocked just because
vm_brk gets blocked behind mmap_sem readers.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/mmap.c          |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-make-vm_brk-killable include/linux/mm.h
--- a/include/linux/mm.h~mm-make-vm_brk-killable
+++ a/include/linux/mm.h
@@ -2011,7 +2011,7 @@ static inline void mm_populate(unsigned
 #endif
 
 /* These take the mm semaphore themselves */
-extern unsigned long vm_brk(unsigned long, unsigned long);
+extern unsigned long __must_check vm_brk(unsigned long, unsigned long);
 extern int vm_munmap(unsigned long, size_t);
 extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
         unsigned long, unsigned long,
diff -puN mm/mmap.c~mm-make-vm_brk-killable mm/mmap.c
--- a/mm/mmap.c~mm-make-vm_brk-killable
+++ a/mm/mmap.c
@@ -2712,12 +2712,9 @@ unsigned long vm_brk(unsigned long addr,
 	unsigned long ret;
 	bool populate;
 
-	/*
-	 * XXX not all users are chcecking the return value, convert
-	 * to down_write_killable after they are able to cope with
-	 * error
-	 */
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	ret = do_brk(addr, len);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	up_write(&mm->mmap_sem);
_
