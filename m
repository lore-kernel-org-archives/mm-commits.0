From: akpm@linux-foundation.org
Subject: + mm-fix-data-corruption-due-to-stale-mmap-reads.patch added to
 -mm tree
Date: Wed, 10 May 2017 13:54:47 -0700
Message-ID: <59137e17.63WHI0bsUyAAsmyq%akpm__1628.41044734723$1494449694$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33940 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754087AbdEJUys (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 16:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix data corruption due to stale mmap reads
has been added to the -mm tree.  Its filename is
     mm-fix-data-corruption-due-to-stale-mmap-reads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-data-corruption-due-to-stale-mmap-reads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-data-corruption-due-to-stale-mmap-reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: fix data corruption due to stale mmap reads

Currently, we didn't invalidate page tables during
invalidate_inode_pages2() for DAX.  That could result in e.g.  2MiB zero
page being mapped into page tables while there were already underlying
blocks allocated and thus data seen through mmap were different from data
seen by read(2).  The following sequence reproduces the problem:

- open an mmap over a 2MiB hole

- read from a 2MiB hole, faulting in a 2MiB zero page

- write to the hole with write(3p).  The write succeeds but we
  incorrectly leave the 2MiB zero page mapping intact.

- via the mmap, read the data that was just written.  Since the zero
  page mapping is still intact we read back zeroes instead of the new
  data.

Fix the problem by unconditionally calling invalidate_inode_pages2_range()
in dax_iomap_actor() for new block allocations and by properly
invalidating page tables in invalidate_inode_pages2_range() for DAX
mappings.

Fixes: c6dcf52c23d2d3fb5235cec42d7dd3f786b87d55
Link: http://lkml.kernel.org/r/20170510085419.27601-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c      |    2 +-
 mm/truncate.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/dax.c~mm-fix-data-corruption-due-to-stale-mmap-reads fs/dax.c
--- a/fs/dax.c~mm-fix-data-corruption-due-to-stale-mmap-reads
+++ a/fs/dax.c
@@ -1015,7 +1015,7 @@ dax_iomap_actor(struct inode *inode, lof
 	 * into page tables. We have to tear down these mappings so that data
 	 * written by write(2) is visible in mmap.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
+	if (iomap->flags & IOMAP_F_NEW) {
 		invalidate_inode_pages2_range(inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
diff -puN mm/truncate.c~mm-fix-data-corruption-due-to-stale-mmap-reads mm/truncate.c
--- a/mm/truncate.c~mm-fix-data-corruption-due-to-stale-mmap-reads
+++ a/mm/truncate.c
@@ -686,7 +686,17 @@ int invalidate_inode_pages2_range(struct
 		cond_resched();
 		index++;
 	}
