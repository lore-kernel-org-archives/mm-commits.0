From: akpm@linux-foundation.org
Subject: - vfs-utimensat-be-consistent-with-utime-for-immutable-and-append-only-files.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:55 -0700
Message-ID: <200807020747.m627ltSr005686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbYGBH5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, drepper@redhat.com, miklos@szeredi.hu, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: utimensat(): be consistent with utime() for immutable and append-only files
has been removed from the -mm tree.  Its filename was
     vfs-utimensat-be-consistent-with-utime-for-immutable-and-append-only-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: utimensat(): be consistent with utime() for immutable and append-only files
From: Michael Kerrisk <mtk.manpages@googlemail.com>

This patch fixes utimensat() to make its behavior consistent
with that of utime()/utimes() when dealing with files marked
immutable and append-only.

The current utimensat() implementation also returns EPERM if
'times' is non-NULL and the tv_nsec fields are both UTIME_NOW.
For consistency, the

(times != NULL && times[0].tv_nsec == UTIME_NOW &&
                  times[1].tv_nsec == UTIME_NOW)

case should be treated like the traditional utimes() case where
'times' is NULL.  That is, the call should succeed for a file
marked append-only and should give the error EACCES if the file
is marked as immutable.

The simple way to do this is to set 'times' to NULL
if (times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec == UTIME_NOW).

This is also the natural approach, since POSIX.1 semantics consider the
times == {{x, UTIME_NOW}, {y, UTIME_NOW}}
to be exactly equivalent to the case for
times == NULL.

(Thanks to Miklos for pointing this out.)

Patch 3 in this series relies on the simplification provided
by this patch.

Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/utimes.c~vfs-utimensat-be-consistent-with-utime-for-immutable-and-append-only-files fs/utimes.c
--- a/fs/utimes.c~vfs-utimensat-be-consistent-with-utime-for-immutable-and-append-only-files
+++ a/fs/utimes.c
@@ -102,6 +102,10 @@ long do_utimes(int dfd, char __user *fil
 	if (error)
 		goto dput_and_out;
 
+	if (times && times[0].tv_nsec == UTIME_NOW &&
+		     times[1].tv_nsec == UTIME_NOW)
+		times = NULL;
+
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

origin.patch
man-pages-is-supported.patch
doc-document-the-relax_domain_level-kernel-boot-argument.patch
doc-document-the-relax_domain_level-kernel-boot-argument-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-move-region-tracking-earlier.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-socket-and-socketpair-mips-fix.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd.patch
flag-parameters-eventfd-fix.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parameters-inotify_init-fix.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch
flag-parameters-check-magic-constants-alpha.patch
flag-parameters-add-on-remove-epoll_create-size-param.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch

