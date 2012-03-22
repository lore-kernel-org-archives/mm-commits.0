From: akpm@linux-foundation.org
Subject: [merged] mmapc-fix-comment-for-__insert_vm_struct.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:22 -0700
Message-ID: <20120322201922.7299EA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58075 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030206Ab2CVUTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:24 -0400
Received: by bkcjm19 with SMTP id jm19so134271bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap.c: fix comment for __insert_vm_struct()
has been removed from the -mm tree.  Its filename was
     mmapc-fix-comment-for-__insert_vm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: mmap.c: fix comment for __insert_vm_struct()

The comment above __insert_vm_struct seems to suggest that this function
is also going to link the VMA with the anon_vma, but this is not true. 
This function only links the VMA to the mm->mm_rb tree and the mm->mmap
linked list.

[akpm@linux-foundation.org: improve comment layout and text]
Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct mm/mmap.c
--- a/mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct
+++ a/mm/mmap.c
@@ -451,9 +451,8 @@ static void vma_link(struct mm_struct *m
 }
 
 /*
- * Helper for vma_adjust in the split_vma insert case:
- * insert vm structure into list and rbtree and anon_vma,
- * but it has already been inserted into prio_tree earlier.
+ * Helper for vma_adjust() in the split_vma insert case: insert a vma into the
+ * mm's list and rbtree.  It has already been inserted into the prio_tree.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

origin.patch
um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch

