From: akpm@linux-foundation.org
Subject: [folded] procfs-use-proper-units-for-nommu-statm-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:06:10 -0800
Message-ID: <200912150106.nBF16A73009067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758927AbZLOBHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com, dhowells@redhat.com, gerg@snapgear.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     procfs-use-proper-units-for-nommu-statm-fix
has been removed from the -mm tree.  Its filename was
     procfs-use-proper-units-for-nommu-statm-fix.patch

This patch was dropped because it was folded into procfs-use-proper-units-for-nommu-statm.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs-use-proper-units-for-nommu-statm-fix
From: Steven J. Magnani <steve@digidescorp.com>

Reworked to guarantee page alignment of terms used in data size calculation
and to reduce time spent with mmap_sem held.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Howells <dhowells@redhat.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_nommu.c~procfs-use-proper-units-for-nommu-statm-fix fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-use-proper-units-for-nommu-statm-fix
+++ a/fs/proc/task_nommu.c
@@ -110,12 +110,13 @@ int task_statm(struct mm_struct *mm, int
 		}
 	}
 
-	size >>= PAGE_SHIFT;
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 		>> PAGE_SHIFT;
-	*data = (mm->start_stack - mm->start_data) >> PAGE_SHIFT;
-	size += *text + *data;
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

procfs-use-proper-units-for-nommu-statm.patch
procfs-use-proper-units-for-nommu-statm-fix.patch

