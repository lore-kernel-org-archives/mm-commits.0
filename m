From: akpm@linux-foundation.org
Subject: [merged] mm-filemap_xipc-fix-race-condition-in-xip_file_fault.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:25 -0800
Message-ID: <20120206203125.75AC1A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:59610 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2BFUb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: carsteno@de.ibm.com, cotte@de.ibm.com, dsadler@us.ibm.com, hughd@google.com, leisner@cs.ucsd.edu, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap_xip.c: fix race condition in xip_file_fault()
has been removed from the -mm tree.  Its filename was
     mm-filemap_xipc-fix-race-condition-in-xip_file_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Carsten Otte <carsteno@de.ibm.com>
Subject: mm/filemap_xip.c: fix race condition in xip_file_fault()

Fix a race condition that shows in conjunction with xip_file_fault() when
two threads of the same user process fault on the same memory page.

In this case, the race winner will install the page table entry and the
unlucky loser will cause an oops: xip_file_fault calls vm_insert_pfn (via
vm_insert_mixed) which drops out at this check:

	retval = -EBUSY;
	if (!pte_none(*pte))
		goto out_unlock;

The resulting -EBUSY return value will trigger a BUG_ON() in
xip_file_fault.

This fix simply considers the fault as fixed in this case, because the
race winner has successfully installed the pte.

[akpm@linux-foundation.org: use conventional (and consistent) comment layout]
Reported-by: David Sadler <dsadler@us.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reported-by: Louis Alex Eisner <leisner@cs.ucsd.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/filemap_xip.c~mm-filemap_xipc-fix-race-condition-in-xip_file_fault mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-filemap_xipc-fix-race-condition-in-xip_file_fault
+++ a/mm/filemap_xip.c
@@ -263,7 +263,12 @@ found:
 							xip_pfn);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
-		BUG_ON(err);
+		/*
+		 * err == -EBUSY is fine, we've raced against another thread
+		 * that faulted-in the same page
+		 */
+		if (err != -EBUSY)
+			BUG_ON(err);
 		return VM_FAULT_NOPAGE;
 	} else {
 		int err, ret = VM_FAULT_OOM;
_

Patches currently in -mm which might be from carsteno@de.ibm.com are

origin.patch

