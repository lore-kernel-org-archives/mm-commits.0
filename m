From: akpm@linux-foundation.org
Subject: [patch 081/142] userfaultfd: shmem: lock the page before adding
 it to pagecache
Date: Wed, 22 Feb 2017 15:43:49 -0800
Message-ID: <58ae2235.FKgnHQ/orHhPtUN6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934171AbdBVXnu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: shmem: lock the page before adding it to pagecache

A VM_BUG_ON triggered on the shmem selftest.

Link: http://lkml.kernel.org/r/20161216144821.5183-36-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/shmem.c~userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache
+++ a/mm/shmem.c
@@ -2245,6 +2245,10 @@ int shmem_mcopy_atomic_pte(struct mm_str
 		*pagep = NULL;
 	}
 
+	VM_BUG_ON(PageLocked(page) || PageSwapBacked(page));
+	__SetPageLocked(page);
+	__SetPageSwapBacked(page);
+
 	ret = mem_cgroup_try_charge(page, dst_mm, gfp, &memcg, false);
 	if (ret)
 		goto out_release;
@@ -2294,6 +2298,7 @@ out_release_uncharge_unlock:
 out_release_uncharge:
 	mem_cgroup_cancel_charge(page, memcg, false);
 out_release:
+	unlock_page(page);
 	put_page(page);
 out_dec_used_blocks:
 	if (sbinfo->max_blocks)
_
