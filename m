From: akpm@linux-foundation.org
Subject: - fix-rmmod-read-write-races-in-proc-entries-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:38:31 -0700
Message-ID: <200704301938.l3UJcVwP013099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946736AbXD3Tj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     Fix lseek on /proc/kcore
has been removed from the -mm tree.  Its filename was
     fix-rmmod-read-write-races-in-proc-entries-fix.patch

This patch was dropped because it was folded into fix-rmmod-read-write-races-in-proc-entries.patch

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
@@ -166,8 +166,9 @@ static loff_t proc_reg_llseek(struct fil
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

git-cpufreq.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
add-file-position-info-to-proc.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
