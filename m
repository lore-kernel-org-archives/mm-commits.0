From: akpm@linux-foundation.org
Subject: + mm-clarify-mm_structmm_userscount-documentation.patch added to
 -mm tree
Date: Mon, 09 Jan 2017 15:20:40 -0800
Message-ID: <58741ac8.ro3eb5WWMvhrpPQZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932083AbdAIXTN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 18:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@oracle.com, mhocko@suse.com, peterz@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify mm_struct.mm_{users,count} documentation
has been added to the -mm tree.  Its filename is
     mm-clarify-mm_structmm_userscount-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-mm_structmm_userscount-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-mm_structmm_userscount-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-new-mmgrab-helper.patch
mm-add-new-mmget-helper.patch
mm-use-mmget_not_zero-helper.patch
mm-clarify-mm_structmm_userscount-documentation.patch

