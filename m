From: akpm@linux-foundation.org
Subject: [merged] fasync-use-f_lock-to-protect-f_flags.patch removed from -mm tree
Date: Wed, 11 Feb 2009 11:22:12 -0800
Message-ID: <200902111922.n1BJMCIG019344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbZBKTXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 14:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, alan@lxorguk.ukuu.org.uk, hch@lst.de, mpm@selenic.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fasync: use f_lock to protect f_flags
has been removed from the -mm tree.  Its filename was
     fasync-use-f_lock-to-protect-f_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fasync: use f_lock to protect f_flags
From: Jonathan Corbet <corbet@lwn.net>

Traditionally, changes to struct file->f_flags have been done under BKL
protection, or with no protection at all.  This patch causes all f_flags
changes after file open/creation time to be done under protection of
f_lock.  This allows the removal of some BKL usage and fixes a number of
longstanding (if microscopic) races.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Matt Mackall <mpm@selenic.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c             |    5 ++---
 drivers/usb/gadget/file_storage.c |    7 ++++++-
 fs/fcntl.c                        |    2 ++
 fs/ioctl.c                        |    7 ++++---
 fs/nfsd/vfs.c                     |    5 ++++-
 include/linux/fs.h                |    2 +-
 ipc/mqueue.c                      |    2 ++
 sound/core/oss/pcm_oss.c          |    2 ++
 sound/oss/au1550_ac97.c           |    2 ++
 sound/oss/audio.c                 |    2 ++
 sound/oss/sh_dac_audio.c          |    2 ++
 sound/oss/swarm_cs4297a.c         |    2 ++
 sound/oss/vwsnd.c                 |    2 ++
 13 files changed, 33 insertions(+), 9 deletions(-)

diff -puN drivers/char/tty_io.c~fasync-use-f_lock-to-protect-f_flags drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~fasync-use-f_lock-to-protect-f_flags
+++ a/drivers/char/tty_io.c
@@ -2162,13 +2162,12 @@ static int fionbio(struct file *file, in
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
-	/* file->f_flags is still BKL protected in the fs layer - vomit */
-	lock_kernel();
+	spin_lock(&file->f_lock);
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
-	unlock_kernel();
+	spin_unlock(&file->f_lock);
 	return 0;
 }
 
diff -puN drivers/usb/gadget/file_storage.c~fasync-use-f_lock-to-protect-f_flags drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~fasync-use-f_lock-to-protect-f_flags
+++ a/drivers/usb/gadget/file_storage.c
@@ -1711,7 +1711,9 @@ static int do_write(struct fsg_dev *fsg)
 		curlun->sense_data = SS_WRITE_PROTECTED;
 		return -EINVAL;
 	}
+	spin_lock(&curlun->filp->f_lock);
 	curlun->filp->f_flags &= ~O_SYNC;	// Default is not to wait
+	spin_unlock(&curlun->filp->f_lock);
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
@@ -1728,8 +1730,11 @@ static int do_write(struct fsg_dev *fsg)
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
 		}
-		if (fsg->cmnd[1] & 0x08)	// FUA
+		if (fsg->cmnd[1] & 0x08) {	// FUA
+			spin_lock(&curlun->filp->f_lock);
 			curlun->filp->f_flags |= O_SYNC;
+			spin_unlock(&curlun->filp->f_lock);
+		}
 	}
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
diff -puN fs/fcntl.c~fasync-use-f_lock-to-protect-f_flags fs/fcntl.c
--- a/fs/fcntl.c~fasync-use-f_lock-to-protect-f_flags
+++ a/fs/fcntl.c
@@ -189,7 +189,9 @@ static int setfl(int fd, struct file * f
 		}
 	}
 
+	spin_lock(&filp->f_lock);
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
+	spin_unlock(&filp->f_lock);
  out:
 	unlock_kernel();
 	return error;
diff -puN fs/ioctl.c~fasync-use-f_lock-to-protect-f_flags fs/ioctl.c
--- a/fs/ioctl.c~fasync-use-f_lock-to-protect-f_flags
+++ a/fs/ioctl.c
@@ -404,10 +404,12 @@ static int ioctl_fionbio(struct file *fi
 	if (O_NONBLOCK != O_NDELAY)
 		flag |= O_NDELAY;
 #endif
+	spin_lock(&filp->f_lock);
 	if (on)
 		filp->f_flags |= flag;
 	else
 		filp->f_flags &= ~flag;
+	spin_unlock(&filp->f_lock);
 	return error;
 }
 
@@ -432,10 +434,12 @@ static int ioctl_fioasync(unsigned int f
 	if (error)
 		return error;
 
+	spin_lock(&filp->f_lock);
 	if (on)
 		filp->f_flags |= FASYNC;
 	else
 		filp->f_flags &= ~FASYNC;
+	spin_unlock(&filp->f_lock);
 	return error;
 }
 
@@ -499,10 +503,7 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIONBIO:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOASYNC:
diff -puN fs/nfsd/vfs.c~fasync-use-f_lock-to-protect-f_flags fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~fasync-use-f_lock-to-protect-f_flags
+++ a/fs/nfsd/vfs.c
@@ -998,8 +998,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	if (!EX_ISSYNC(exp))
 		stable = 0;
