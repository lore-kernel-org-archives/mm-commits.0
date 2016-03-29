From: akpm@linux-foundation.org
Subject: + dax-use-vmf-gfp_mask.patch added to -mm tree
Date: Tue, 29 Mar 2016 14:08:28 -0700
Message-ID: <56faeecc.GllDPSLJSoUoL2Fp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbcC2VI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: Use vmf->gfp_mask
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
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: Use vmf->gfp_mask

We were assuming that it was OK to do a GFP_KERNEL allocation in page
fault context.  That appears to be largely true, but filesystems are
permitted to override that in their setting of mapping->gfp_flags, which
the VM then massages into vmf->gfp_flags.  No practical difference for
now, but there may come a day when we would have surprised a filesystem.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-use-vmf-gfp_mask fs/dax.c
--- a/fs/dax.c~dax-use-vmf-gfp_mask
+++ a/fs/dax.c
@@ -316,7 +316,7 @@ static int dax_load_hole(struct address_
 	struct inode *inode = mapping->host;
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
-						GFP_KERNEL | __GFP_ZERO);
+						vmf->gfp_mask | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
 	/* Recheck i_size under page lock to avoid truncate race */
_

Patches currently in -mm which might be from willy@linux.intel.com are

mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-unify-native__get_and_clear-smp-case.patch
x86-fix-whitespace-issues.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch

