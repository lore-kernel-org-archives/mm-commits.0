From: akpm@linux-foundation.org
Subject: + mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch added to -mm tree
Date: Tue, 11 Sep 2012 16:01:32 -0700
Message-ID: <20120911230133.093395C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:59598 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2IKXBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 19:01:35 -0400
Received: by weyr1 with SMTP id r1so72972wey.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 16:01:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haggaie@mellanox.com, minchan@kernel.org


The patch titled
     Subject: mm: Fix compiler warning in copy_page_range
has been added to the -mm tree.  Its filename is
     mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haggai Eran <haggaie@mellanox.com>
Subject: mm: Fix compiler warning in copy_page_range

This patch fixes the warning about mmun_start/end used uninitialized in
copy_page_range, by initializing them regardless of whether the notifiers are
actually called.  It also makes sure the vm_flags in copy_page_range are only
read once.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix mm/memory.c
--- a/mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix
+++ a/mm/memory.c
@@ -712,7 +712,7 @@ static void print_bad_pte(struct vm_area
 	add_taint(TAINT_BAD_PAGE);
 }
 
-static inline int is_cow_mapping(vm_flags_t flags)
+static inline bool is_cow_mapping(vm_flags_t flags)
 {
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
@@ -1041,6 +1041,7 @@ int copy_page_range(struct mm_struct *ds
 	unsigned long end = vma->vm_end;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	bool is_cow;
 	int ret;
 
 	/*
@@ -1074,12 +1075,12 @@ int copy_page_range(struct mm_struct *ds
 	 * parent mm. And a permission downgrade will only happen if
 	 * is_cow_mapping() returns true.
 	 */
-	if (is_cow_mapping(vma->vm_flags)) {
-		mmun_start = addr;
-		mmun_end   = end;
+	is_cow = is_cow_mapping(vma->vm_flags);
+	mmun_start = addr;
+	mmun_end   = end;
+	if (is_cow)
 		mmu_notifier_invalidate_range_start(src_mm, mmun_start,
 						    mmun_end);
-	}
 
 	ret = 0;
 	dst_pgd = pgd_offset(dst_mm, addr);
@@ -1095,7 +1096,7 @@ int copy_page_range(struct mm_struct *ds
 		}
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (is_cow)
 		mmu_notifier_invalidate_range_end(src_mm, mmun_start, mmun_end);
 	return ret;
 }
_

Patches currently in -mm which might be from haggaie@mellanox.com are

linux-next.patch
mm-mmu_notifier-have-mmu_notifiers-use-a-global-srcu-so-they-may-safely-schedule.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch

