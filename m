From: akpm@linux-foundation.org
Subject: + mm-introduce-vma_is_anonymousvma-helper.patch added to -mm tree
Date: Fri, 10 Jul 2015 14:52:30 -0700
Message-ID: <55a03e9e.PBzWqDMllw51lMbx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbGJVwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, luto@kernel.org, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce vma_is_anonymous(vma) helper
has been added to the -mm tree.  Its filename is
     mm-introduce-vma_is_anonymousvma-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-vma_is_anonymousvma-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-vma_is_anonymousvma-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: introduce vma_is_anonymous(vma) helper

special_mapping_fault() is absolutely broken.  It seems it was always
wrong, but this didn't matter until vdso/vvar started to use more than one
page.

And after this change vma_is_anonymous() becomes really trivial, it simply
checks vm_ops == NULL.  However, I do think the helper makes sense.  There
are a lot of ->vm_ops != NULL checks, the helper makes the caller's code
more understandable (self-documented) and this is more grep-friendly.


This patch (of 3):

Preparation.  Add the new simple helper, vma_is_anonymous(vma), and change
handle_pte_fault() to use it.  It will have more users.

The name is not accurate, say a hpet_mmap()'ed vma is not anonymous. 
Perhaps it should be named vma_has_fault() instead.  But it matches the
logic in mmap.c/memory.c (see next changes).  "True" just means that a
page fault will use do_anonymous_page().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 mm/memory.c        |    8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-vma_is_anonymousvma-helper include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-vma_is_anonymousvma-helper
+++ a/include/linux/mm.h
@@ -1233,6 +1233,11 @@ static inline int vma_growsdown(struct v
 	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
 }
 
+static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+{
+	return !vma->vm_ops;
+}
+
 static inline int stack_guard_page_start(struct vm_area_struct *vma,
 					     unsigned long addr)
 {
diff -puN mm/memory.c~mm-introduce-vma_is_anonymousvma-helper mm/memory.c
--- a/mm/memory.c~mm-introduce-vma_is_anonymousvma-helper
+++ a/mm/memory.c
@@ -3267,12 +3267,12 @@ static int handle_pte_fault(struct mm_st
 	barrier();
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
-			if (vma->vm_ops)
+			if (vma_is_anonymous(vma))
+				return do_anonymous_page(mm, vma, address,
+							 pte, pmd, flags);
+			else
 				return do_fault(mm, vma, address, pte, pmd,
 						flags, entry);
