From: akpm@linux-foundation.org
Subject: - dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:36 -0800
Message-ID: <200802272216.m1RMGaAT000726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759267AbYB0WRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, pcaulfie@redhat.com, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dlm: match signedness between dlm_config_info and cluster_set
has been removed from the -mm tree.  Its filename was
     dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dlm: match signedness between dlm_config_info and cluster_set
From: Harvey Harrison <harvey.harrison@gmail.com>

cluster_set is only called from the macro CLUSTER_ATTR which defines read/write
access functions.  Make the signedness match to avoid sparse warnings every time
CLUSTER_ATTR is used (lines 149-159) all of the form:

fs/dlm/config.c:149:1: warning: incorrect type in argument 3 (different signedness)
fs/dlm/config.c:149:1:    expected unsigned int *info_field
fs/dlm/config.c:149:1:    got int extern [toplevel] *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Patrick Caulfield <pcaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dlm/config.c~dlm-match-signedness-between-dlm_config_info-and-cluster_set fs/dlm/config.c
--- a/fs/dlm/config.c~dlm-match-signedness-between-dlm_config_info-and-cluster_set
+++ a/fs/dlm/config.c
@@ -114,7 +114,7 @@ struct cluster_attribute {
 };
 
 static ssize_t cluster_set(struct cluster *cl, unsigned int *cl_field,
-			   unsigned int *info_field, int check_zero,
+			   int *info_field, int check_zero,
 			   const char *buf, size_t len)
 {
 	unsigned int x;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
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
fbcon-replace-mono_col-macro-with-static-inline.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
