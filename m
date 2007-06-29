From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-sbpcd-driver.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:19:07 -0700
Message-ID: <200706292019.l5TKJ75U021423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbXF2UTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, emoenke@gwdg.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in SBPCD driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-sbpcd-driver.patch

This patch was dropped because this driver gets deleted in Jens's tree

------------------------------------------------------
Subject: use mutex instead of semaphore in SBPCD driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The SBPCD driver uses a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Acked-by: Eberhard Moenkeberg <emoenke@gwdg.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/sbpcd.c |  145 ++++++++++++++++++++--------------------
 1 files changed, 73 insertions(+), 72 deletions(-)

diff -puN drivers/cdrom/sbpcd.c~use-mutex-instead-of-semaphore-in-sbpcd-driver drivers/cdrom/sbpcd.c
--- a/drivers/cdrom/sbpcd.c~use-mutex-instead-of-semaphore-in-sbpcd-driver
+++ a/drivers/cdrom/sbpcd.c
@@ -373,6 +373,7 @@
 #include <linux/ioport.h>
 #include <linux/major.h>
 #include <linux/string.h>
+#include <linux/mutex.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -602,7 +603,7 @@ static u_char xa_tail_buf[CD_XA_TAIL];
 static volatile u_char busy_data;
 static volatile u_char busy_audio; /* true semaphores would be safer */
 #endif /* OLD_BUSY */ 
-static DECLARE_MUTEX(ioctl_read_sem);
+static DEFINE_MUTEX(ioctl_read_mtx);
 static u_long timeout;
 static volatile u_char timed_out_delay;
 static volatile u_char timed_out_data;
@@ -834,7 +835,7 @@ static void sbp_sleep(u_int time)
 	sti();
 }
 /*==========================================================================*/
-#define RETURN_UP(rc) {up(&ioctl_read_sem); return(rc);}
+#define RETURN_UNLOCK(rc) {mutex_unlock(&ioctl_read_mtx); return(rc);}
 /*==========================================================================*/
 /*
  *  convert logical_block_address to m-s-f_number (3 bytes only)
@@ -4174,7 +4175,7 @@ static int sbpcd_audio_ioctl(struct cdro
 		msg(DBG_INF, "ioctl: bad device: %s\n", cdi->name);
 		return (-ENXIO);             /* no such drive */
 	}
-	down(&ioctl_read_sem);
+	mutex_lock(&ioctl_read_mtx);
 	if (p != current_drive)
 		switch_drive(p);
 	
@@ -4193,19 +4194,19 @@ static int sbpcd_audio_ioctl(struct cdro
 		case audio_playing:
 			if (famL_drive) i=cc_ReadSubQ();
 			else i=cc_Pause_Resume(1);
-			if (i<0) RETURN_UP(-EIO);
+			if (i<0) RETURN_UNLOCK(-EIO);
 			if (famL_drive) i=cc_Pause_Resume(1);
 			else i=cc_ReadSubQ();
-			if (i<0) RETURN_UP(-EIO);
+			if (i<0) RETURN_UNLOCK(-EIO);
 			current_drive->pos_audio_start=current_drive->SubQ_run_tot;
 			current_drive->audio_state=audio_pausing;
-			RETURN_UP(0);
+			RETURN_UNLOCK(0);
 		case audio_pausing:
 			i=cc_Seek(current_drive->pos_audio_start,1);
-			if (i<0) RETURN_UP(-EIO);
-			RETURN_UP(0);
+			if (i<0) RETURN_UNLOCK(-EIO);
+			RETURN_UNLOCK(0);
 		default:
-			RETURN_UP(-EINVAL);
+			RETURN_UNLOCK(-EINVAL);
 		}
 
 	case CDROMRESUME: /* resume paused audio play */
