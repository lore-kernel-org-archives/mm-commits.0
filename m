From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:56 -0800
Message-ID: <54dd0114.b2ZXBa702susIFZp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbbBLTh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, pfeiner@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: add __get_user_pages_unlocked to customize gup_flags
has been removed from the -mm tree.  Its filename was
     mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: add __get_user_pages_unlocked to customize gup_flags

Some callers (like KVM) may want to set the gup_flags like FOLL_HWPOSION
to get a proper -EHWPOSION retval instead of -EFAULT to take a more
appropriate action if get_user_pages runs into a memory failure.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +++
 mm/gup.c           |   44 +++++++++++++++++++++++++++++++------------
 mm/nommu.c         |   16 ++++++++++++---
 3 files changed, 49 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags include/linux/mm.h
--- a/include/linux/mm.h~mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags
+++ a/include/linux/mm.h
@@ -1265,6 +1265,10 @@ long get_user_pages_locked(struct task_s
 		    unsigned long start, unsigned long nr_pages,
 		    int write, int force, struct page **pages,
 		    int *locked);
+long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			       unsigned long start, unsigned long nr_pages,
+			       int write, int force, struct page **pages,
+			       unsigned int gup_flags);
 long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
 		    unsigned long start, unsigned long nr_pages,
 		    int write, int force, struct page **pages);
diff -puN mm/gup.c~mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags mm/gup.c
--- a/mm/gup.c~mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags
+++ a/mm/gup.c
@@ -582,9 +582,9 @@ static __always_inline long __get_user_p
 						int write, int force,
 						struct page **pages,
 						struct vm_area_struct **vmas,
-						int *locked, bool notify_drop)
+						int *locked, bool notify_drop,
+						unsigned int flags)
 {
-	int flags = FOLL_TOUCH;
 	long ret, pages_done;
 	bool lock_dropped;
 
@@ -698,11 +698,37 @@ long get_user_pages_locked(struct task_s
 			   int *locked)
 {
 	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
-				       pages, NULL, locked, true);
+				       pages, NULL, locked, true, FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages_locked);
 
 /*
+ * Same as get_user_pages_unlocked(...., FOLL_TOUCH) but it allows to
+ * pass additional gup_flags as last parameter (like FOLL_HWPOISON).
+ *
+ * NOTE: here FOLL_TOUCH is not set implicitly and must be set by the
+ * caller if required (just like with __get_user_pages). "FOLL_GET",
+ * "FOLL_WRITE" and "FOLL_FORCE" are set implicitly as needed
+ * according to the parameters "pages", "write", "force"
+ * respectively.
+ */
+__always_inline long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+					       unsigned long start, unsigned long nr_pages,
+					       int write, int force, struct page **pages,
+					       unsigned int gup_flags)
+{
+	long ret;
+	int locked = 1;
+	down_read(&mm->mmap_sem);
+	ret = __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				      pages, NULL, &locked, false, gup_flags);
+	if (locked)
+		up_read(&mm->mmap_sem);
+	return ret;
+}
+EXPORT_SYMBOL(__get_user_pages_unlocked);
+
+/*
  * get_user_pages_unlocked() is suitable to replace the form:
  *
  *      down_read(&mm->mmap_sem);
@@ -723,14 +749,8 @@ long get_user_pages_unlocked(struct task
 			     unsigned long start, unsigned long nr_pages,
 			     int write, int force, struct page **pages)
 {
-	long ret;
-	int locked = 1;
-	down_read(&mm->mmap_sem);
-	ret = __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
-				      pages, NULL, &locked, false);
-	if (locked)
-		up_read(&mm->mmap_sem);
-	return ret;
+	return __get_user_pages_unlocked(tsk, mm, start, nr_pages, write,
+					 force, pages, FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
@@ -794,7 +814,7 @@ long get_user_pages(struct task_struct *
 		int force, struct page **pages, struct vm_area_struct **vmas)
 {
 	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
-				       pages, vmas, NULL, false);
+				       pages, vmas, NULL, false, FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages);
 
diff -puN mm/nommu.c~mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags mm/nommu.c
--- a/mm/nommu.c~mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags
+++ a/mm/nommu.c
@@ -224,9 +224,10 @@ long get_user_pages_locked(struct task_s
 }
 EXPORT_SYMBOL(get_user_pages_locked);
 
-long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
-			     unsigned long start, unsigned long nr_pages,
-			     int write, int force, struct page **pages)
+long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			       unsigned long start, unsigned long nr_pages,
+			       int write, int force, struct page **pages,
+			       unsigned int gup_flags)
 {
 	long ret;
 	down_read(&mm->mmap_sem);
@@ -235,6 +236,15 @@ long get_user_pages_unlocked(struct task
 	up_read(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL(__get_user_pages_unlocked);
+
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long start, unsigned long nr_pages,
+			     int write, int force, struct page **pages)
+{
+	return __get_user_pages_unlocked(tsk, mm, start, nr_pages, write,
+					 force, pages, 0);
+}
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
 /**
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
linux-next.patch

