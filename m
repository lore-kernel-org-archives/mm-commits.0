From: akpm@linux-foundation.org
Subject: + dax-fix-race-between-colliding-pmd-pte-entries.patch added to
 -mm tree
Date: Tue, 23 May 2017 15:58:53 -0700
Message-ID: <5924bead.cz0hUdPPvTLdfi3v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765007AbdEWW6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 May 2017 18:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, darrick.wong@oracle.com, dave.hansen@intel.com, dave.jiang@intel.com, eguan@redhat.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, pawel.lebioda@intel.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, xzhou@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix race between colliding PMD & PTE entries
has been added to the -mm tree.  Its filename is
     dax-fix-race-between-colliding-pmd-pte-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-race-between-colliding-pmd-pte-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-race-between-colliding-pmd-pte-entries.patch

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
Subject: dax: fix race between colliding PMD & PTE entries

We currently have two related PMD vs PTE races in the DAX code.  These can
both be easily triggered by having two threads reading and writing
simultaneously to the same private mapping, with the key being that
private mapping reads can be handled with PMDs but private mapping writes
are always handled with PTEs so that we can COW.

Here is the first race:

CPU 0					CPU 1

(private mapping write)
__handle_mm_fault()
  create_huge_pmd() - FALLBACK
  handle_pte_fault()
    passes check for pmd_devmap()

					(private mapping read)
					__handle_mm_fault()
					  create_huge_pmd()
					    dax_iomap_pmd_fault() inserts PMD

    dax_iomap_pte_fault() does a PTE fault, but we already have a DAX PMD
    			  installed in our page tables at this spot.

Here's the second race:

CPU 0					CPU 1

(private mapping read)
__handle_mm_fault()
  passes check for pmd_none()
  create_huge_pmd()
    dax_iomap_pmd_fault() inserts PMD

(private mapping write)
__handle_mm_fault()
  create_huge_pmd() - FALLBACK
					(private mapping read)
					__handle_mm_fault()
					  passes check for pmd_none()
					  create_huge_pmd()

  handle_pte_fault()
    dax_iomap_pte_fault() inserts PTE
					    dax_iomap_pmd_fault() inserts PMD,
					       but we already have a PTE at
					       this spot.

The core of the issue is that while there is isolation between faults to
the same range in the DAX fault handlers via our DAX entry locking, there
is no isolation between faults in the code in mm/memory.c.  This means for
instance that this code in __handle_mm_fault() can run:

	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
		ret = create_huge_pmd(&vmf);

But by the time we actually get to run the fault handler called by
create_huge_pmd(), the PMD is no longer pmd_none() because a racing PTE
fault has installed a normal PMD here as a parent.  This is the cause of
the 2nd race.  The first race is similar - there is the following check in
handle_pte_fault():

	} else {
		/* See comment in pte_alloc_one_map() */
		if (pmd_devmap(*vmf->pmd) || pmd_trans_unstable(vmf->pmd))
			return 0;

So if a pmd_devmap() PMD (a DAX PMD) has been installed at vmf->pmd, we
will bail and retry the fault.  This is correct, but there is nothing
preventing the PMD from being installed after this check but before we
actually get to the DAX PTE fault handlers.

In my testing these races result in the following types of errors:

 BUG: Bad rss-counter state mm:ffff8800a817d280 idx:1 val:1
 BUG: non-zero nr_ptes on freeing mm: 15

Fix this issue by having the DAX fault handlers verify that it is safe to
continue their fault after they have taken an entry lock to block other
racing faults.

Link: http://lkml.kernel.org/r/20170522215749.23516-2-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Pawel Lebioda <pawel.lebioda@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Pawel Lebioda <pawel.lebioda@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Xiong Zhou <xzhou@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN fs/dax.c~dax-fix-race-between-colliding-pmd-pte-entries fs/dax.c
--- a/fs/dax.c~dax-fix-race-between-colliding-pmd-pte-entries
+++ a/fs/dax.c
@@ -1155,6 +1155,17 @@ static int dax_iomap_pte_fault(struct vm
 	}
 
 	/*
+	 * It is possible, particularly with mixed reads & writes to private
+	 * mappings, that we have raced with a PMD fault that overlaps with
+	 * the PTE we need to set up.  If so just return and the fault will be
+	 * retried.
+	 */
+	if (pmd_devmap(*vmf->pmd)) {
+		vmf_ret = VM_FAULT_NOPAGE;
+		goto unlock_entry;
+	}
+
+	/*
 	 * Note that we don't bother to use iomap_apply here: DAX required
 	 * the file system block size to be equal the page size, which means
 	 * that we never have to deal with more than a single extent here.
@@ -1398,6 +1409,15 @@ static int dax_iomap_pmd_fault(struct vm
 		goto fallback;
 
 	/*
+	 * It is possible, particularly with mixed reads & writes to private
+	 * mappings, that we have raced with a PTE fault that overlaps with
+	 * the PMD we need to set up.  If so we just fall back to a PTE fault
+	 * ourselves.
+	 */
+	if (!pmd_none(*vmf->pmd))
+		goto unlock_entry;
+
+	/*
 	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
 	 * setting up a mapping, so really we're using iomap_begin() as a way
 	 * to look up our filesystem block.
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-avoid-spurious-bad-pmd-warning-messages.patch
dax-fix-race-between-colliding-pmd-pte-entries.patch

