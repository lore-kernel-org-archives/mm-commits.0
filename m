From: akpm@linux-foundation.org
Subject: + proc-always-do-release-fix.patch added to -mm tree
Date: Fri, 27 Jun 2008 12:24:39 -0700
Message-ID: <200806271924.m5RJOsqJ002069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482AbYF0TY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 15:24:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     proc-always-do-release fix
has been added to the -mm tree.  Its filename is
     proc-always-do-release-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-always-do-release fix
From: Alexey Dobriyan <adobriyan@gmail.com>

Don't add ->release'less PDEs into openers list.

This fixes possible call to NULL if ->release is not needed for some reason.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    3 +--
 fs/proc/inode.c   |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/generic.c~proc-always-do-release-fix fs/proc/generic.c
--- a/fs/proc/generic.c~proc-always-do-release-fix
+++ a/fs/proc/generic.c
@@ -797,8 +797,7 @@ continue_removing:
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		list_del(&pdeo->lh);
 		spin_unlock(&de->pde_unload_lock);
-		if (pdeo->release)
-			pdeo->release(pdeo->inode, pdeo->file);
+		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
 		spin_lock(&de->pde_unload_lock);
 	}
diff -puN fs/proc/inode.c~proc-always-do-release-fix fs/proc/inode.c
--- a/fs/proc/inode.c~proc-always-do-release-fix
+++ a/fs/proc/inode.c
@@ -355,7 +355,7 @@ static int proc_reg_open(struct inode *i
 		rv = open(inode, file);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (rv == 0) {
+	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->inode = inode;
 		pdeo->file = file;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
cifs-switch-to-seq_files.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-always-do-release.patch
proc-always-do-release-fix.patch
proc-remove-pathetic-remount-code.patch
proc-move-kconfig-to-fs-proc-kconfig.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

