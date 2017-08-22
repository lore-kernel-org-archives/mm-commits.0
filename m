From: akpm@linux-foundation.org
Subject: + dax-fix-deadlock-due-to-misaligned-pmd-faults.patch added to
 -mm tree
Date: Tue, 22 Aug 2017 15:52:50 -0700
Message-ID: <599cb5c2.Qh/TSFCCJDP7oPTk%akpm__9746.6082698249$1503442376$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbdHVWww (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, marcin.slusarz@intel.com, mawilcox@microsoft.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix deadlock due to misaligned PMD faults
has been added to the -mm tree.  Its filename is
     dax-fix-deadlock-due-to-misaligned-pmd-faults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-deadlock-due-to-misaligned-pmd-faults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-deadlock-due-to-misaligned-pmd-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix deadlock due to misaligned PMD faults

In DAX there are two separate places where the 2MiB range of a PMD is
defined.

The first is in the page tables, where a PMD mapping inserted for a given
address spans from (vmf->address & PMD_MASK) to ((vmf->address & PMD_MASK)
+ PMD_SIZE - 1).  That is, from the 2MiB boundary below the address to the
2MiB boundary above the address.

So, for example, a fault at address 3MiB (0x30 0000) falls within the PMD
that ranges from 2MiB (0x20 0000) to 4MiB (0x40 0000).

The second PMD range is in the mapping->page_tree, where a given file
offset is covered by a radix tree entry that spans from one 2MiB aligned
file offset to another 2MiB aligned file offset.

So, for example, the file offset for 3MiB (pgoff 768) falls within the PMD
range for the order 9 radix tree entry that ranges from 2MiB (pgoff 512)
to 4MiB (pgoff 1024).

This system works so long as the addresses and file offsets for a given
mapping both have the same offsets relative to the start of each PMD.

Consider the case where the starting address for a given file isn't 2MiB
aligned - say our faulting address is 3 MiB (0x30 0000), but that
corresponds to the beginning of our file (pgoff 0).  Now all the PMDs in
the mapping are misaligned so that the 2MiB range defined in the page
tables never matches up with the 2MiB range defined in the radix tree.

The current code notices this case for DAX faults to storage with the
following test in dax_pmd_insert_mapping():

	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
		goto unlock_fallback;

This test makes sure that the pfn we get from the driver is 2MiB aligned,
and relies on the assumption that the 2MiB alignment of the pfn we get
back from the driver matches the 2MiB alignment of the faulting address.

However, faults to holes were not checked and we could hit the problem
described above.

This was reported in response to the NVML nvml/src/test/pmempool_sync
TEST5:

	$ cd nvml/src/test/pmempool_sync
	$ make TEST5

You can grab NVML here:

	https://github.com/pmem/nvml/

The dmesg warning you see when you hit this error is:

WARNING: CPU: 13 PID: 2900 at fs/dax.c:641 dax_insert_mapping_entry+0x2df/0x310

Where we notice in dax_insert_mapping_entry() that the radix tree entry we
are about to replace doesn't match the locked entry that we had previously
inserted into the tree.  This happens because the initial insertion was
done in grab_mapping_entry() using a pgoff calculated from the faulting
address (vmf->address), and the replacement in dax_pmd_load_hole() =>
dax_insert_mapping_entry() is done using vmf->pgoff.

In our failure case those two page offsets (one calculated from
vmf->address, one using vmf->pgoff) point to different order 9 radix tree
entries.

This failure case can result in a deadlock because the radix tree unlock
also happens on the pgoff calculated from vmf->address.  This means that
the locked radix tree entry that we swapped in to the tree in
dax_insert_mapping_entry() using vmf->pgoff is never unlocked, so all
future faults to that 2MiB range will block forever.

Fix this by validating that the faulting address's PMD offset matches the
PMD offset from the start of the file.  This check is done at the very
beginning of the fault and covers faults that would have mapped to storage
as well as faults to holes.  I left the COLOUR check in
dax_pmd_insert_mapping() in place in case we ever hit the insanity
condition where the alignment of the pfn we get from the driver doesn't
match the alignment of the userspace address.

Link: http://lkml.kernel.org/r/20170822222436.18926-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: "Slusarz, Marcin" <marcin.slusarz@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/dax.c~dax-fix-deadlock-due-to-misaligned-pmd-faults fs/dax.c
--- a/fs/dax.c~dax-fix-deadlock-due-to-misaligned-pmd-faults
+++ a/fs/dax.c
@@ -1383,6 +1383,16 @@ static int dax_iomap_pmd_fault(struct vm
 
 	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
 
+	/*
+	 * Make sure that the faulting address's PMD offset (color) matches
+	 * the PMD offset from the start of the file.  This is necessary so
+	 * that a PMD range in the page table overlaps exactly with a PMD
+	 * range in the radix tree.
+	 */
+	if ((vmf->pgoff & PG_PMD_COLOUR) !=
+	    ((vmf->address >> PAGE_SHIFT) & PG_PMD_COLOUR))
+		goto fallback;
+
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED))
 		goto fallback;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-deadlock-due-to-misaligned-pmd-faults.patch
dax-use-pg_pmd_colour-instead-of-open-coding.patch
mm-add-vm_insert_mixed_mkwrite.patch
dax-relocate-some-dax-functions.patch
dax-use-common-4k-zero-page-for-dax-mmap-reads.patch
dax-remove-dax-code-from-page_cache_tree_insert.patch
dax-move-all-dax-radix-tree-defs-to-fs-daxc.patch
dax-explain-how-read2-write2-addresses-are-validated.patch

