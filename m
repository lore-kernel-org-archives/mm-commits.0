From: akpm@linux-foundation.org
Subject: - vfs-utimensat-fix-write-access-check-for-futimens.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:48:01 -0700
Message-ID: <200807020748.m627m1ZZ005698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbYGBHsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, drepper@redhat.com, miklos@szeredi.hu, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: utimensat(): fix write access check for futimens()
has been removed from the -mm tree.  Its filename was
     vfs-utimensat-fix-write-access-check-for-futimens.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: utimensat(): fix write access check for futimens()
From: Michael Kerrisk <mtk.manpages@googlemail.com>

The POSIX.1 draft spec for futimens()/utimensat() says:

        Only a process with the effective user ID equal to the
        user ID of the file, *or with write access to the file*,
        or with appropriate privileges may use futimens() or
        utimensat() with a null pointer as the times argument
        or with both tv_nsec fields set to the special value
        UTIME_NOW.

The important piece here is "with write access to the file", and
this matters for futimens(), which deals with an argument that
is a file descriptor referring to the file whose timestamps are
being updated,  The standard is saying that the "writability"
check is based on the file permissions, not the access mode with
which the file is opened.  (This behavior is consistent with the
semantics of FreeBSD's futimes().)  However, Linux is currently
doing the latter -- futimens(fd, times) is a library
function implemented as

       utimensat(fd, NULL, times, 0)

and within the utimensat() implementation we have the code:

                f = fget(dfd);  // dfd is 'fd'
                ...
                if (f) {
                        if (!(f->f_mode & FMODE_WRITE))
                                goto mnt_drop_write_and_out;

The check should instead be based on the file permissions.

Thanks to Miklos for pointing out how to do this check.
Miklos also pointed out a simplification that could be
made to my first version of this patch, since the checks
for the pathname and file descriptor cases can now be
conflated.

Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/utimes.c~vfs-utimensat-fix-write-access-check-for-futimens fs/utimes.c
--- a/fs/utimes.c~vfs-utimensat-fix-write-access-check-for-futimens
+++ a/fs/utimes.c
@@ -148,14 +148,9 @@ long do_utimes(int dfd, char __user *fil
 			goto mnt_drop_write_and_out;
 
 		if (!is_owner_or_cap(inode)) {
-			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
-					goto mnt_drop_write_and_out;
-			} else {
-				error = vfs_permission(&nd, MAY_WRITE);
-				if (error)
-					goto mnt_drop_write_and_out;
-			}
+			error = permission(inode, MAY_WRITE, NULL);
+			if (error)
+				goto mnt_drop_write_and_out;
 		}
 	}
 	mutex_lock(&inode->i_mutex);
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

