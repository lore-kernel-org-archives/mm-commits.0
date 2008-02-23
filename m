From: akpm@linux-foundation.org
Subject: - lockd-fix-sparse-warning-in-svcsharec.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:23 -0800
Message-ID: <200802232022.m1NKMNLN013419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761801AbYBWU2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     lockd: fix sparse warning in svcshare.c
has been removed from the -mm tree.  Its filename was
     lockd-fix-sparse-warning-in-svcsharec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
markers-fix-sparse-warnings-in-markersc.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
git-sched.patch
git-scsi-rc-fixes.patch
git-x86.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
