From: akpm@linux-foundation.org
Subject: + dax-use-vmf-gfp_mask.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:57:37 -0800
Message-ID: <56b13461.s1U8ig3hdlwXFuBw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbcBBW5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:57:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: use vmf->gfp_mask
has been added to the -mm tree.  Its filename is
     dax-use-vmf-gfp_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-use-vmf-gfp_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-use-vmf-gfp_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: dax: use vmf->gfp_mask

Very little exciting in here.  This is all based on the PUD support code
that was just sent, mostly addressing things that came up during review of
the PUD code but weren't really justifiable as being mixed into the adding
of PUD support.


This patch (of 6):

We were assuming that it was OK to do a GFP_KERNEL allocation in page
fault context.  That appears to be largely true, but filesystems are
permitted to override that in their setting of mapping->gfp_flags, which
the VM then massages into vmf->gfp_flags.  No practical difference for
now, but there may come a day when we would have surprised a filesystem.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-use-vmf-gfp_mask fs/dax.c
--- a/fs/dax.c~dax-use-vmf-gfp_mask
+++ a/fs/dax.c
@@ -312,7 +312,7 @@ static int dax_load_hole(struct address_
 	struct inode *inode = mapping->host;
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
-						GFP_KERNEL | __GFP_ZERO);
+						vmf->gfp_mask | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
 	/* Recheck i_size under page lock to avoid truncate race */
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

mm-fix-memory-leak-in-copy_huge_pmd.patch
mm-use-linear_page_index-in-do_fault.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch
dax-use-page_cache_size-where-appropriate.patch
dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault.patch
dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault.patch

