From: akpm@linux-foundation.org
Subject: + procfs-use-proper-units-for-nommu-statm-fix.patch added to -mm tree
Date: Wed, 18 Nov 2009 13:39:37 -0800
Message-ID: <200911182139.nAILdbCv005383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103AbZKRVkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 16:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, dhowells@redhat.com, gerg@snapgear.com, xiyou.wangcong@gmail.com


The patch titled
     procfs-use-proper-units-for-nommu-statm-fix
has been added to the -mm tree.  Its filename is
     procfs-use-proper-units-for-nommu-statm-fix.patch

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

linux-next.patch
procfs-use-proper-units-for-nommu-statm.patch
procfs-use-proper-units-for-nommu-statm-fix.patch

