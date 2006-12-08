From: akpm@osdl.org
Subject: - struct-path-convert-sound.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:06 -0800
Message-ID: <200612082005.kB8K562M002262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426315AbWLHUFL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sound
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sound
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/core/info.c                  |    2 +-
 sound/core/pcm_native.c            |    2 +-
 sound/oss/dmasound/dmasound_core.c |    4 ++--
 sound/oss/msnd_pinnacle.c          |    4 ++--
 sound/oss/soundcard.c              |    8 ++++----
 sound/sound_firmware.c             |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff -puN sound/core/info.c~struct-path-convert-sound sound/core/info.c
--- a/sound/core/info.c~struct-path-convert-sound
+++ a/sound/core/info.c
@@ -488,7 +488,7 @@ static long snd_info_entry_ioctl(struct 
 
 static int snd_info_entry_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct snd_info_private_data *data;
 	struct snd_info_entry *entry;
 
diff -puN sound/core/pcm_native.c~struct-path-convert-sound sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~struct-path-convert-sound
+++ a/sound/core/pcm_native.c
@@ -1604,7 +1604,7 @@ static struct file *snd_pcm_file_fd(int 
 	file = fget(fd);
 	if (!file)
 		return NULL;
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	if (!S_ISCHR(inode->i_mode) ||
 	    imajor(inode) != snd_major) {
 		fput(file);
diff -puN sound/oss/dmasound/dmasound_core.c~struct-path-convert-sound sound/oss/dmasound/dmasound_core.c
--- a/sound/oss/dmasound/dmasound_core.c~struct-path-convert-sound
+++ a/sound/oss/dmasound/dmasound_core.c
@@ -1051,7 +1051,7 @@ static int sq_release(struct inode *inod
 
 	if (file->f_mode & FMODE_WRITE) {
 		if (write_sq.busy)
-			rc = sq_fsync(file, file->f_dentry);
+			rc = sq_fsync(file, file->f_path.dentry);
 
 		sq_reset_output() ; /* make sure dma is stopped and all is quiet */
 		write_sq_release_buffers();
@@ -1217,7 +1217,7 @@ static int sq_ioctl(struct inode *inode,
 		if ((file->f_mode & FMODE_READ) && dmasound.mach.record)
 			sq_reset_input() ;
 		if (file->f_mode & FMODE_WRITE) {
-			result = sq_fsync(file, file->f_dentry);
+			result = sq_fsync(file, file->f_path.dentry);
 			sq_reset_output() ;
 		}
 		/* if we are the shared resource owner then release them */
diff -puN sound/oss/msnd_pinnacle.c~struct-path-convert-sound sound/oss/msnd_pinnacle.c
--- a/sound/oss/msnd_pinnacle.c~struct-path-convert-sound
+++ a/sound/oss/msnd_pinnacle.c
@@ -1007,7 +1007,7 @@ static int dsp_write(const char __user *
 
 static ssize_t dev_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 {
-	int minor = iminor(file->f_dentry->d_inode);
+	int minor = iminor(file->f_path.dentry->d_inode);
 	if (minor == dev.dsp_minor)
 		return dsp_read(buf, count);
 	else
@@ -1016,7 +1016,7 @@ static ssize_t dev_read(struct file *fil
 
 static ssize_t dev_write(struct file *file, const char __user *buf, size_t count, loff_t *off)
 {
-	int minor = iminor(file->f_dentry->d_inode);
+	int minor = iminor(file->f_path.dentry->d_inode);
 	if (minor == dev.dsp_minor)
 		return dsp_write(buf, count);
 	else
diff -puN sound/oss/soundcard.c~struct-path-convert-sound sound/oss/soundcard.c
--- a/sound/oss/soundcard.c~struct-path-convert-sound
+++ a/sound/oss/soundcard.c
@@ -141,7 +141,7 @@ static int get_mixer_levels(void __user 
 
 static ssize_t sound_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	int dev = iminor(file->f_dentry->d_inode);
+	int dev = iminor(file->f_path.dentry->d_inode);
 	int ret = -EINVAL;
 
 	/*
@@ -174,7 +174,7 @@ static ssize_t sound_read(struct file *f
 
 static ssize_t sound_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	int dev = iminor(file->f_dentry->d_inode);
+	int dev = iminor(file->f_path.dentry->d_inode);
 	int ret = -EINVAL;
 	
 	lock_kernel();
@@ -393,7 +393,7 @@ static int sound_ioctl(struct inode *ino
 
 static unsigned int sound_poll(struct file *file, poll_table * wait)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int dev = iminor(inode);
 
 	DEB(printk("sound_poll(dev=%d)\n", dev));
@@ -418,7 +418,7 @@ static int sound_mmap(struct file *file,
 	int dev_class;
 	unsigned long size;
 	struct dma_buffparms *dmap = NULL;
-	int dev = iminor(file->f_dentry->d_inode);
+	int dev = iminor(file->f_path.dentry->d_inode);
 
 	dev_class = dev & 0x0f;
 	dev >>= 4;
diff -puN sound/sound_firmware.c~struct-path-convert-sound sound/sound_firmware.c
--- a/sound/sound_firmware.c~struct-path-convert-sound
+++ a/sound/sound_firmware.c
@@ -19,7 +19,7 @@ static int do_mod_firmware_load(const ch
 		printk(KERN_INFO "Unable to load '%s'.\n", fn);
 		return 0;
 	}
-	l = filp->f_dentry->d_inode->i_size;
+	l = filp->f_path.dentry->d_inode->i_size;
 	if (l <= 0 || l > 131072)
 	{
 		printk(KERN_INFO "Invalid firmware '%s'\n", fn);
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

