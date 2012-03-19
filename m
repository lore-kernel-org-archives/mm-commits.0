From: akpm@linux-foundation.org
Subject: + mmapc-fix-comment-for-__insert_vm_struct.patch added to -mm tree
Date: Mon, 19 Mar 2012 16:16:54 -0700
Message-ID: <20120319231655.63A4AA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34317 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2CSXQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 19:16:58 -0400
Received: by bkcjm19 with SMTP id jm19so321183bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 16:16:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mmap.c: fix comment for __insert_vm_struct()
has been added to the -mm tree.  Its filename is
     mmapc-fix-comment-for-__insert_vm_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: mmap.c: fix comment for __insert_vm_struct()

The comment above __insert_vm_struct seems to suggest that this function
is also going to link the VMA with the anon_vma, but this is not true. 
This function only links the VMA to the mm->mm_rb tree and the mm->mmap
linked list.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct mm/mmap.c
--- a/mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct
+++ a/mm/mmap.c
@@ -453,8 +453,8 @@ static void vma_link(struct mm_struct *m
 
 /*
  * Helper for vma_adjust in the split_vma insert case:
- * insert vm structure into list and rbtree and anon_vma,
- * but it has already been inserted into prio_tree earlier.
+ * insert vm structure into list and rbtree, but it has
+ * already been inserted into prio_tree earlier.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
_
Subject: Subject: mmap.c: fix comment for __insert_vm_struct()

Patches currently in -mm which might be from consul.kautuk@gmail.com are

rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
page_allocc-remove-add_from_early_node_map.patch
page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch

