From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-mremap_dontunmap-accounting-on-vma-merge.patch removed from -mm tree
Date: Mon, 20 Apr 2020 12:17:38 -0700
Message-ID: <20200420191738.Yc6IEt-y0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDTTRk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 15:17:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, dvyukov@google.com, jsbarnes@google.com, kirill.shutemov@linux.intel.com, lokeshgidra@google.com, luto@amacapital.net, minchan@kernel.org, mm-commits@vger.kernel.org, sonnyrao@google.com, syzkaller@googlegroups.com, vbabka@suse.cz


The patch titled
     Subject: mm: Fix MREMAP_DONTUNMAP accounting on VMA merge
has been removed from the -mm tree.  Its filename was
     mm-fix-mremap_dontunmap-accounting-on-vma-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm: Fix MREMAP_DONTUNMAP accounting on VMA merge

When remapping a mapping where a portion of a VMA is remapped
into another portion of the VMA it can cause the VMA to become
split. During the copy_vma operation the VMA can actually
be remerged if it's an anonymous VMA whose pages have not yet
been faulted. This isn't normally a problem because at the end
of the remap the original portion is unmapped causing it to
become split again.

However, MREMAP_DONTUNMAP leaves that original portion in place which
means that the VMA which was split and then remerged is not actually
split at the end of the mremap. This patch fixes a bug where
we don't detect that the VMAs got remerged and we end up
putting back VM_ACCOUNT on the next mapping which is completely
unreleated. When that next mapping is unmapped it results in
incorrectly unaccounting for the memory which was never accounted,
and eventually we will underflow on the memory comittment.

There is also another issue which is similar, we're currently
accouting for the number of pages in the new_vma but that's wrong.
We need to account for the length of the remap operation as that's
all that is being added. If there was a mapping already at that
location its comittment would have been adjusted as part of
the munmap at the start of the mremap.

A really simple repro can be seen in:
https://gist.github.com/bgaff/e101ce99da7d9a8c60acc641d07f312c

Link: http://lkml.kernel.org/r/20200417172556.217480-1-bgeffon@google.com
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Jesse Barnes <jsbarnes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-fix-mremap_dontunmap-accounting-on-vma-merge
+++ a/mm/mremap.c
@@ -413,9 +413,20 @@ static unsigned long move_vma(struct vm_
 			/* Always put back VM_ACCOUNT since we won't unmap */
 			vma->vm_flags |= VM_ACCOUNT;
 
-			vm_acct_memory(vma_pages(new_vma));
+			vm_acct_memory(new_len >> PAGE_SHIFT);
 		}
 
+		/*
+		 * VMAs can actually be merged back together in copy_vma
+		 * calling merge_vma. This can happen with anonymous vmas
+		 * which have not yet been faulted, so if we were to consider
+		 * this VMA split we'll end up adding VM_ACCOUNT on the
+		 * next VMA, which is completely unrelated if this VMA
+		 * was re-merged.
+		 */
+		if (split && new_vma == vma)
+			split = 0;
+
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
_

Patches currently in -mm which might be from bgeffon@google.com are
