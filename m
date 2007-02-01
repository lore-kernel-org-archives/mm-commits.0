From: akpm@osdl.org
Subject: + ubi-int-versus-size_t-printk-warnings.patch added to -mm tree
Date: Thu, 01 Feb 2007 13:43:07 -0800
Message-ID: <200702012143.l11Lh7Sg023699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40920 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXBAVnd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 16:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Artem.Bityutskiy@nokia.com, alan@redhat.com


The patch titled
     ubi: int versus size_t printk warnings
has been added to the -mm tree.  Its filename is
     ubi-int-versus-size_t-printk-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ubi: int versus size_t printk warnings
From: Alan <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mtd/ubi/io.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/mtd/ubi/io.c~ubi-int-versus-size_t-printk-warnings drivers/mtd/ubi/io.c
--- a/drivers/mtd/ubi/io.c~ubi-int-versus-size_t-printk-warnings
+++ a/drivers/mtd/ubi/io.c
@@ -129,8 +129,8 @@ retry:
 			yield();
 			goto retry;
 		}
-		ubi_err("error %d while reading %d bytes from PEB %d:%d, "
-			"read %d bytes", err, len, pnum, offset, *read);
+		ubi_err("error %d while reading %Zd bytes from PEB %d:%d, "
+			"read %Zd bytes", err, len, pnum, offset, *read);
 		dump_stack();
 	}
 
@@ -190,14 +190,14 @@ int ubi_io_write(const struct ubi_info *
 
 	err = mtd_write(io, buf, pnum, offset, len, written);
 	if (unlikely(err)) {
-		ubi_err("error %d while writing %d bytes to PEB %d:%d, written"
-			" %d bytes", err, len, pnum, offset, *written);
+		ubi_err("error %d while writing %Zd bytes to PEB %d:%d, written"
+			" %Zd bytes", err, len, pnum, offset, *written);
 		dump_stack();
 	}
 
 	/* The below is just for debugging and is compiled out if disabled */
 	if (ubi_dbg_is_write_failure() && !err) {
-		ubi_err("cannot write %d bytes to PEB %d:%d (emulated)",
+		ubi_err("cannot write %Zd bytes to PEB %d:%d (emulated)",
 			len, pnum, offset);
 		dump_stack();
 		return -EIO;
@@ -597,7 +597,7 @@ int ubi_io_init(struct ubi_info *ubi, in
 
 		/* The shift must be aligned to 32-bit boundary */
 		if (io->vid_hdr_shift % 4) {
-			ubi_err("unaligned VID header shift %d",
+			ubi_err("unaligned VID header shift %Zd",
 				io->vid_hdr_shift);
 			goto out_mtd;
 		}
@@ -615,7 +615,7 @@ int ubi_io_init(struct ubi_info *ubi, in
 	    io->leb_start < io->vid_hdr_offset + UBI_VID_HDR_SIZE ||
 	    io->leb_start > io->peb_size - UBI_VID_HDR_SIZE ||
 	    io->leb_start % io->min_io_size) {
-		ubi_err("bad VID header (%d) or data offsets (%d)",
+		ubi_err("bad VID header (%Zd) or data offsets (%Zd)",
 			io->vid_hdr_offset, io->leb_start);
 		goto out_mtd;
 	}
@@ -847,12 +847,12 @@ static int validate_ec_hdr(const struct 
 		goto bad;
 	}
 	if (unlikely(vid_hdr_offset != io->vid_hdr_offset)) {
-		ubi_err("bad VID header offset %d at PEB %d, expected %d",
+		ubi_err("bad VID header offset %d at PEB %d, expected %Zd",
 			vid_hdr_offset, pnum, io->vid_hdr_offset);
 		goto bad;
 	}
 	if (unlikely(leb_start != io->leb_start)) {
-		ubi_err("bad data offset %d at PEB %d, expected %d",
+		ubi_err("bad data offset %d at PEB %d, expected %Zd",
 			pnum, leb_start, io->leb_start);
 		goto bad;
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

via-quirk-fix-update.patch
git-libata-all.patch
git-mtd.patch
ubi-int-versus-size_t-printk-warnings.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
sched-avoid-div-in-rebalance_tick.patch
