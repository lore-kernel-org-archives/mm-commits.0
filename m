From: akpm@linux-foundation.org
Subject: + vfs-utimensat-ignore-tv_sec-if-tv_nsec-==-utime_omit-or-utime_now.patch added to -mm tree
Date: Wed, 04 Jun 2008 21:42:03 -0700
Message-ID: <200806050442.m554g3LP025739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbYFEEmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 00:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, miklos@szeredi.hu, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT or UTIME_NOW
has been added to the -mm tree.  Its filename is
     vfs-utimensat-ignore-tv_sec-if-tv_nsec-==-utime_omit-or-utime_now.patch

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
Subject: vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT or UTIME_NOW
From: Michael Kerrisk <mtk.manpages@googlemail.com>

The POSIX.1 draft spec for utimensat() says that if a times[n].tv_nsec
field is UTIME_OMIT or UTIME_NOW, then the value in the corresponding
tv_sec field is ignored.  See the last sentence of this para, from
the spec:

    If the tv_nsec field of a timespec structure has
    the special value UTIME_NOW, the file's relevant
    timestamp shall be set to the greatest value
    supported by the file system that is not greater than
    the current time. If the tv_nsec field has the
    special value UTIME_OMIT, the file's relevant
    timestamp shall not be changed. In either case,
    the tv_sec field shall be ignored.

However the current Linux implementation requires the tv_sec value to be
zero (or the EINVAL error results). This requirement should be removed.

Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/utimes.c~vfs-utimensat-ignore-tv_sec-if-tv_nsec-==-utime_omit-or-utime_now fs/utimes.c
--- a/fs/utimes.c~vfs-utimensat-ignore-tv_sec-if-tv_nsec-==-utime_omit-or-utime_now
+++ a/fs/utimes.c
@@ -169,14 +169,6 @@ asmlinkage long sys_utimensat(int dfd, c
 	if (utimes) {
 		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
 			return -EFAULT;
-		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
-		     tstimes[0].tv_nsec == UTIME_NOW) &&
-		    tstimes[0].tv_sec != 0)
-			return -EINVAL;
-		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
-		     tstimes[1].tv_nsec == UTIME_NOW) &&
-		    tstimes[1].tv_sec != 0)
-			return -EINVAL;
 
 		/* Nothing to do, we must not even check the path.  */
 		if (tstimes[0].tv_nsec == UTIME_OMIT &&
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

ipc-restore-msgpool-original-value.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
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
vfs-utimensat-ignore-tv_sec-if-tv_nsec-==-utime_omit-or-utime_now.patch
vfs-utimensat-be-consistent-with-utime-for-immutable-and-append-only-files.patch
vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case.patch
vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case-cleanup.patch
vfs-utimensat-fix-write-access-check-for-futimens.patch

