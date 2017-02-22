From: akpm@linux-foundation.org
Subject: [patch 050/142] userfaultfd: use vma_is_anonymous
Date: Wed, 22 Feb 2017 15:42:15 -0800
Message-ID: <58ae21d7.640U2wCODcHTtE3E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934354AbdBVXmR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: use vma_is_anonymous

Cleanup the vma->vm_ops usage.

Side note: it would be more robust if vma_is_anonymous() would also
check that vm_flags hasn't VM_PFNMAP set.

Link: http://lkml.kernel.org/r/20161216144821.5183-5-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    8 ++++----
 mm/userfaultfd.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-use-vma_is_anonymous fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-use-vma_is_anonymous
+++ a/fs/userfaultfd.c
@@ -830,7 +830,7 @@ static int userfaultfd_register(struct u
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (cur->vm_ops)
+		if (!vma_is_anonymous(cur))
 			goto out_unlock;
 
 		/*
@@ -855,7 +855,7 @@ static int userfaultfd_register(struct u
 	do {
 		cond_resched();
 
-		BUG_ON(vma->vm_ops);
+		BUG_ON(!vma_is_anonymous(vma));
 		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
 		       vma->vm_userfaultfd_ctx.ctx != ctx);
 
@@ -981,7 +981,7 @@ static int userfaultfd_unregister(struct
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (cur->vm_ops)
+		if (!vma_is_anonymous(cur))
 			goto out_unlock;
 
 		found = true;
@@ -995,7 +995,7 @@ static int userfaultfd_unregister(struct
 	do {
 		cond_resched();
 
-		BUG_ON(vma->vm_ops);
+		BUG_ON(!vma_is_anonymous(vma));
 
 		/*
 		 * Nothing to do: this vma is already registered into this
diff -puN mm/userfaultfd.c~userfaultfd-use-vma_is_anonymous mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-use-vma_is_anonymous
+++ a/mm/userfaultfd.c
@@ -197,7 +197,7 @@ retry:
 	 * FIXME: only allow copying on anonymous vmas, tmpfs should
 	 * be added.
 	 */
-	if (dst_vma->vm_ops)
+	if (!vma_is_anonymous(dst_vma))
 		goto out_unlock;
 
 	/*
_
