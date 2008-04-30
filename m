From: akpm@linux-foundation.org
Subject: + vfs-fix-permission-checking-in-sys_utimensat.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:33:19 -0700
Message-ID: <200804301733.m3UHXJx9025920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757836AbYD3Ree (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, drepper@redhat.com, mtk-manpages@gmx.net, stable@kernel.org


The patch titled
     vfs: fix permission checking in sys_utimensat
has been added to the -mm tree.  Its filename is
     vfs-fix-permission-checking-in-sys_utimensat.patch

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
Subject: vfs: fix permission checking in sys_utimensat
From: Miklos Szeredi <mszeredi@suse.cz>

If utimensat() is called with both times set to UTIME_NOW or one of them to
UTIME_NOW and the other to UTIME_OMIT, then it will update the file time
without any permission checking.

I don't think this can be used for anything other than a local DoS, but could
be quite bewildering at that (e.g.  "Why was that large source tree rebuilt
when I didn't modify anything???")

This affects all kernels from 2.6.22, when the utimensat() syscall was
introduced.

Fix by doing the same permission checking as for the "times == NULL" case.

Thanks to Michael Kerrisk, whose utimensat-non-conformances-and-fixes.patch in
-mm also fixes this (and breaks other stuff), only he didn't realize the
security implications of this bug.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/utimes.c~vfs-fix-permission-checking-in-sys_utimensat fs/utimes.c
--- a/fs/utimes.c~vfs-fix-permission-checking-in-sys_utimensat
+++ a/fs/utimes.c
@@ -40,9 +40,14 @@ asmlinkage long sys_utime(char __user *f
 
 #endif
 
+static bool nsec_special(long nsec)
+{
+	return nsec == UTIME_OMIT || nsec == UTIME_NOW;
+}
+
 static bool nsec_valid(long nsec)
 {
-	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
+	if (nsec_special(nsec))
 		return true;
 
 	return nsec >= 0 && nsec <= 999999999;
@@ -119,7 +124,15 @@ long do_utimes(int dfd, char __user *fil
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
-	} else {
+	}
+
+	/*
+	 * If times is NULL or both times are either UTIME_OMIT or
+	 * UTIME_NOW, then need to check permissions, because
+	 * inode_change_ok() won't do it.
+	 */
+	if (!times || (nsec_special(times[0].tv_nsec) &&
+		       nsec_special(times[1].tv_nsec))) {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-add-nr_writeback_temp-counter.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-sparse-warnings.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

