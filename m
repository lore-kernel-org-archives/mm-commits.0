From: akpm@linux-foundation.org
Subject: + fix-rmmod-read-write-races-in-proc-entries-fix.patch added to -mm tree
Date: Thu, 22 Mar 2007 01:58:41 -0800
Message-ID: <200703220958.l2M9wfxq017729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933907AbXCVJ7W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 05:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     Fix lseek on /proc/kcore
has been added to the -mm tree.  Its filename is
     fix-rmmod-read-write-races-in-proc-entries-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix lseek on /proc/kcore
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/inode.c~fix-rmmod-read-write-races-in-proc-entries-fix fs/proc/inode.c
--- a/fs/proc/inode.c~fix-rmmod-read-write-races-in-proc-entries-fix
+++ a/fs/proc/inode.c
@@ -167,8 +167,9 @@ static loff_t proc_reg_llseek(struct fil
 	llseek = pde->proc_fops->llseek;
 	spin_unlock(&pde->pde_unload_lock);
 
-	if (llseek)
-		rv = llseek(file, offset, whence);
+	if (!llseek)
+		llseek = default_llseek;
+	rv = llseek(file, offset, whence);
 
 	spin_lock(&pde->pde_unload_lock);
 	pde->pde_users--;
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
