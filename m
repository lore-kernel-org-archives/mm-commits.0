From: akpm@linux-foundation.org
Subject: - markers-fix-sparse-warnings-in-markersc.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:29 -0800
Message-ID: <200802250044.m1P0iTkI006113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbYBYAok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     markers: fix sparse warnings in markers.c
has been removed from the -mm tree.  Its filename was
     markers-fix-sparse-warnings-in-markersc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: fix sparse warnings in markers.c
From: Harvey Harrison <harvey.harrison@gmail.com>

char can be unsigned
kernel/marker.c:64:20: error: dubious one-bit signed bitfield
kernel/marker.c:65:14: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/marker.c~markers-fix-sparse-warnings-in-markersc kernel/marker.c
--- a/kernel/marker.c~markers-fix-sparse-warnings-in-markersc
+++ a/kernel/marker.c
@@ -61,8 +61,8 @@ struct marker_entry {
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	struct rcu_head rcu;
 	void *oldptr;
-	char rcu_pending:1;
-	char ptype:1;
+	unsigned char rcu_pending:1;
+	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

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
