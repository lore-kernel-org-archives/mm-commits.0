From: akpm@linux-foundation.org
Subject: - handle-wrapping-in-expand_upwards.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:02 -0700
Message-ID: <200706231928.l5NJS29B022107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbXFWTf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, kyle@parisc-linux.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Handle wrapping in expand_upwards()
has been removed from the -mm tree.  Its filename was
     handle-wrapping-in-expand_upwards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
