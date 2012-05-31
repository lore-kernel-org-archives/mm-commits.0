From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:06 -0700
Message-ID: <20120531191406.A63F6A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:45989 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab2EaTOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:09 -0400
Received: by were53 with SMTP id e53so75800wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rajman.mekaco@gmail.com, consul.kautuk@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: find_vma(): remove unnecessary if(mm) check
has been removed from the -mm tree.  Its filename was
     mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rajman Mekaco <rajman.mekaco@gmail.com>
Subject: mm/mmap.c: find_vma(): remove unnecessary if(mm) check

The if(mm) check is not required in find_vma, as the kernel code calls
find_vma only when it is absolutely sure that the mm_struct arg to it is
non-NULL.

Remove the if(mm) check and adding the a WARN_ONCE(!mm) for now.  This
will serve the purpose of mandating that the execution
context(user-mode/kernel-mode) be known before find_vma is called.  Also
fixed 2 checkpatch.pl errors in the declaration of the rb_node and vma_tmp
local variables.

I was browsing through the internet and read a discussion at
https://lkml.org/lkml/2012/3/27/342 which discusses removal of the
validation check within find_vma.  Since no-one responded, I decided to
send this patch with Andrew's suggestions.

[akpm@linux-foundation.org: add remove-me comment]
Signed-off-by: Rajman Mekaco <rajman.mekaco@gmail.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   53 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-find_vma-remove-unnecessary-ifmm-check mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-find_vma-remove-unnecessary-ifmm-check
+++ a/mm/mmap.c
@@ -1639,33 +1639,34 @@ struct vm_area_struct *find_vma(struct m
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (mm) {
-		/* Check the cache first. */
-		/* (Cache hit rate is typically around 35%.) */
-		vma = mm->mmap_cache;
-		if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
-			struct rb_node * rb_node;
-
-			rb_node = mm->mm_rb.rb_node;
-			vma = NULL;
-
-			while (rb_node) {
-				struct vm_area_struct * vma_tmp;
-
-				vma_tmp = rb_entry(rb_node,
-						struct vm_area_struct, vm_rb);
-
-				if (vma_tmp->vm_end > addr) {
-					vma = vma_tmp;
-					if (vma_tmp->vm_start <= addr)
-						break;
-					rb_node = rb_node->rb_left;
-				} else
-					rb_node = rb_node->rb_right;
-			}
-			if (vma)
-				mm->mmap_cache = vma;
+	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
+		return NULL;
+
+	/* Check the cache first. */
+	/* (Cache hit rate is typically around 35%.) */
+	vma = mm->mmap_cache;
+	if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
+		struct rb_node *rb_node;
+
+		rb_node = mm->mm_rb.rb_node;
+		vma = NULL;
+
+		while (rb_node) {
+			struct vm_area_struct *vma_tmp;
+
+			vma_tmp = rb_entry(rb_node,
+					   struct vm_area_struct, vm_rb);
+
+			if (vma_tmp->vm_end > addr) {
+				vma = vma_tmp;
+				if (vma_tmp->vm_start <= addr)
+					break;
+				rb_node = rb_node->rb_left;
+			} else
+				rb_node = rb_node->rb_right;
 		}
+		if (vma)
+			mm->mmap_cache = vma;
 	}
 	return vma;
 }
_

Patches currently in -mm which might be from rajman.mekaco@gmail.com are

origin.patch

