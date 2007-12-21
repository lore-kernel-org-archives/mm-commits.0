From: akpm@linux-foundation.org
Subject: + reiser4-replace-uid==0-check-with-capability.patch added to -mm tree
Date: Thu, 20 Dec 2007 16:13:01 -0800
Message-ID: <200712210013.lBL0D1J9020461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791AbXLUA2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 19:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, edward.shishkin@gmail.com, vs@namesys.com


The patch titled
     reiser4: replace uid==0 check with capability
has been added to the -mm tree.  Its filename is
     reiser4-replace-uid==0-check-with-capability.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: replace uid==0 check with capability
From: "Serge E. Hallyn" <serue@us.ibm.com>

Reiser4 gives root some reserved blocks.  Replace the uid==0 check, which
is not safe in the face of user namespaces, with a CAP_SYS_RESOURCE check,
which seems appropriate.

The per-uid and per-guid reservations appear unimplemented so I'm ignoring
them.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/super.c~reiser4-replace-uid==0-check-with-capability fs/reiser4/super.c
--- a/fs/reiser4/super.c~reiser4-replace-uid==0-check-with-capability
+++ a/fs/reiser4/super.c
@@ -144,7 +144,7 @@ long reiser4_reserved_blocks(const struc
 		reserved += reserved_for_gid(super, gid);
 	if (REISER4_SUPPORT_UID_SPACE_RESERVATION)
 		reserved += reserved_for_uid(super, uid);
-	if (REISER4_SUPPORT_ROOT_SPACE_RESERVATION && (uid == 0))
+	if (REISER4_SUPPORT_ROOT_SPACE_RESERVATION && capable(CAP_SYS_RESOURCE))
 		reserved += reserved_for_root(super);
 	return reserved;
 }
_

Patches currently in -mm which might be from serue@us.ibm.com are

git-agpgart.patch
git-net.patch
git-unionfs.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
64bit-capability-support-legacy-support-fix.patch
add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch
capabilities-introduce-per-process-capability-bounding-set.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
smack-using-capabilities-32-and-33.patch
smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
reiser4-replace-uid==0-check-with-capability.patch
