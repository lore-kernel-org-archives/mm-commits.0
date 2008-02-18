From: akpm@linux-foundation.org
Subject: + jffs2-fix-sparse-warning-in-writec.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:00:45 -0800
Message-ID: <200802181001.m1IA1hNX018959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbYBRKCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:02:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dwmw2@infradead.org


The patch titled
     jffs2: fix sparse warning in write.c
has been added to the -mm tree.  Its filename is
     jffs2-fix-sparse-warning-in-writec.patch

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
Subject: jffs2: fix sparse warning in write.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/jffs2/write.c:585:28: warning: symbol 'fd' shadows an earlier one
fs/jffs2/write.c:536:27: originally declared here

No need to redeclare fd, use the original one, after this point,
fd is always reassigned before it used again.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/write.c~jffs2-fix-sparse-warning-in-writec fs/jffs2/write.c
--- a/fs/jffs2/write.c~jffs2-fix-sparse-warning-in-writec
+++ a/fs/jffs2/write.c
@@ -582,9 +582,9 @@ int jffs2_do_unlink(struct jffs2_sb_info
 		jffs2_add_fd_to_list(c, fd, &dir_f->dents);
 		up(&dir_f->sem);
 	} else {
-		struct jffs2_full_dirent *fd = dir_f->dents;
 		uint32_t nhash = full_name_hash(name, namelen);
 
+		fd = dir_f->dents;
 		/* We don't actually want to reserve any space, but we do
 		   want to be holding the alloc_sem when we write to flash */
 		down(&c->alloc_sem);
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
