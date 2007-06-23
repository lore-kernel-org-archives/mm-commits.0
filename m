From: akpm@linux-foundation.org
Subject: + handle-wrapping-in-expand_upwards.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:47:14 -0700
Message-ID: <200706231647.l5NGlBSi019478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758102AbXFWQsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, kyle@parisc-linux.org, tony.luck@intel.com


The patch titled
     Handle wrapping in expand_upwards()
has been added to the -mm tree.  Its filename is
     handle-wrapping-in-expand_upwards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Handle wrapping in expand_upwards()
From: Helge Deller <deller@gmx.de>

Function expand_upwards() did not guarded against wrapping around to
address 0.  This fixes the adjtimex02 testcase from the Linux Test Project
on a 32bit PARISC kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~handle-wrapping-in-expand_upwards mm/mmap.c
--- a/mm/mmap.c~handle-wrapping-in-expand_upwards
+++ a/mm/mmap.c
@@ -1536,9 +1536,14 @@ int expand_upwards(struct vm_area_struct
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_sem in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
+	 * Also guard against wrapping around to address 0.
 	 */
-	address += 4 + PAGE_SIZE - 1;
-	address &= PAGE_MASK;
+	if (address < PAGE_ALIGN(address+4))
+		address = PAGE_ALIGN(address+4);
+	else {
+		anon_vma_unlock(vma);
+		return -ENOMEM;
+	}
 	error = 0;
 
 	/* Somebody else might have raced and expanded it already */
_

Patches currently in -mm which might be from deller@gmx.de are

handle-wrapping-in-expand_upwards.patch
