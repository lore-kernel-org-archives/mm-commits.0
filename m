From: akpm@linux-foundation.org
Subject: - afs-implement-basic-file-write-support-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 01:51:58 -0700
Message-ID: <200705090851.l498pwlZ018473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbXEIIwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs-implement-basic-file-write-support-fix
has been removed from the -mm tree.  Its filename was
     afs-implement-basic-file-write-support-fix.patch

This patch was dropped because it was folded into afs-implement-basic-file-write-support.patch

------------------------------------------------------
Subject: afs-implement-basic-file-write-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/afs/super.c: In function 'afs_parse_options':
fs/afs/super.c:154: warning: passing argument 2 of 'match_token' discards qualifiers from pointer target type
fs/afs/write.c: In function 'afs_writepages':
fs/afs/write.c:626: warning: large integer implicitly truncated to unsigned type
fs/afs/write.c: In function 'afs_file_write':
fs/afs/write.c:729: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'size_t'
fs/afs/write.c:743: warning: format '%ld' expects type 'long int', but argument 5 has type 'ssize_t'
fs/afs/write.c:754: warning: format '%ld' expects type 'long int', but argument 5 has type 'ssize_t'

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/super.c |    2 +-
 fs/afs/write.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/afs/super.c~afs-implement-basic-file-write-support-fix fs/afs/super.c
--- a/fs/afs/super.c~afs-implement-basic-file-write-support-fix
+++ a/fs/afs/super.c
@@ -67,7 +67,7 @@ enum {
 	afs_opt_vol,
 };
 
-static const match_table_t afs_options_list = {
+static match_table_t afs_options_list = {
 	{ afs_opt_cell,		"cell=%s"	},
 	{ afs_opt_rwpath,	"rwpath"	},
 	{ afs_opt_vol,		"vol=%s"	},
diff -puN fs/afs/write.c~afs-implement-basic-file-write-support-fix fs/afs/write.c
--- a/fs/afs/write.c~afs-implement-basic-file-write-support-fix
+++ a/fs/afs/write.c
@@ -623,7 +623,7 @@ int afs_writepages(struct address_space 
 						    &next);
 		mapping->writeback_index = next;
 	} else if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX) {
-		end = LLONG_MAX >> PAGE_CACHE_SHIFT;
+		end = (pgoff_t)(LLONG_MAX >> PAGE_CACHE_SHIFT);
 		ret = afs_writepages_region(mapping, wbc, 0, end, &next);
 		if (wbc->nr_to_write > 0)
 			mapping->writeback_index = next;
@@ -726,7 +726,7 @@ ssize_t afs_file_write(struct kiocb *ioc
 	size_t count = iov_length(iov, nr_segs);
 	int ret;
 
-	_enter("{%x.%u},{%lu},%lu,",
+	_enter("{%x.%u},{%zu},%lu,",
 	       vnode->fid.vid, vnode->fid.vnode, count, nr_segs);
 
 	if (IS_SWAPFILE(&vnode->vfs_inode)) {
@@ -740,7 +740,7 @@ ssize_t afs_file_write(struct kiocb *ioc
 
 	result = generic_file_aio_write(iocb, iov, nr_segs, pos);
 	if (IS_ERR_VALUE(result)) {
-		_leave(" = %ld", result);
+		_leave(" = %zd", result);
 		return result;
 	}
 
@@ -751,7 +751,7 @@ ssize_t afs_file_write(struct kiocb *ioc
 			result = ret;
 	}
 
-	_leave(" = %ld", result);
+	_leave(" = %zd", result);
 	return result;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
afs-implement-basic-file-write-support-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