@@ -4213,26 +4214,26 @@ static int sbpcd_audio_ioctl(struct cdro
 		/* resume playing audio tracks when a previous PLAY AUDIO call has  */
 		/* been paused with a PAUSE command.                                */
 		/* It will resume playing from the location saved in SubQ_run_tot.  */
-		if (current_drive->audio_state!=audio_pausing) RETURN_UP(-EINVAL);
+		if (current_drive->audio_state!=audio_pausing) RETURN_UNLOCK(-EINVAL);
 		if (famL_drive)
 			i=cc_PlayAudio(current_drive->pos_audio_start,
 				       current_drive->pos_audio_end);
 		else i=cc_Pause_Resume(3);
-		if (i<0) RETURN_UP(-EIO);
+		if (i<0) RETURN_UNLOCK(-EIO);
 		current_drive->audio_state=audio_playing;
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	case CDROMPLAYMSF:
 		msg(DBG_IOC,"ioctl: CDROMPLAYMSF entered.\n");
 #ifdef SAFE_MIXED
-		if (current_drive->has_data>1) RETURN_UP(-EBUSY);
+		if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
 #endif /* SAFE_MIXED */
 		if (current_drive->audio_state==audio_playing)
 		{
 			i=cc_Pause_Resume(1);
-			if (i<0) RETURN_UP(-EIO);
+			if (i<0) RETURN_UNLOCK(-EIO);
 			i=cc_ReadSubQ();
-			if (i<0) RETURN_UP(-EIO);
+			if (i<0) RETURN_UNLOCK(-EIO);
 			current_drive->pos_audio_start=current_drive->SubQ_run_tot;
 			i=cc_Seek(current_drive->pos_audio_start,1);
 		}
@@ -4252,30 +4253,30 @@ static int sbpcd_audio_ioctl(struct cdro
 			msg(DBG_INF,"ioctl: cc_PlayAudio returns %d\n",i);
 			DriveReset();
 			current_drive->audio_state=0;
-			RETURN_UP(-EIO);
+			RETURN_UNLOCK(-EIO);
 		}
 		current_drive->audio_state=audio_playing;
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 		
 	case CDROMPLAYTRKIND: /* Play a track.  This currently ignores index. */
 		msg(DBG_IOC,"ioctl: CDROMPLAYTRKIND entered.\n");
 #ifdef SAFE_MIXED
-		if (current_drive->has_data>1) RETURN_UP(-EBUSY);
+		if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
 #endif /* SAFE_MIXED */
 		if (current_drive->audio_state==audio_playing)
 		{
 			msg(DBG_IOX,"CDROMPLAYTRKIND: already audio_playing.\n");
 #if 1
-			RETURN_UP(0); /* just let us play on */
+			RETURN_UNLOCK(0); /* just let us play on */
 #else
-			RETURN_UP(-EINVAL); /* play on, but say "error" */
+			RETURN_UNLOCK(-EINVAL); /* play on, but say "error" */
 #endif
 		}
 		memcpy(&ti,(void *) arg,sizeof(struct cdrom_ti));
 		msg(DBG_IOX,"ioctl: trk0: %d, ind0: %d, trk1:%d, ind1:%d\n",
 		    ti.cdti_trk0,ti.cdti_ind0,ti.cdti_trk1,ti.cdti_ind1);
-		if (ti.cdti_trk0<current_drive->n_first_track) RETURN_UP(-EINVAL);
-		if (ti.cdti_trk0>current_drive->n_last_track) RETURN_UP(-EINVAL);
+		if (ti.cdti_trk0<current_drive->n_first_track) RETURN_UNLOCK(-EINVAL);
+		if (ti.cdti_trk0>current_drive->n_last_track) RETURN_UNLOCK(-EINVAL);
 		if (ti.cdti_trk1<ti.cdti_trk0) ti.cdti_trk1=ti.cdti_trk0;
 		if (ti.cdti_trk1>current_drive->n_last_track) ti.cdti_trk1=current_drive->n_last_track;
 		current_drive->pos_audio_start=current_drive->TocBuffer[ti.cdti_trk0].address;
@@ -4286,17 +4287,17 @@ static int sbpcd_audio_ioctl(struct cdro
 			msg(DBG_INF,"ioctl: cc_PlayAudio returns %d\n",i);
 			DriveReset();
 			current_drive->audio_state=0;
-			RETURN_UP(-EIO);
+			RETURN_UNLOCK(-EIO);
 		}
 		current_drive->audio_state=audio_playing;
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 		
 	case CDROMREADTOCHDR:        /* Read the table of contents header */
 		msg(DBG_IOC,"ioctl: CDROMREADTOCHDR entered.\n");
 		tochdr.cdth_trk0=current_drive->n_first_track;
 		tochdr.cdth_trk1=current_drive->n_last_track;
 		memcpy((void *) arg, &tochdr, sizeof(struct cdrom_tochdr));
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 		
 	case CDROMREADTOCENTRY:      /* Read an entry in the table of contents */
 		msg(DBG_IOC,"ioctl: CDROMREADTOCENTRY entered.\n");
@@ -4304,7 +4305,7 @@ static int sbpcd_audio_ioctl(struct cdro
 		i=tocentry.cdte_track;
 		if (i==CDROM_LEADOUT) i=current_drive->n_last_track+1;
 		else if (i<current_drive->n_first_track||i>current_drive->n_last_track)
-                  RETURN_UP(-EINVAL);
+                  RETURN_UNLOCK(-EINVAL);
 		tocentry.cdte_adr=current_drive->TocBuffer[i].ctl_adr&0x0F;
 		tocentry.cdte_ctrl=(current_drive->TocBuffer[i].ctl_adr>>4)&0x0F;
 		tocentry.cdte_datamode=current_drive->TocBuffer[i].format;
@@ -4316,27 +4317,27 @@ static int sbpcd_audio_ioctl(struct cdro
 		}
 		else if (tocentry.cdte_format==CDROM_LBA) /* blk required */
 			tocentry.cdte_addr.lba=msf2blk(current_drive->TocBuffer[i].address);
-		else RETURN_UP(-EINVAL);
+		else RETURN_UNLOCK(-EINVAL);
 		memcpy((void *) arg, &tocentry, sizeof(struct cdrom_tocentry));
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 		
 	case CDROMSTOP:      /* Spin down the drive */
 		msg(DBG_IOC,"ioctl: CDROMSTOP entered.\n");
 #ifdef SAFE_MIXED
-		if (current_drive->has_data>1) RETURN_UP(-EBUSY);
+		if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
 #endif /* SAFE_MIXED */ 
 		i=cc_Pause_Resume(1);
 		current_drive->audio_state=0;
 #if 0
 		cc_DriveReset();
 #endif
-		RETURN_UP(i);
+		RETURN_UNLOCK(i);
 
 	case CDROMSTART:  /* Spin up the drive */
 		msg(DBG_IOC,"ioctl: CDROMSTART entered.\n");
 		cc_SpinUp();
 		current_drive->audio_state=0;
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	case CDROMVOLCTRL:   /* Volume control */
 		msg(DBG_IOC,"ioctl: CDROMVOLCTRL entered.\n");
@@ -4346,25 +4347,25 @@ static int sbpcd_audio_ioctl(struct cdro
 		current_drive->vol_chan1=1;
 		current_drive->vol_ctrl1=volctrl.channel1;
 		i=cc_SetVolume();
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	case CDROMVOLREAD:   /* read Volume settings from drive */
 		msg(DBG_IOC,"ioctl: CDROMVOLREAD entered.\n");
 		st=cc_GetVolume();
-		if (st<0) RETURN_UP(st);
+		if (st<0) RETURN_UNLOCK(st);
 		volctrl.channel0=current_drive->vol_ctrl0;
 		volctrl.channel1=current_drive->vol_ctrl1;
 		volctrl.channel2=0;
 		volctrl.channel2=0;
 		memcpy((void *)arg,&volctrl,sizeof(volctrl));
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	case CDROMSUBCHNL:   /* Get subchannel info */
 		msg(DBG_IOS,"ioctl: CDROMSUBCHNL entered.\n");
 		/* Bogus, I can do better than this! --AJK
 		if ((st_spinning)||(!subq_valid)) {
 			i=cc_ReadSubQ();
-			if (i<0) RETURN_UP(-EIO);
+			if (i<0) RETURN_UNLOCK(-EIO);
 		}
 		*/
 		i=cc_ReadSubQ();
@@ -4378,7 +4379,7 @@ static int sbpcd_audio_ioctl(struct cdro
 				msg(DBG_000,"Disk changed detect\n");
 				current_drive->diskstate_flags &= ~cd_size_bit;
 			}
-			RETURN_UP(-EIO);
+			RETURN_UNLOCK(-EIO);
 		}
 		if (current_drive->CD_changed==0xFF) {
 			/* reread the TOC because the disk has changed! --AJK */
@@ -4386,9 +4387,9 @@ static int sbpcd_audio_ioctl(struct cdro
 			i=DiskInfo();
 			if(i==0) {
 				current_drive->CD_changed=0x00; /* cd has changed, procede, */
-				RETURN_UP(-EIO); /* and get TOC, etc on next try! --AJK */
+				RETURN_UNLOCK(-EIO); /* and get TOC, etc on next try! --AJK */
 			} else {
-				RETURN_UP(-EIO); /* we weren't ready yet! --AJK */
+				RETURN_UNLOCK(-EIO); /* we weren't ready yet! --AJK */
 			}
 		}
 		memcpy(&SC, (void *) arg, sizeof(struct cdrom_subchnl));
@@ -4451,11 +4452,11 @@ static int sbpcd_audio_ioctl(struct cdro
 		    SC.cdsc_adr,SC.cdsc_ctrl,
 		    SC.cdsc_trk,SC.cdsc_ind,
 		    SC.cdsc_absaddr,SC.cdsc_reladdr);
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	default:
 		msg(DBG_IOC,"ioctl: unknown function request %04X\n", cmd);
-		RETURN_UP(-EINVAL);
+		RETURN_UNLOCK(-EINVAL);
 	} /* end switch(cmd) */
 }
 /*==========================================================================*/
@@ -4549,7 +4550,7 @@ static void do_sbpcd_request(request_que
 		end_request(req, 0);
 	spin_unlock_irq(q->queue_lock);
 
-	down(&ioctl_read_sem);
+	mutex_lock(&ioctl_read_mtx);
 	if (rq_data_dir(elv_next_request(q)) != READ)
 	{
 		msg(DBG_INF, "bad cmd %d\n", req->cmd[0]);
@@ -4581,7 +4582,7 @@ static void do_sbpcd_request(request_que
 		printk(" do_sbpcd_request[%do](%p:%ld+%ld) end 2, Time:%li\n",
 			xnr, req, req->sector, req->nr_sectors, jiffies);
 #endif
-		up(&ioctl_read_sem);
+		mutex_unlock(&ioctl_read_mtx);
 		spin_lock_irq(q->queue_lock);
 		end_request(req, 1);
 		goto request_loop;
@@ -4622,7 +4623,7 @@ static void do_sbpcd_request(request_que
 			printk(" do_sbpcd_request[%do](%p:%ld+%ld) end 3, Time:%li\n",
 				xnr, req, req->sector, req->nr_sectors, jiffies);
 #endif
-			up(&ioctl_read_sem);
+			mutex_unlock(&ioctl_read_mtx);
 			spin_lock_irq(q->queue_lock);
 			end_request(req, 1);
 			goto request_loop;
@@ -4637,7 +4638,7 @@ static void do_sbpcd_request(request_que
 	printk(" do_sbpcd_request[%do](%p:%ld+%ld) end 4 (error), Time:%li\n",
 		xnr, req, req->sector, req->nr_sectors, jiffies);
 #endif
-	up(&ioctl_read_sem);
+	mutex_unlock(&ioctl_read_mtx);
 	sbp_sleep(0);    /* wait a bit, try again */
 	spin_lock_irq(q->queue_lock);
 	end_request(req, 0);
@@ -5059,7 +5060,7 @@ static int sbpcd_block_ioctl(struct inod
 		msg(DBG_INF, "ioctl: bad device: %s\n", cdi->name);
 		return (-ENXIO);             /* no such drive */
 	}
-	down(&ioctl_read_sem);
+	mutex_lock(&ioctl_read_mtx);
 	if (p != current_drive)
 		switch_drive(p);
 	
@@ -5067,34 +5068,34 @@ static int sbpcd_block_ioctl(struct inod
 	switch (cmd) 		/* Sun-compatible */
 	{
 	case DDIOCSDBG:		/* DDI Debug */
-		if (!capable(CAP_SYS_ADMIN)) RETURN_UP(-EPERM);
+		if (!capable(CAP_SYS_ADMIN)) RETURN_UNLOCK(-EPERM);
 		i=sbpcd_dbg_ioctl(arg,1);
-		RETURN_UP(i);
+		RETURN_UNLOCK(i);
 	case CDROMRESET:      /* hard reset the drive */
 		msg(DBG_IOC,"ioctl: CDROMRESET entered.\n");
 		i=DriveReset();
 		current_drive->audio_state=0;
-		RETURN_UP(i);
+		RETURN_UNLOCK(i);
 
 	case CDROMREADMODE1:
 		msg(DBG_IOC,"ioctl: CDROMREADMODE1 requested.\n");
 #ifdef SAFE_MIXED
-		if (current_drive->has_data>1) RETURN_UP(-EBUSY);
+		if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
 #endif /* SAFE_MIXED */
 		cc_ModeSelect(CD_FRAMESIZE);
 		cc_ModeSense();
 		current_drive->mode=READ_M1;
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	case CDROMREADMODE2: /* not usable at the moment */
 		msg(DBG_IOC,"ioctl: CDROMREADMODE2 requested.\n");
 #ifdef SAFE_MIXED
-		if (current_drive->has_data>1) RETURN_UP(-EBUSY);
+		if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
 #endif /* SAFE_MIXED */
 		cc_ModeSelect(CD_FRAMESIZE_RAW1);
 		cc_ModeSense();
 		current_drive->mode=READ_M2;
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 
 	case CDROMAUDIOBUFSIZ: /* configure the audio buffer size */
 		msg(DBG_IOC,"ioctl: CDROMAUDIOBUFSIZ entered.\n");
@@ -5106,7 +5107,7 @@ static int sbpcd_block_ioctl(struct inod
 		if (current_drive->sbp_audsiz>16)
 		{
 			current_drive->sbp_audsiz = 0;
-			RETURN_UP(current_drive->sbp_audsiz);
+			RETURN_UNLOCK(current_drive->sbp_audsiz);
 		}
 	
 		if (current_drive->sbp_audsiz>0)
@@ -5119,7 +5120,7 @@ static int sbpcd_block_ioctl(struct inod
 			}
 			else msg(DBG_INF,"audio buffer size: %d frames.\n",current_drive->sbp_audsiz);
 		}
-		RETURN_UP(current_drive->sbp_audsiz);
+		RETURN_UNLOCK(current_drive->sbp_audsiz);
 
 	case CDROMREADAUDIO:
 	{ /* start of CDROMREADAUDIO */
@@ -5134,27 +5135,27 @@ static int sbpcd_block_ioctl(struct inod
 		int error_flag;
 
 		msg(DBG_IOC,"ioctl: CDROMREADAUDIO entered.\n");
-		if (fam0_drive) RETURN_UP(-EINVAL);
-		if (famL_drive) RETURN_UP(-EINVAL);
-		if (famV_drive) RETURN_UP(-EINVAL);
-		if (famT_drive) RETURN_UP(-EINVAL);
+		if (fam0_drive) RETURN_UNLOCK(-EINVAL);
+		if (famL_drive) RETURN_UNLOCK(-EINVAL);
+		if (famV_drive) RETURN_UNLOCK(-EINVAL);
+		if (famT_drive) RETURN_UNLOCK(-EINVAL);
 #ifdef SAFE_MIXED
-		if (current_drive->has_data>1) RETURN_UP(-EBUSY);
+		if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
 #endif /* SAFE_MIXED */
-		if (current_drive->aud_buf==NULL) RETURN_UP(-EINVAL);
+		if (current_drive->aud_buf==NULL) RETURN_UNLOCK(-EINVAL);
 		if (copy_from_user(&read_audio, (void __user *)arg,
 				   sizeof(struct cdrom_read_audio)))
-			RETURN_UP(-EFAULT);
-		if (read_audio.nframes < 0 || read_audio.nframes>current_drive->sbp_audsiz) RETURN_UP(-EINVAL);
+			RETURN_UNLOCK(-EFAULT);
+		if (read_audio.nframes < 0 || read_audio.nframes>current_drive->sbp_audsiz) RETURN_UNLOCK(-EINVAL);
 		if (!access_ok(VERIFY_WRITE, read_audio.buf,
 			      read_audio.nframes*CD_FRAMESIZE_RAW))
-                	RETURN_UP(-EFAULT);
+                	RETURN_UNLOCK(-EFAULT);
 
 		if (read_audio.addr_format==CDROM_MSF) /* MSF-bin specification of where to start */
 			block=msf2lba(&read_audio.addr.msf.minute);
 		else if (read_audio.addr_format==CDROM_LBA) /* lba specification of where to start */
 			block=read_audio.addr.lba;
-		else RETURN_UP(-EINVAL);
+		else RETURN_UNLOCK(-EINVAL);
 #if 000
 		i=cc_SetSpeed(speed_150,0,0);
 		if (i) msg(DBG_AUD,"read_audio: SetSpeed error %d\n", i);
@@ -5344,7 +5345,7 @@ static int sbpcd_block_ioctl(struct inod
 			if (copy_to_user(read_audio.buf,
 					 current_drive->aud_buf,
 					 read_audio.nframes * CD_FRAMESIZE_RAW))
-				RETURN_UP(-EFAULT);
+				RETURN_UNLOCK(-EFAULT);
 			msg(DBG_AUD,"read_audio: copy_to_user done.\n");
 			break;
 		}
@@ -5357,15 +5358,15 @@ static int sbpcd_block_ioctl(struct inod
 		if (data_tries == 0)
 		{
 			msg(DBG_AUD,"read_audio: failed after 5 tries in line %d.\n", __LINE__);
-			RETURN_UP(-EIO);
+			RETURN_UNLOCK(-EIO);
 		}
 		msg(DBG_AUD,"read_audio: successful return.\n");
-		RETURN_UP(0);
+		RETURN_UNLOCK(0);
 	} /* end of CDROMREADAUDIO */
 
 	default:
 		msg(DBG_IOC,"ioctl: unknown function request %04X\n", cmd);
-		RETURN_UP(-EINVAL);
+		RETURN_UNLOCK(-EINVAL);
 	} /* end switch(cmd) */
 }
 
@@ -5391,7 +5392,7 @@ static int sbpcd_open(struct cdrom_devic
 {
 	struct sbpcd_drive *p = cdi->handle;
 
-	down(&ioctl_read_sem);
+	mutex_lock(&ioctl_read_mtx);
 	switch_drive(p);
 
 	/*
@@ -5419,7 +5420,7 @@ static int sbpcd_open(struct cdrom_devic
 #endif /* SAFE_MIXED */ 
 	}
 	if (!st_spinning) cc_SpinUp();
-	RETURN_UP(0);
+	RETURN_UNLOCK(0);
 }
 /*==========================================================================*/
 /*
@@ -5433,7 +5434,7 @@ static void sbpcd_release(struct cdrom_d
 		msg(DBG_INF, "release: bad device: %s\n", cdi->name);
 		return;
 	}
-	down(&ioctl_read_sem);
+	mutex_lock(&ioctl_read_mtx);
 	switch_drive(p);
 	/*
 	 * try to keep an "open" counter here and unlock the door if 1->0.
@@ -5454,7 +5455,7 @@ static void sbpcd_release(struct cdrom_d
 #endif /* SAFE_MIXED */ 
 		}
 	}
-	up(&ioctl_read_sem);
+	mutex_unlock(&ioctl_read_mtx);
 	return ;
 }
 /*==========================================================================*/
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
git-netdev-all.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
