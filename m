From: akpm@linux-foundation.org
Subject: [patch 057/142] userfaultfd: non-cooperative: optimize
 mremap_userfaultfd_complete()
Date: Wed, 22 Feb 2017 15:42:37 -0800
Message-ID: <58ae21ed.5fI5xD7sMXGBS79m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934645AbdBVXmo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: optimize mremap_userfaultfd_complete()

Optimize the mremap_userfaultfd_complete() interface to pass only the
vm_userfaultfd_ctx pointer through the stack as a microoptimization.

Link: http://lkml.kernel.org/r/20161216144821.5183-13-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |    4 ++--
 include/linux/userfaultfd_k.h |    4 ++--
 mm/mremap.c                   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete
+++ a/fs/userfaultfd.c
@@ -608,11 +608,11 @@ void mremap_userfaultfd_prep(struct vm_a
 	}
 }
 
-void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx vm_ctx,
+void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *vm_ctx,
 				 unsigned long from, unsigned long to,
 				 unsigned long len)
 {
-	struct userfaultfd_ctx *ctx = vm_ctx.ctx;
+	struct userfaultfd_ctx *ctx = vm_ctx->ctx;
 	struct userfaultfd_wait_queue ewq;
 
 	if (!ctx)
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete
+++ a/include/linux/userfaultfd_k.h
@@ -57,7 +57,7 @@ extern void dup_userfaultfd_complete(str
 
 extern void mremap_userfaultfd_prep(struct vm_area_struct *,
 				    struct vm_userfaultfd_ctx *);
-extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx,
+extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *,
 					unsigned long from, unsigned long to,
 					unsigned long len);
 
@@ -100,7 +100,7 @@ static inline void mremap_userfaultfd_pr
 {
 }
 
-static inline void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx ctx,
+static inline void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *ctx,
 					       unsigned long from,
 					       unsigned long to,
 					       unsigned long len)
diff -puN mm/mremap.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete mm/mremap.c
--- a/mm/mremap.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete
+++ a/mm/mremap.c
@@ -608,6 +608,6 @@ out:
 	up_write(&current->mm->mmap_sem);
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
-	mremap_userfaultfd_complete(uf, addr, new_addr, old_len);
+	mremap_userfaultfd_complete(&uf, addr, new_addr, old_len);
 	return ret;
 }
_
