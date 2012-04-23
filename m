From: akpm@linux-foundation.org
Subject: + mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch added to -mm tree
Date: Mon, 23 Apr 2012 14:38:27 -0700
Message-ID: <20120423213827.BC44DA0162@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64138 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734Ab2DWVia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Apr 2012 17:38:30 -0400
Received: by laai8 with SMTP id i8so144laa.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 14:38:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rajman.mekaco@gmail.com, consul.kautuk@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm/mmap.c: find_vma(): remove unnecessary if(mm) check
has been added to the -mm tree.  Its filename is
     mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+	if (WARN_ON_ONCE(!mm))
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
Subject: Subject: mm/mmap.c: find_vma(): remove unnecessary if(mm) check

Patches currently in -mm which might be from rajman.mekaco@gmail.com are

mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch

