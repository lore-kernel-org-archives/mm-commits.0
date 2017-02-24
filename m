From: akpm@linux-foundation.org
Subject: [patch 043/124] uprobes: split THPs before trying to replace them
Date: Fri, 24 Feb 2017 14:57:42 -0800
Message-ID: <58b0ba66.ecC+a3swuOrfe3d9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdBXW5o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: uprobes: split THPs before trying to replace them

Patch series "Fix few rmap-related THP bugs", v3.

The patchset fixes handing PTE-mapped THPs in page_referenced() and
page_idle_clear_pte_refs().

To achieve that I've intrdocued new helper -- page_vma_mapped_walk() --
which replaces all page_check_address{,_transhuge}() and covers all THP
cases.

Patchset overview:
  - First patch fixes one uprobe bug (unrelated to the rest of the
    patchset, just spotted it at the same time);

  - Patches 2-5 fix handling PTE-mapped THPs in page_referenced(),
    page_idle_clear_pte_refs() and rmap core;

  - Patches 6-12 convert all page_check_address{,_transhuge}() users (plus
    remove_migration_pte()) to page_vma_mapped_walk() and drop unused helpers.

I think the fixes are not critical enough for stable@ as they don't lead
to crashes or hangs, only suboptimal behaviour.



This patch (of 12):

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
