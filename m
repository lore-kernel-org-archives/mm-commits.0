From: akpm@linux-foundation.org
Subject: + procfs-use-proper-units-for-nommu-statm.patch added to -mm tree
Date: Mon, 16 Nov 2009 14:50:42 -0800
Message-ID: <200911162250.nAGMogd8001703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZKPWwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 17:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, dhowells@redhat.com, gerg@snapgear.com


The patch titled
     procfs: use proper units for noMMU statm
has been added to the -mm tree.  Its filename is
     procfs-use-proper-units-for-nommu-statm.patch

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
Subject: procfs: use proper units for noMMU statm
From: Steven J. Magnani <steve@digidescorp.com>

On no-MMU systems, sizes reported in /proc/n/statm have units of bytes.
Per Documentation/filesystems/proc.txt, these values should be in pages.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_nommu.c~procfs-use-proper-units-for-nommu-statm fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-use-proper-units-for-nommu-statm
+++ a/fs/proc/task_nommu.c
@@ -110,8 +110,11 @@ int task_statm(struct mm_struct *mm, int
 		}
 	}
 
-	size += (*text = mm->end_code - mm->start_code);
-	size += (*data = mm->start_stack - mm->start_data);
+	size >>= PAGE_SHIFT;
+	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
+		>> PAGE_SHIFT;
+	*data = (mm->start_stack - mm->start_data) >> PAGE_SHIFT;
+	size += *text + *data;
 	up_read(&mm->mmap_sem);
 	*resident = size;
 	return size;
_

Patches currently in -mm which might be from steve@digidescorp.com are

microblaze-fix-pfn_valid-for-nommu.patch
procfs-use-proper-units-for-nommu-statm.patch

