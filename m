From: akpm@linux-foundation.org
Subject: + mincore-add-support-for-puds.patch added to -mm tree
Date: Wed, 27 Jan 2016 12:27:00 -0800
Message-ID: <56a92814.2OilzxVgnpzlYWMR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967625AbcA0U1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:27:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, darrick.wong@oracle.com, david@fromorbit.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingming.cao@oracle.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mincore: add support for PUDs
has been added to the -mm tree.  Its filename is
     mincore-add-support-for-puds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mincore-add-support-for-puds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mincore-add-support-for-puds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mincore: add support for PUDs

We don't actually care about the contents of the PUD, as long as it's
present (which is checked by the pagewalk code), so just set the bits to
indicate presence and return.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mingming cao <mingming.cao@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mincore.c~mincore-add-support-for-puds mm/mincore.c
--- a/mm/mincore.c~mincore-add-support-for-puds
+++ a/mm/mincore.c
@@ -108,6 +108,18 @@ static int mincore_unmapped_range(unsign
 	return 0;
 }
 
+static int mincore_pud_range(pud_t *pud, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
+{
+	unsigned char *vec = walk->private;
+	int nr = (end - addr) >> PAGE_SHIFT;
+
+	memset(vec, 1, nr);
+	walk->private += nr;
+
+	return 0;
+}
+
 static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
@@ -177,6 +189,7 @@ static long do_mincore(unsigned long add
 	unsigned long end;
 	int err;
 	struct mm_walk mincore_walk = {
+		.pud_entry = mincore_pud_range,
 		.pmd_entry = mincore_pte_range,
 		.pte_hole = mincore_unmapped_range,
 		.hugetlb_entry = mincore_hugetlb,
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch

