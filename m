From: akpm@linux-foundation.org
Subject: - frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:29 -0700
Message-ID: <200804130239.m3D2dT7B032392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbYDMCj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: don't make smp_{r, w, }mb() interpolate MEMBAR when CONFIG_SMP=n
has been removed from the -mm tree.  Its filename was
     frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: don't make smp_{r, w, }mb() interpolate MEMBAR when CONFIG_SMP=n
From: David Howells <dhowells@redhat.com>

Don't make smp_{r,w,}mb() interpolate a MEMBAR instruction when CONFIG_SMP=n
as SMP memory barries on UP systems should interpolate a compiler barrier
only.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/system.h |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN include/asm-frv/system.h~frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n include/asm-frv/system.h
--- a/include/asm-frv/system.h~frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n
+++ a/include/asm-frv/system.h
@@ -179,14 +179,23 @@ do {							\
 #define mb()			asm volatile ("membar" : : :"memory")
 #define rmb()			asm volatile ("membar" : : :"memory")
 #define wmb()			asm volatile ("membar" : : :"memory")
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
+#define read_barrier_depends()	barrier()
 
-#define smp_mb()		mb()
-#define smp_rmb()		rmb()
-#define smp_wmb()		wmb()
-
-#define read_barrier_depends()		do {} while(0)
+#ifdef CONFIG_SMP
+#define smp_mb()			mb()
+#define smp_rmb()			rmb()
+#define smp_wmb()			wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) \
+	do { xchg(&var, (value)); } while (0)
+#else
+#define smp_mb()			barrier()
+#define smp_rmb()			barrier()
+#define smp_wmb()			barrier()
+#define smp_read_barrier_depends()	do {} while(0)
+#define set_mb(var, value) \
+	do { var = (value); barrier(); } while (0)
+#endif
 
 #define HARD_RESET_NOW()			\
 do {						\
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-unionfs.patch
remove-the-macro-get_personality.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
mutex-subsystem-synchro-test-module.patch

