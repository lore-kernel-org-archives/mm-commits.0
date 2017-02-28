From: akpm@linux-foundation.org
Subject: [merged] mm-clarify-mm_structmm_userscount-documentation.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:52:17 -0800
Message-ID: <58b5e301.QU8u0acIVagWlgTv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdB1UwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:52:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@oracle.com, mhocko@suse.com, peterz@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify mm_struct.mm_{users,count} documentation
has been removed from the -mm tree.  Its filename was
     mm-clarify-mm_structmm_userscount-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: clarify mm_struct.mm_{users,count} documentation

Clarify documentation relating to mm_users and mm_count, and switch to
kernel-doc syntax.

Link: http://lkml.kernel.org/r/20161218123229.22952-4-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-clarify-mm_structmm_userscount-documentation include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-clarify-mm_structmm_userscount-documentation
+++ a/include/linux/mm_types.h
@@ -407,8 +407,27 @@ struct mm_struct {
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long highest_vm_end;		/* highest vma end address */
 	pgd_t * pgd;
-	atomic_t mm_users;			/* How many users with user space? */
-	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
+
+	/**
+	 * @mm_users: The number of users including userspace.
+	 *
+	 * Use mmget()/mmget_not_zero()/mmput() to modify. When this drops
+	 * to 0 (i.e. when the task exits and there are no other temporary
+	 * reference holders), we also release a reference on @mm_count
+	 * (which may then free the &struct mm_struct if @mm_count also
+	 * drops to 0).
+	 */
+	atomic_t mm_users;
+
+	/**
+	 * @mm_count: The number of references to &struct mm_struct
+	 * (@mm_users count as 1).
+	 *
+	 * Use mmgrab()/mmdrop() to modify. When this drops to 0, the
+	 * &struct mm_struct is freed.
+	 */
+	atomic_t mm_count;
+
 	atomic_long_t nr_ptes;			/* PTE page table pages */
 #if CONFIG_PGTABLE_LEVELS > 2
 	atomic_long_t nr_pmds;			/* PMD page table pages */
_

Patches currently in -mm which might be from vegard.nossum@oracle.com are


