From: akpm@linux-foundation.org
Subject: - git-nfsd-fix-generic_setlease-mismerge.patch removed from -mm tree
Date: Tue, 25 Sep 2007 10:26:35 -0700
Message-ID: <200709251726.l8PHQZvn028674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759203AbXIYR1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     fix generic_setlease() mismerge
has been removed from the -mm tree.  Its filename was
     git-nfsd-fix-generic_setlease-mismerge.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fix generic_setlease() mismerge
From: Alexey Dobriyan <adobriyan@sw.ru>

Please, try this:


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/locks.c~git-nfsd-fix-generic_setlease-mismerge fs/locks.c
--- a/fs/locks.c~git-nfsd-fix-generic_setlease-mismerge
+++ a/fs/locks.c
@@ -1370,11 +1370,6 @@ int generic_setlease(struct file *filp, 
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
-	error = -ENOMEM;
-	new_fl = locks_alloc_lock();
-	if (new_fl == NULL)
-		goto out;
-
 	/*
 	 * At this point, we know that if there is an exclusive
 	 * lease on this file, then we hold it on this filp
_

Patches currently in -mm which might be from adobriyan@sw.ru are

consolidate-ptrace_detach.patch
git-kbuild.patch
git-nfsd-fix-generic_setlease-mismerge.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
userc-deinline.patch
userc-ifdef-mq_bytes.patch
userc-ifdef-mq_bytes-fix.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
single_open-seq_release-leak-diagnostics.patch
