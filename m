From: akpm@linux-foundation.org
Subject: + binfmt_miscc-avoid-potential-kernel-stack-overflow.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:59:28 -0700
Message-ID: <200803132159.m2DLxSqT002461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755780AbYCMV7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:59:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org


The patch titled
     binfmt_misc.c: avoid potential kernel stack overflow
has been added to the -mm tree.  Its filename is
     binfmt_miscc-avoid-potential-kernel-stack-overflow.patch

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
Subject: binfmt_misc.c: avoid potential kernel stack overflow
From: Pavel Emelyanov <xemul@openvz.org>

This can be triggered with root help only, but...

Register the ":text:E::txt::/root/cat.txt:' rule in binfmt_misc (by root) and
try launching the cat.txt file (by anyone) :) The result is - the endless
recursion in the load_misc_binary -> open_exec -> load_misc_binary chain and
stack overflow.

There's a similar problem with binfmt_script, and there's a sh_bang memner on
linux_binprm structure to handle this, but simply raising this in binfmt_misc
may break some setups when the interpreter of some misc binaries is a script.

So the proposal is to turn sh_bang into a bit, add a new one (the misc_bang)
and raise it in load_misc_binary.  After this, even if we set up the misc ->
script -> misc loop for binfmts one of them will step on its own bang and
exit.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c        |    2 +-
 fs/binfmt_misc.c        |    6 ++++++
 fs/binfmt_script.c      |    2 +-
 include/linux/binfmts.h |    3 ++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_em86.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
-	bprm->sh_bang++;	/* Well, the bang-shell is implicit... */
+	bprm->sh_bang = 1;	/* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN fs/binfmt_misc.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_misc.c
@@ -116,6 +116,12 @@ static int load_misc_binary(struct linux
 	if (!enabled)
 		goto _ret;
 
+	retval = -ENOEXEC;
+	if (bprm->misc_bang)
+		goto _ret;
+
+	bprm->misc_bang = 1;
+
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
diff -puN fs/binfmt_script.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_script.c
--- a/fs/binfmt_script.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_script.c
@@ -29,7 +29,7 @@ static int load_script(struct linux_binp
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->sh_bang++;
+	bprm->sh_bang = 1;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN include/linux/binfmts.h~binfmt_miscc-avoid-potential-kernel-stack-overflow include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/include/linux/binfmts.h
@@ -34,7 +34,8 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	int sh_bang;
+	unsigned int sh_bang:1,
+		     misc_bang:1;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_inheritable, cap_permitted;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

