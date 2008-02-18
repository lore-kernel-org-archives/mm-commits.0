From: akpm@linux-foundation.org
Subject: + autofs4-fix-sparse-warning-in-rootc.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:12:24 -0800
Message-ID: <200802181013.m1IADMJd019628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757499AbYBRKTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:19:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, raven@themaw.net


The patch titled
     autofs4: fix sparse warning in root.c
has been added to the -mm tree.  Its filename is
     autofs4-fix-sparse-warning-in-rootc.patch

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
Subject: autofs4: fix sparse warning in root.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/autofs4/root.c:536:23: warning: symbol 'ino' shadows an earlier one
fs/autofs4/root.c:510:22: originally declared here

There is no need to redeclare, we are at the end of the loop and in
the next iteration of the loop, ino will be reset.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs4-fix-sparse-warning-in-rootc fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-sparse-warning-in-rootc
+++ a/fs/autofs4/root.c
@@ -533,9 +533,9 @@ static struct dentry *autofs4_lookup_unh
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			struct autofs_info *ino = autofs4_dentry_ino(dentry);
 			struct inode *inode = dentry->d_inode;
 
+			ino = autofs4_dentry_ino(dentry);
 			list_del_init(&ino->rehash);
 			dget(dentry);
 			/*
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
