From: akpm@linux-foundation.org
Subject: - ipc-consolidate-all-xxxctl_down-functions-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:49:04 -0700
Message-ID: <200804290549.m3T5n49X003805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbYD2Fte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peifferp@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     IPC: fix a kernel-doc warning
has been removed from the -mm tree.  Its filename was
     ipc-consolidate-all-xxxctl_down-functions-fix.patch

This patch was dropped because it was folded into ipc-consolidate-all-xxxctl_down-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC: fix a kernel-doc warning
From: "Pierre Peiffer" <peifferp@gmail.com>

This patch fixes this warning produced by kernel-doc (thanks Randy Dunlap):

Warning(linux-2.6.25-rc3-mm1//ipc/util.c:845):
No description found for parameter 'extrat_perm'

It is due to an inconsistency in a variable name between the C-code and
the associated comment.

Signed-off-by: Pierre Peiffer <peifferp@gmail.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 ++--
 ipc/util.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/util.c~ipc-consolidate-all-xxxctl_down-functions-fix ipc/util.c
--- a/ipc/util.c~ipc-consolidate-all-xxxctl_down-functions-fix
+++ a/ipc/util.c
@@ -841,7 +841,7 @@ void ipc_update_perm(struct ipc64_perm *
  *    or an err-code without any lock held otherwise.
  */
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extrat_perm)
+				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
 	int err;
@@ -858,7 +858,7 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 		goto out_unlock;
 
 	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(extrat_perm, perm->uid,
+		err = audit_ipc_set_perm(extra_perm, perm->uid,
 					 perm->gid, perm->mode);
 		if (err)
 			goto out_unlock;
diff -puN ipc/util.h~ipc-consolidate-all-xxxctl_down-functions-fix ipc/util.h
--- a/ipc/util.h~ipc-consolidate-all-xxxctl_down-functions-fix
+++ a/ipc/util.h
@@ -114,7 +114,7 @@ void kernel_to_ipc64_perm(struct kern_ip
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extrat_perm);
+				      struct ipc64_perm *perm, int extra_perm);
 
 #if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
_

Patches currently in -mm which might be from peifferp@gmail.com are

ipc-consolidate-all-xxxctl_down-functions.patch
ipc-consolidate-all-xxxctl_down-functions-fix.patch
ipc-add-definitions-of-ushort_max-and-others.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch
ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch

