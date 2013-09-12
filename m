From: akpm@linux-foundation.org
Subject: [merged] mm-madvisec-fix-coding-style-errors.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:42:13 -0700
Message-ID: <52321915.YKdpYbGIHbr2BTZ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, gg.kaspersky@gmail.com

Subject: [merged] mm-madvisec-fix-coding-style-errors.patch removed from -mm tree
To: gg.kaspersky@gmail.com,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:13 -0700


The patch titled
     Subject: mm/madvise.c: fix coding-style errors
has been removed from the -mm tree.  Its filename was
     mm-madvisec-fix-coding-style-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Cernov <gg.kaspersky@gmail.com>
Subject: mm/madvise.c: fix coding-style errors

This fixes following errors:
	- ERROR: "(foo*)" should be "(foo *)"
	- ERROR: "foo ** bar" should be "foo **bar"

Signed-off-by: Vladimir Cernov <gg.kaspersky@gmail.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/madvise.c~mm-madvisec-fix-coding-style-errors mm/madvise.c
--- a/mm/madvise.c~mm-madvisec-fix-coding-style-errors
+++ a/mm/madvise.c
@@ -42,11 +42,11 @@ static int madvise_need_mmap_write(int b
  * We can potentially split a vm area into separate
  * areas, each area with its own behavior.
  */
-static long madvise_behavior(struct vm_area_struct * vma,
+static long madvise_behavior(struct vm_area_struct *vma,
 		     struct vm_area_struct **prev,
 		     unsigned long start, unsigned long end, int behavior)
 {
-	struct mm_struct * mm = vma->vm_mm;
+	struct mm_struct *mm = vma->vm_mm;
 	int error = 0;
 	pgoff_t pgoff;
 	unsigned long new_flags = vma->vm_flags;
@@ -215,8 +215,8 @@ static void force_shm_swapin_readahead(s
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
-static long madvise_willneed(struct vm_area_struct * vma,
-			     struct vm_area_struct ** prev,
+static long madvise_willneed(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
 	struct file *file = vma->vm_file;
@@ -270,8 +270,8 @@ static long madvise_willneed(struct vm_a
  * An interface that causes the system to free clean pages and flush
  * dirty pages is already available as msync(MS_INVALIDATE).
  */
-static long madvise_dontneed(struct vm_area_struct * vma,
-			     struct vm_area_struct ** prev,
+static long madvise_dontneed(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
 	*prev = vma;
@@ -459,7 +459,7 @@ madvise_behavior_valid(int behavior)
 SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
 	unsigned long end, tmp;
-	struct vm_area_struct * vma, *prev;
+	struct vm_area_struct *vma, *prev;
 	int unmapped_error = 0;
 	int error = -EINVAL;
 	int write;
_

Patches currently in -mm which might be from gg.kaspersky@gmail.com are

origin.patch

