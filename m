From: akpm@linux-foundation.org
Subject: + fbmem-vm_io-set-but-not-propagated.patch added to -mm tree
Date: Mon, 26 Jul 2010 15:38:17 -0700
Message-ID: <201007262238.o6QMcHwE014029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab0GZWia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 18:38:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgdegra@tycho.nsa.gov, FlorianSchandinat@gmx.de, airlied@linux.ie, ewalsh@tycho.nsa.gov, konrad.wilk@oracle.com


The patch titled
     fbmem: VM_IO set, but not propagated
has been added to the -mm tree.  Its filename is
     fbmem-vm_io-set-but-not-propagated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmem: VM_IO set, but not propagated
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>

When we setup up the VMA flags for the mmap flag and we end up using the
fallback mmap functionality we set the vma->vm_flags |= VM_IO.  However we
neglect to propagate the flag to the vma->vm_page_prot.

This bug was found when Linux kernel was running under Xen.  In that
scenario, any page that has VM_IO flag to it, means that it MUST be a
MMIO/VRAM backend memory , _not_ System RAM.  That is what the fbmem.c
does: sets VM_IO, ioremaps the region - everything is peachy.

Well, not exactly.  The vm_page_prot does not get the relevant PTE flags
set (_PAGE_IOMAP) which under Xen is a death-kneel to pages that are
referencing real physical devices but don't have that flag set.

This patch fixes this.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Eamon Walsh <ewalsh@tycho.nsa.gov>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/fbmem.c~fbmem-vm_io-set-but-not-propagated drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-vm_io-set-but-not-propagated
+++ a/drivers/video/fbmem.c
@@ -1362,6 +1362,7 @@ fb_mmap(struct file *file, struct vm_are
 	vma->vm_pgoff = off >> PAGE_SHIFT;
 	/* This is an IO map - tell maydump to skip this VMA */
 	vma->vm_flags |= VM_IO | VM_RESERVED;
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	fb_pgprotect(file, vma, off);
 	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
 			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
_

Patches currently in -mm which might be from dgdegra@tycho.nsa.gov are

fbmem-vm_io-set-but-not-propagated.patch

