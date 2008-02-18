From: akpm@linux-foundation.org
Subject: + lockd-fix-sparse-warning-in-svcsharec.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:01:49 -0800
Message-ID: <200802181002.m1IA2lXg019069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758327AbYBRKD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bfields@fieldses.org, neilb@suse.de


The patch titled
     lockd: fix sparse warning in svcshare.c
has been added to the -mm tree.  Its filename is
     lockd-fix-sparse-warning-in-svcsharec.patch

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
Subject: lockd: fix sparse warning in svcshare.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/lockd/svcshare.c:74:50: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svcshare.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/lockd/svcshare.c~lockd-fix-sparse-warning-in-svcsharec fs/lockd/svcshare.c
--- a/fs/lockd/svcshare.c~lockd-fix-sparse-warning-in-svcsharec
+++ a/fs/lockd/svcshare.c
@@ -71,7 +71,7 @@ nlmsvc_unshare_file(struct nlm_host *hos
 	struct nlm_share	*share, **shpp;
 	struct xdr_netobj	*oh = &argp->lock.oh;
 
-	for (shpp = &file->f_shares; (share = *shpp) != 0; shpp = &share->s_next) {
+	for (shpp = &file->f_shares; (share = *shpp) != NULL; shpp = &share->s_next) {
 		if (share->s_host == host && nlm_cmp_owner(share, oh)) {
 			*shpp = share->s_next;
 			kfree(share);
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
