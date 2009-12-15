From: akpm@linux-foundation.org
Subject: [merged] procfs-use-proper-units-for-nommu-statm.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:01 -0800
Message-ID: <200912152155.nBFLt1pd015426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933783AbZLOV4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com, dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     procfs: use proper units for noMMU statm
has been removed from the -mm tree.  Its filename was
     procfs-use-proper-units-for-nommu-statm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: use proper units for noMMU statm
From: Steven J. Magnani <steve@digidescorp.com>

On no-MMU systems, sizes reported in /proc/n/statm have units of bytes.
Per Documentation/filesystems/proc.txt, these values should be in pages.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_nommu.c~procfs-use-proper-units-for-nommu-statm fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-use-proper-units-for-nommu-statm
+++ a/fs/proc/task_nommu.c
@@ -110,9 +110,13 @@ int task_statm(struct mm_struct *mm, int
 		}
 	}
 
-	size += (*text = mm->end_code - mm->start_code);
-	size += (*data = mm->start_stack - mm->start_data);
+	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
+		>> PAGE_SHIFT;
+	*data = (PAGE_ALIGN(mm->start_stack) - (mm->start_data & PAGE_MASK))
+		>> PAGE_SHIFT;
 	up_read(&mm->mmap_sem);
+	size >>= PAGE_SHIFT;
+	size += *text + *data;
 	*resident = size;
 	return size;
 }
_

Patches currently in -mm which might be from steve@digidescorp.com are

origin.patch
linux-next.patch

