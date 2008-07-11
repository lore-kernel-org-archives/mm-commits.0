From: akpm@linux-foundation.org
Subject: - some-unchangelogged-un-signed-off-but-important-looking-ide-cd-fix.patch removed from -mm tree
Date: Fri, 11 Jul 2008 12:00:01 -0700
Message-ID: <200807111900.m6BJ02ak031705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYGKTAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 15:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, bzolnier@gmail.com, jack@suse.cz, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     some unchangelogged, un-signed-off but important-looking ide-cd fix
has been removed from the -mm tree.  Its filename was
     some-unchangelogged-un-signed-off-but-important-looking-ide-cd-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: some unchangelogged, un-signed-off but important-looking ide-cd fix
From: Jens Axboe <jens.axboe@oracle.com>

On Thu, Jun 26 2008, Michael Buesch wrote:
> On Thursday 26 June 2008 20:11:42 Jens Axboe wrote:
> > On Thu, Jun 26 2008, Jan Kara wrote:
> > > On Wed 25-06-08 11:46:29, Michael Buesch wrote:
> > > > On Wednesday 25 June 2008 11:37:00 Jan Kara wrote:
> > > > > > Yeah the IO error is the trigger.
> > > > > > I noticed that it had obvious troubles accessing the DVD that was in the drive.
> > > > > > It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> > > > > > and then oopsed. But after that everything continued to work as usual.
> > > > > > (Except kded of course)
> > > > >   Hmm, by "accessing" do you mean that you've mounted the burned DVD and when
> > > > > browsing it the IO error and the oops occured or that IO error happened
> > > > > when burning? It is important because in the first case i_blkbits would be
> > > > > taken from some ISOFS inode desribing some file while in the second case
> > > > > i_blkbits are from the inode of the device...
> > > > I don't know. kded, which caused the oops, is always running. It is a KDE daemon
> > > > that polls device state and so on. So yeah, it might have accessed the drive
> > > > while growisofs was writing to it.
> > > >
> > > > However with "accessing" I mean the DVD drive motor was spinning up and down
> > > > and the laser lens was moving like crazy. The sound that happens, if you put
> > > > a completely scratched DVD into the drive and it is unable to make sense of it.
> > > > However, this was not scratched. It was a new DVD with one session on it that
> > > > I just burnt 5 minutes before that. So I wanted to append another session to it
> > > > and it crashed and resulted in IO errors in growisofs.
> > >   I've been looking into this problem for some time. The only way how
> > >   I see blocksize can be set so big is in cdrom_read_capacity() in
> > >   drivers/ide/ide-cd.c. That basically blindly fills in
> > >   queue->hardsect_size with what the drive returns and this can
> > >   propagate in bd_set_size() to i_blkbits.  Jens, do you think that is
> > >   possible? Shouldn't ide_cd_read_toc() do some sanity checks of the
> > >   blocksize returned?
> >
> > It can't hurt, the value should be >= 512b and <= 4kb. Normally it would
> > be 2kb, but some devices have a 512b switch so that is also seen. Not
> > sure that 1kb and 4kb are valid, but at least it would still point to
> > the drive possibly returning valid data and not garbage. So accept all
> > those, reject (and complain) if it isn't one of those and default to 2kb.
>
> I agree with the need for a hardware sanity check and I would happily test
> any RFC patch :)

Something like this, totally untested...

Tested-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Jan Kara <jack@suse.cz>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -puN drivers/ide/ide-cd.c~some-unchangelogged-un-signed-off-but-important-looking-ide-cd-fix drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~some-unchangelogged-un-signed-off-but-important-looking-ide-cd-fix
+++ a/drivers/ide/ide-cd.c
@@ -1319,6 +1319,7 @@ static int cdrom_read_tocentry(ide_drive
 				struct request_sense *sense)
 {
 	unsigned char cmd[BLK_MAX_CDB];
+	int stat;
 
 	memset(cmd, 0, BLK_MAX_CDB);
 
@@ -1331,7 +1332,31 @@ static int cdrom_read_tocentry(ide_drive
 	if (msf_flag)
 		cmd[1] = 2;
 
-	return ide_cd_queue_pc(drive, cmd, 0, buf, &buflen, sense, 0, REQ_QUIET);
+	stat = ide_cd_queue_pc(drive, cmd, 0, buf, &buflen, sense, 0,
+				REQ_QUIET);
+	if (stat)
+		return stat;
+
+	/*
+	 * Sanity check the given block size
+	 */
+	switch (capbuf.blocklen) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
+		break;
+	default:
+		printk(KERN_ERR "ide-cd: weird block size %u\n",
+							capbuf.blocklen);
+		printk(KERN_ERR "ide-cd: default to 2kb block size\n");
+		capbuf.blocklen = 2048;
+		break;
+	}
+
+	*capacity = 1 + be32_to_cpu(capbuf.lba);
+	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	return 0;
 }
 
 /* Try to read the entire TOC for the disk into our internal buffer. */
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

linux-next.patch
cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch
block-use-get_unaligned_-helpers.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
dac960-push-down-bkl.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
drivers-block-pktcdvdc-avoid-useless-memset.patch
some-unchangelogged-un-signed-off-but-important-looking-ide-cd-fix.patch
compat_ioctl-handle-block=n-scsi=n.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops.patch
i2o-handle-sysfs_create_link-failures.patch
fs-partition-checkc-fix-return-value-warning.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
use-warn-in-block.patch
reiser4.patch