-	if (stable && !EX_WGATHER(exp))
+	if (stable && !EX_WGATHER(exp)) {
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_SYNC;
+		spin_unlock(&file->f_lock);
+	}
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
diff -puN include/linux/fs.h~fasync-use-f_lock-to-protect-f_flags include/linux/fs.h
--- a/include/linux/fs.h~fasync-use-f_lock-to-protect-f_flags
+++ a/include/linux/fs.h
@@ -853,7 +853,7 @@ struct file {
 #define f_dentry	f_path.dentry
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
-	spinlock_t		f_lock;  /* f_ep_links */
+	spinlock_t		f_lock;  /* f_ep_links, f_flags */
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
diff -puN ipc/mqueue.c~fasync-use-f_lock-to-protect-f_flags ipc/mqueue.c
--- a/ipc/mqueue.c~fasync-use-f_lock-to-protect-f_flags
+++ a/ipc/mqueue.c
@@ -1156,10 +1156,12 @@ SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mq
 	omqstat.mq_flags = filp->f_flags & O_NONBLOCK;
 	if (u_mqstat) {
 		audit_mq_getsetattr(mqdes, &mqstat);
+		spin_lock(&filp->f_lock);
 		if (mqstat.mq_flags & O_NONBLOCK)
 			filp->f_flags |= O_NONBLOCK;
 		else
 			filp->f_flags &= ~O_NONBLOCK;
+		spin_unlock(&filp->f_lock);
 
 		inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	}
diff -puN sound/core/oss/pcm_oss.c~fasync-use-f_lock-to-protect-f_flags sound/core/oss/pcm_oss.c
--- a/sound/core/oss/pcm_oss.c~fasync-use-f_lock-to-protect-f_flags
+++ a/sound/core/oss/pcm_oss.c
@@ -1903,7 +1903,9 @@ static int snd_pcm_oss_set_fragment(stru
 
 static int snd_pcm_oss_nonblock(struct file * file)
 {
+	spin_lock(&file->f_lock);
 	file->f_flags |= O_NONBLOCK;
+	spin_unlock(&file->f_lock);
 	return 0;
 }
 
diff -puN sound/oss/au1550_ac97.c~fasync-use-f_lock-to-protect-f_flags sound/oss/au1550_ac97.c
--- a/sound/oss/au1550_ac97.c~fasync-use-f_lock-to-protect-f_flags
+++ a/sound/oss/au1550_ac97.c
@@ -1627,7 +1627,9 @@ au1550_ioctl(struct inode *inode, struct
 				    sizeof(abinfo)) ? -EFAULT : 0;
 
 	case SNDCTL_DSP_NONBLOCK:
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_GETODELAY:
diff -puN sound/oss/audio.c~fasync-use-f_lock-to-protect-f_flags sound/oss/audio.c
--- a/sound/oss/audio.c~fasync-use-f_lock-to-protect-f_flags
+++ a/sound/oss/audio.c
@@ -433,7 +433,9 @@ int audio_ioctl(int dev, struct file *fi
 			return dma_ioctl(dev, cmd, arg);
 		
 		case SNDCTL_DSP_NONBLOCK:
+			spin_lock(&file->f_lock);
 			file->f_flags |= O_NONBLOCK;
+			spin_unlock(&file->f_lock);
 			return 0;
 
 		case SNDCTL_DSP_GETCAPS:
diff -puN sound/oss/sh_dac_audio.c~fasync-use-f_lock-to-protect-f_flags sound/oss/sh_dac_audio.c
--- a/sound/oss/sh_dac_audio.c~fasync-use-f_lock-to-protect-f_flags
+++ a/sound/oss/sh_dac_audio.c
@@ -135,7 +135,9 @@ static int dac_audio_ioctl(struct inode 
 		return put_user(AFMT_U8, (int *)arg);
 
 	case SNDCTL_DSP_NONBLOCK:
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_GETCAPS:
diff -puN sound/oss/swarm_cs4297a.c~fasync-use-f_lock-to-protect-f_flags sound/oss/swarm_cs4297a.c
--- a/sound/oss/swarm_cs4297a.c~fasync-use-f_lock-to-protect-f_flags
+++ a/sound/oss/swarm_cs4297a.c
@@ -2200,7 +2200,9 @@ static int cs4297a_ioctl(struct inode *i
 				    sizeof(abinfo)) ? -EFAULT : 0;
 
 	case SNDCTL_DSP_NONBLOCK:
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_GETODELAY:
diff -puN sound/oss/vwsnd.c~fasync-use-f_lock-to-protect-f_flags sound/oss/vwsnd.c
--- a/sound/oss/vwsnd.c~fasync-use-f_lock-to-protect-f_flags
+++ a/sound/oss/vwsnd.c
@@ -2673,7 +2673,9 @@ static int vwsnd_audio_do_ioctl(struct i
 
 	case SNDCTL_DSP_NONBLOCK:	/* _SIO  ('P',14) */
 		DBGX("SNDCTL_DSP_NONBLOCK\n");
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_RESET:		/* _SIO  ('P', 0) */
_

Patches currently in -mm which might be from corbet@lwn.net are

linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch

