From: akpm@linux-foundation.org
Subject: + vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case.patch added to -mm tree
Date: Wed, 04 Jun 2008 21:42:08 -0700
Message-ID: <200806050442.m554g8u5025745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYFEEmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 00:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, miklos@szeredi.hu, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT} case
has been added to the -mm tree.  Its filename is
     vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case.patch

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
Subject: vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT} case
From: Michael Kerrisk <mtk.manpages@googlemail.com>

The POSIX.1 draft spec for utimensat() says:

    Only a process with the effective user ID equal to the
    user ID of the file or with appropriate privileges may use
    futimens() or utimensat() with a non-null times argument
    that does not have both tv_nsec fields set to UTIME_NOW
    and does not have both tv_nsec fields set to UTIME_OMIT.

If this condition is violated, then the error EPERM should result.
However, the current implementation does not generate EPERM if
one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT.
It should give this error for that case.

This patch:

a) Repairs that problem.
b) Removes the now unneeded nsec_special() helper function.
c) Adds some comments to explain the checks that are being
   performed.

Thanks to Miklos, who provided comments on the previous iteration
of this patch.  As a result, this version is a little simpler and
and its logic is better structured.

Miklos suggested an alternative idea, migrating the
is_owner_or_cap() checks into fs/attr.c:inode_change_ok() via
the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
later, but for now I've gone with this version, which is
IMO simpler, and can be more easily read as being correct.

Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff -puN fs/utimes.c~vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case fs/utimes.c
--- a/fs/utimes.c~vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case
+++ a/fs/utimes.c
@@ -40,14 +40,9 @@ asmlinkage long sys_utime(char __user *f
 
 #endif
 
-static bool nsec_special(long nsec)
-{
-	return nsec == UTIME_OMIT || nsec == UTIME_NOW;
-}
-
 static bool nsec_valid(long nsec)
 {
-	if (nsec_special(nsec))
+	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
 		return true;
 
 	return nsec >= 0 && nsec <= 999999999;
@@ -106,7 +101,7 @@ long do_utimes(int dfd, char __user *fil
 		     times[1].tv_nsec == UTIME_NOW)
 		times = NULL;
 
-	/* Don't worry, the checks are done in inode_change_ok() */
+	/* In most cases, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
 		error = -EPERM;
@@ -128,15 +123,26 @@ long do_utimes(int dfd, char __user *fil
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
-	}
 
-	/*
-	 * If times is NULL or both times are either UTIME_OMIT or
-	 * UTIME_NOW, then need to check permissions, because
-	 * inode_change_ok() won't do it.
-	 */
-	if (!times || (nsec_special(times[0].tv_nsec) &&
-		       nsec_special(times[1].tv_nsec))) {
+		/*
+		 * For the UTIME_OMIT/UTIME_NOW and UTIME_NOW/UTIME_OMIT
+		 * cases, we need to make an extra check that is not done by
+		 * inode_change_ok().
+		 */
+		if (((times[0].tv_nsec == UTIME_NOW &&
+			    times[1].tv_nsec == UTIME_OMIT)
+			  ||
+			   (times[0].tv_nsec == UTIME_OMIT &&
+			    times[1].tv_nsec == UTIME_NOW))
+		     && !is_owner_or_cap(inode))
+				goto mnt_drop_write_and_out;
+	} else {
+
+		/*
+		 * If times is NULL (or both times are UTIME_NOW),
+		 * then we need to check permissions, because
+		 * inode_change_ok() won't do it.
+		 */
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
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

