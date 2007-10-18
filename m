From: akpm@linux-foundation.org
Subject: - fs-correct-sus-compliance-for-open-of-large-file-without.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:37 -0700
Message-ID: <200710180701.l9I71b80031191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761161AbXJRHlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, arjan@infradead.org, jens.axboe@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     fs: correct SuS compliance for open of large file without options
has been removed from the -mm tree.  Its filename was
     fs-correct-sus-compliance-for-open-of-large-file-without.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: correct SuS compliance for open of large file without options
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The early LFS work that Linux uses favours EFBIG in various places. SuSv3
specifically uses EOVERFLOW for this as noted by Michael (Bug 7253)

[EOVERFLOW]
    The named file is a regular file and the size of the file cannot be
represented correctly in an object of type off_t. We should therefore
transition to the proper error return code

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_file.c |    2 +-
 fs/ntfs/file.c     |    2 +-
 fs/open.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/gfs2/ops_file.c~fs-correct-sus-compliance-for-open-of-large-file-without fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~fs-correct-sus-compliance-for-open-of-large-file-without
+++ a/fs/gfs2/ops_file.c
@@ -406,7 +406,7 @@ static int gfs2_open(struct inode *inode
 
 		if (!(file->f_flags & O_LARGEFILE) &&
 		    ip->i_di.di_size > MAX_NON_LFS) {
-			error = -EFBIG;
+			error = -EOVERFLOW;
 			goto fail_gunlock;
 		}
 
diff -puN fs/ntfs/file.c~fs-correct-sus-compliance-for-open-of-large-file-without fs/ntfs/file.c
--- a/fs/ntfs/file.c~fs-correct-sus-compliance-for-open-of-large-file-without
+++ a/fs/ntfs/file.c
@@ -61,7 +61,7 @@ static int ntfs_file_open(struct inode *
 {
 	if (sizeof(unsigned long) < 8) {
 		if (i_size_read(vi) > MAX_LFS_FILESIZE)
-			return -EFBIG;
+			return -EOVERFLOW;
 	}
 	return generic_file_open(vi, filp);
 }
diff -puN fs/open.c~fs-correct-sus-compliance-for-open-of-large-file-without fs/open.c
--- a/fs/open.c~fs-correct-sus-compliance-for-open-of-large-file-without
+++ a/fs/open.c
@@ -1177,7 +1177,7 @@ asmlinkage long sys_vhangup(void)
 int generic_file_open(struct inode * inode, struct file * filp)
 {
 	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EFBIG;
+		return -EOVERFLOW;
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
libata-sff-correct-use-of-check_status.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
