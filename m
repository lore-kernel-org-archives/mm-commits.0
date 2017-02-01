From: akpm@linux-foundation.org
Subject: + uprobes-split-thps-before-trying-replace-them.patch added to
 -mm tree
Date: Tue, 31 Jan 2017 16:10:01 -0800
Message-ID: <58912759.O5cTLDph7bCB9kli%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdBAAKD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uprobes: split THPs before trying replace them
has been added to the -mm tree.  Its filename is
     uprobes-split-thps-before-trying-replace-them.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uprobes-split-thps-before-trying-replace-them.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uprobes-split-thps-before-trying-replace-them.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: uprobes: split THPs before trying replace them

For THPs page_check_address() always fails.  It leads to endless loop in
uprobe_write_opcode().

Testcase with huge-tmpfs (uprobes cannot probe anonymous memory).

	mount -t debugfs none /sys/kernel/debug
	mount -t tmpfs -o huge=always none /mnt
	gcc -Wall -O2 -o /mnt/test -x c - <<EOF
	int main(void)
	{
		return 0;
	}
	/* Padding to map the code segment with huge pmd */
	asm (".zero 2097152");
	EOF
	echo 'p /mnt/test:0' > /sys/kernel/debug/tracing/uprobe_events
	echo 1 > /sys/kernel/debug/tracing/events/uprobes/enable
	/mnt/test

Let's split THPs before trying to replace.

Link: http://lkml.kernel.org/r/20170129173858.45174-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/events/uprobes.c~uprobes-split-thps-before-trying-replace-them kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~uprobes-split-thps-before-trying-replace-them
+++ a/kernel/events/uprobes.c
@@ -300,8 +300,8 @@ int uprobe_write_opcode(struct mm_struct
 
 retry:
 	/* Read the page with vaddr into memory */
-	ret = get_user_pages_remote(NULL, mm, vaddr, 1, FOLL_FORCE, &old_page,
-			&vma, NULL);
+	ret = get_user_pages_remote(NULL, mm, vaddr, 1,
+			FOLL_FORCE | FOLL_SPLIT, &old_page, &vma, NULL);
 	if (ret <= 0)
 		return ret;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-sleeping-function-called-from-invalid-context-shmem_undo_range.patch
mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch
uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

