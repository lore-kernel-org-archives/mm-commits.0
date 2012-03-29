From: akpm@linux-foundation.org
Subject: [merged] fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:11 -0700
Message-ID: <20120329191411.72967A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:49461 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738Ab2C2TOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:12 -0400
Received: by ghbz15 with SMTP id z15so303892ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty
has been removed from the -mm tree.  Its filename was
     fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty

If CONFIG_NET_NS, CONFIG_UTS_NS and CONFIG_IPC_NS are disabled,
ns_entries[] becomes empty and things like
ns_entries[ARRAY_SIZE(ns_entries) - 1] will explode.

Reported-by: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/namespaces.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/namespaces.c~fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty fs/proc/namespaces.c
--- a/fs/proc/namespaces.c~fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty
+++ a/fs/proc/namespaces.c
@@ -156,15 +156,15 @@ static struct dentry *proc_ns_dir_lookup
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out;
 
-	last = &ns_entries[ARRAY_SIZE(ns_entries) - 1];
-	for (entry = ns_entries; entry <= last; entry++) {
+	last = &ns_entries[ARRAY_SIZE(ns_entries)];
+	for (entry = ns_entries; entry < last; entry++) {
 		if (strlen((*entry)->name) != len)
 			continue;
 		if (!memcmp(dentry->d_name.name, (*entry)->name, len))
 			break;
 	}
 	error = ERR_PTR(-ENOENT);
-	if (entry > last)
+	if (entry == last)
 		goto out;
 
 	error = proc_ns_instantiate(dir, dentry, task, *entry);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

