From: akpm@osdl.org
Subject: - struct-path-convert-char-drivers.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:48 -0800
Message-ID: <200612082002.kB8K2mmL002003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426249AbWLHUCy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert char-drivers
has been removed from the -mm tree.  Its filename was
     struct-path-convert-char-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert char-drivers
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/cs5535_gpio.c |    4 ++--
 drivers/char/dsp56k.c      |    6 +++---
 drivers/char/dtlk.c        |    4 ++--
 drivers/char/ip2/ip2main.c |    2 +-
 drivers/char/istallion.c   |    4 ++--
 drivers/char/lp.c          |    4 ++--
 drivers/char/mem.c         |    4 ++--
 drivers/char/nsc_gpio.c    |    4 ++--
 drivers/char/ppdev.c       |    4 ++--
 drivers/char/random.c      |    2 +-
 drivers/char/raw.c         |    2 +-
 drivers/char/sonypi.c      |    2 +-
 drivers/char/tb0219.c      |    4 ++--
 drivers/char/tipar.c       |    4 ++--
 drivers/char/tty_io.c      |   12 ++++++------
 drivers/char/vc_screen.c   |    6 +++---
 drivers/char/viotape.c     |   10 +++++-----
 drivers/char/vr41xx_giu.c  |    4 ++--
 18 files changed, 41 insertions(+), 41 deletions(-)

diff -puN drivers/char/cs5535_gpio.c~struct-path-convert-char-drivers drivers/char/cs5535_gpio.c
--- a/drivers/char/cs5535_gpio.c~struct-path-convert-char-drivers
+++ a/drivers/char/cs5535_gpio.c
@@ -82,7 +82,7 @@ static inline u32 cs5535_lowhigh_base(in
 static ssize_t cs5535_gpio_write(struct file *file, const char __user *data,
 				 size_t len, loff_t *ppos)
 {
-	u32	m = iminor(file->f_dentry->d_inode);
+	u32	m = iminor(file->f_path.dentry->d_inode);
 	int	i, j;
 	u32	base = gpio_base + cs5535_lowhigh_base(m);
 	u32	m0, m1;
@@ -117,7 +117,7 @@ static ssize_t cs5535_gpio_write(struct 
 static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
 				size_t len, loff_t *ppos)
 {
-	u32	m = iminor(file->f_dentry->d_inode);
+	u32	m = iminor(file->f_path.dentry->d_inode);
 	u32	base = gpio_base + cs5535_lowhigh_base(m);
 	int	rd_bit = 1 << (m & 0x0f);
 	int	i;
diff -puN drivers/char/dsp56k.c~struct-path-convert-char-drivers drivers/char/dsp56k.c
--- a/drivers/char/dsp56k.c~struct-path-convert-char-drivers
+++ a/drivers/char/dsp56k.c
@@ -201,7 +201,7 @@ static int dsp56k_upload(u_char __user *
 static ssize_t dsp56k_read(struct file *file, char __user *buf, size_t count,
 			   loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int dev = iminor(inode) & 0x0f;
 
 	switch(dev)
@@ -264,7 +264,7 @@ static ssize_t dsp56k_read(struct file *
 static ssize_t dsp56k_write(struct file *file, const char __user *buf, size_t count,
 			    loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int dev = iminor(inode) & 0x0f;
 
 	switch(dev)
@@ -420,7 +420,7 @@ static int dsp56k_ioctl(struct inode *in
 #if 0
 static unsigned int dsp56k_poll(struct file *file, poll_table *wait)
 {
-	int dev = iminor(file->f_dentry->d_inode) & 0x0f;
+	int dev = iminor(file->f_path.dentry->d_inode) & 0x0f;
 
 	switch(dev)
 	{
diff -puN drivers/char/dtlk.c~struct-path-convert-char-drivers drivers/char/dtlk.c
--- a/drivers/char/dtlk.c~struct-path-convert-char-drivers
+++ a/drivers/char/dtlk.c
@@ -122,7 +122,7 @@ static void dtlk_timer_tick(unsigned lon
 static ssize_t dtlk_read(struct file *file, char __user *buf,
 			 size_t count, loff_t * ppos)
 {
-	unsigned int minor = iminor(file->f_dentry->d_inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	char ch;
 	int i = 0, retries;
 
@@ -174,7 +174,7 @@ static ssize_t dtlk_write(struct file *f
 	}
 #endif
 
-	if (iminor(file->f_dentry->d_inode) != DTLK_MINOR)
+	if (iminor(file->f_path.dentry->d_inode) != DTLK_MINOR)
 		return -EINVAL;
 
 	while (1) {
diff -puN drivers/char/ip2/ip2main.c~struct-path-convert-char-drivers drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~struct-path-convert-char-drivers
+++ a/drivers/char/ip2/ip2main.c
@@ -2700,7 +2700,7 @@ static 
 ssize_t
 ip2_ipl_read(struct file *pFile, char __user *pData, size_t count, loff_t *off )
 {
-	unsigned int minor = iminor(pFile->f_dentry->d_inode);
+	unsigned int minor = iminor(pFile->f_path.dentry->d_inode);
 	int rc = 0;
 
 #ifdef IP2DEBUG_IPL
diff -puN drivers/char/istallion.c~struct-path-convert-char-drivers drivers/char/istallion.c
--- a/drivers/char/istallion.c~struct-path-convert-char-drivers
+++ a/drivers/char/istallion.c
@@ -4194,7 +4194,7 @@ static ssize_t stli_memread(struct file 
 	void *p;
 	loff_t off = *offp;
 
-	brdnr = iminor(fp->f_dentry->d_inode);
+	brdnr = iminor(fp->f_path.dentry->d_inode);
 	if (brdnr >= stli_nrbrds)
 		return -ENODEV;
 	brdp = stli_brds[brdnr];
@@ -4258,7 +4258,7 @@ static ssize_t stli_memwrite(struct file
 	void *p;
 	loff_t off = *offp;
 
-	brdnr = iminor(fp->f_dentry->d_inode);
+	brdnr = iminor(fp->f_path.dentry->d_inode);
 
 	if (brdnr >= stli_nrbrds)
 		return -ENODEV;
diff -puN drivers/char/lp.c~struct-path-convert-char-drivers drivers/char/lp.c
--- a/drivers/char/lp.c~struct-path-convert-char-drivers
+++ a/drivers/char/lp.c
@@ -296,7 +296,7 @@ static int lp_wait_ready(int minor, int 
 static ssize_t lp_write(struct file * file, const char __user * buf,
 		        size_t count, loff_t *ppos)
 {
-	unsigned int minor = iminor(file->f_dentry->d_inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct parport *port = lp_table[minor].dev->port;
 	char *kbuf = lp_table[minor].lp_buffer;
 	ssize_t retv = 0;
@@ -415,7 +415,7 @@ static ssize_t lp_read(struct file * fil
 		       size_t count, loff_t *ppos)
 {
 	DEFINE_WAIT(wait);
-	unsigned int minor=iminor(file->f_dentry->d_inode);
+	unsigned int minor=iminor(file->f_path.dentry->d_inode);
 	struct parport *port = lp_table[minor].dev->port;
 	ssize_t retval = 0;
 	char *kbuf = lp_table[minor].lp_buffer;
diff -puN drivers/char/mem.c~struct-path-convert-char-drivers drivers/char/mem.c
--- a/drivers/char/mem.c~struct-path-convert-char-drivers
+++ a/drivers/char/mem.c
@@ -774,7 +774,7 @@ static loff_t memory_lseek(struct file *
 {
 	loff_t ret;
 
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
+	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
 	switch (orig) {
 		case 0:
 			file->f_pos = offset;
@@ -789,7 +789,7 @@ static loff_t memory_lseek(struct file *
 		default:
 			ret = -EINVAL;
 	}
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 	return ret;
 }
 
diff -puN drivers/char/nsc_gpio.c~struct-path-convert-char-drivers drivers/char/nsc_gpio.c
--- a/drivers/char/nsc_gpio.c~struct-path-convert-char-drivers
+++ a/drivers/char/nsc_gpio.c
@@ -41,7 +41,7 @@ void nsc_gpio_dump(struct nsc_gpio_ops *
 ssize_t nsc_gpio_write(struct file *file, const char __user *data,
 		       size_t len, loff_t *ppos)
 {
-	unsigned m = iminor(file->f_dentry->d_inode);
+	unsigned m = iminor(file->f_path.dentry->d_inode);
 	struct nsc_gpio_ops *amp = file->private_data;
 	struct device *dev = amp->dev;
 	size_t i;
@@ -104,7 +104,7 @@ ssize_t nsc_gpio_write(struct file *file
 ssize_t nsc_gpio_read(struct file *file, char __user * buf,
 		      size_t len, loff_t * ppos)
 {
-	unsigned m = iminor(file->f_dentry->d_inode);
+	unsigned m = iminor(file->f_path.dentry->d_inode);
 	int value;
 	struct nsc_gpio_ops *amp = file->private_data;
 
diff -puN drivers/char/ppdev.c~struct-path-convert-char-drivers drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~struct-path-convert-char-drivers
+++ a/drivers/char/ppdev.c
@@ -106,7 +106,7 @@ static inline void pp_enable_irq (struct
 static ssize_t pp_read (struct file * file, char __user * buf, size_t count,
 			loff_t * ppos)
 {
-	unsigned int minor = iminor(file->f_dentry->d_inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct pp_struct *pp = file->private_data;
 	char * kbuffer;
 	ssize_t bytes_read = 0;
@@ -189,7 +189,7 @@ static ssize_t pp_read (struct file * fi
 static ssize_t pp_write (struct file * file, const char __user * buf,
 			 size_t count, loff_t * ppos)
 {
-	unsigned int minor = iminor(file->f_dentry->d_inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct pp_struct *pp = file->private_data;
 	char * kbuffer;
 	ssize_t bytes_written = 0;
diff -puN drivers/char/random.c~struct-path-convert-char-drivers drivers/char/random.c
--- a/drivers/char/random.c~struct-path-convert-char-drivers
+++ a/drivers/char/random.c
@@ -1048,7 +1048,7 @@ random_write(struct file * file, const c
 	if (p == buffer) {
 		return (ssize_t)ret;
 	} else {
-		struct inode *inode = file->f_dentry->d_inode;
+		struct inode *inode = file->f_path.dentry->d_inode;
 	        inode->i_mtime = current_fs_time(inode->i_sb);
 		mark_inode_dirty(inode);
 		return (ssize_t)(p - buffer);
diff -puN drivers/char/raw.c~struct-path-convert-char-drivers drivers/char/raw.c
--- a/drivers/char/raw.c~struct-path-convert-char-drivers
+++ a/drivers/char/raw.c
@@ -75,7 +75,7 @@ static int raw_open(struct inode *inode,
 	filp->f_flags |= O_DIRECT;
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 	if (++raw_devices[minor].inuse == 1)
-		filp->f_dentry->d_inode->i_mapping =
+		filp->f_path.dentry->d_inode->i_mapping =
 			bdev->bd_inode->i_mapping;
 	filp->private_data = bdev;
 	mutex_unlock(&raw_mutex);
diff -puN drivers/char/sonypi.c~struct-path-convert-char-drivers drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~struct-path-convert-char-drivers
+++ a/drivers/char/sonypi.c
@@ -979,7 +979,7 @@ static ssize_t sonypi_misc_read(struct f
 	}
 
 	if (ret > 0) {
-		struct inode *inode = file->f_dentry->d_inode;
+		struct inode *inode = file->f_path.dentry->d_inode;
 		inode->i_atime = current_fs_time(inode->i_sb);
 	}
 
diff -puN drivers/char/tb0219.c~struct-path-convert-char-drivers drivers/char/tb0219.c
--- a/drivers/char/tb0219.c~struct-path-convert-char-drivers
+++ a/drivers/char/tb0219.c
@@ -164,7 +164,7 @@ static ssize_t tanbac_tb0219_read(struct
 	unsigned int minor;
 	char value;
 
-	minor = iminor(file->f_dentry->d_inode);
+	minor = iminor(file->f_path.dentry->d_inode);
 	switch (minor) {
 	case 0:
 		value = get_led();
@@ -200,7 +200,7 @@ static ssize_t tanbac_tb0219_write(struc
 	int retval = 0;
 	char c;
 
-	minor = iminor(file->f_dentry->d_inode);
+	minor = iminor(file->f_path.dentry->d_inode);
 	switch (minor) {
 	case 0:
 		type = TYPE_LED;
diff -puN drivers/char/tipar.c~struct-path-convert-char-drivers drivers/char/tipar.c
--- a/drivers/char/tipar.c~struct-path-convert-char-drivers
+++ a/drivers/char/tipar.c
@@ -285,7 +285,7 @@ static ssize_t
 tipar_write (struct file *file, const char __user *buf, size_t count,
 		loff_t * ppos)
 {
-	unsigned int minor = iminor(file->f_dentry->d_inode) - TIPAR_MINOR;
+	unsigned int minor = iminor(file->f_path.dentry->d_inode) - TIPAR_MINOR;
 	ssize_t n;
 
 	parport_claim_or_block(table[minor].dev);
@@ -313,7 +313,7 @@ static ssize_t
 tipar_read(struct file *file, char __user *buf, size_t count, loff_t * ppos)
 {
 	int b = 0;
-	unsigned int minor = iminor(file->f_dentry->d_inode) - TIPAR_MINOR;
+	unsigned int minor = iminor(file->f_path.dentry->d_inode) - TIPAR_MINOR;
 	ssize_t retval = 0;
 	ssize_t n = 0;
 
diff -puN drivers/char/tty_io.c~struct-path-convert-char-drivers drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~struct-path-convert-char-drivers
+++ a/drivers/char/tty_io.c
@@ -1629,7 +1629,7 @@ static ssize_t tty_read(struct file * fi
 	struct tty_ldisc *ld;
 
 	tty = (struct tty_struct *)file->private_data;
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	if (tty_paranoia_check(tty, inode, "tty_read"))
 		return -EIO;
 	if (!tty || (test_bit(TTY_IO_ERROR, &tty->flags)))
@@ -1732,7 +1732,7 @@ static inline ssize_t do_tty_write(
 		cond_resched();
 	}
 	if (written) {
-		struct inode *inode = file->f_dentry->d_inode;
+		struct inode *inode = file->f_path.dentry->d_inode;
 		inode->i_mtime = current_fs_time(inode->i_sb);
 		ret = written;
 	}
@@ -1763,7 +1763,7 @@ static ssize_t tty_write(struct file * f
 			 loff_t *ppos)
 {
 	struct tty_struct * tty;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	ssize_t ret;
 	struct tty_ldisc *ld;
 	
@@ -2170,7 +2170,7 @@ static void release_dev(struct file * fi
 	unsigned long flags;
 	
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, filp->f_dentry->d_inode, "release_dev"))
+	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "release_dev"))
 		return;
 
 	check_tty_count(tty, "release_dev");
@@ -2680,7 +2680,7 @@ static unsigned int tty_poll(struct file
 	int ret = 0;
 
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, filp->f_dentry->d_inode, "tty_poll"))
+	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_poll"))
 		return 0;
 		
 	ld = tty_ldisc_ref_wait(tty);
@@ -2696,7 +2696,7 @@ static int tty_fasync(int fd, struct fil
 	int retval;
 
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, filp->f_dentry->d_inode, "tty_fasync"))
+	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		return 0;
 	
 	retval = fasync_helper(fd, filp, on, &tty->fasync);
diff -puN drivers/char/vc_screen.c~struct-path-convert-char-drivers drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~struct-path-convert-char-drivers
+++ a/drivers/char/vc_screen.c
@@ -72,7 +72,7 @@ static loff_t vcs_lseek(struct file *fil
 	int size;
 
 	down(&con_buf_sem);
-	size = vcs_size(file->f_dentry->d_inode);
+	size = vcs_size(file->f_path.dentry->d_inode);
 	switch (orig) {
 		default:
 			up(&con_buf_sem);
@@ -98,7 +98,7 @@ static loff_t vcs_lseek(struct file *fil
 static ssize_t
 vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int currcons = iminor(inode);
 	struct vc_data *vc;
 	long pos;
@@ -271,7 +271,7 @@ unlock_out:
 static ssize_t
 vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int currcons = iminor(inode);
 	struct vc_data *vc;
 	long pos;
diff -puN drivers/char/viotape.c~struct-path-convert-char-drivers drivers/char/viotape.c
--- a/drivers/char/viotape.c~struct-path-convert-char-drivers
+++ a/drivers/char/viotape.c
@@ -442,7 +442,7 @@ static ssize_t viotap_write(struct file 
 	if (op == NULL)
 		return -ENOMEM;
 
-	get_dev_info(file->f_dentry->d_inode, &devi);
+	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
 	/*
 	 * We need to make sure we can send a request.  We use
@@ -532,7 +532,7 @@ static ssize_t viotap_read(struct file *
 	if (op == NULL)
 		return -ENOMEM;
 
-	get_dev_info(file->f_dentry->d_inode, &devi);
+	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
 	/*
 	 * We need to make sure we can send a request.  We use
@@ -612,7 +612,7 @@ static int viotap_ioctl(struct inode *in
 	if (op == NULL)
 		return -ENOMEM;
 
-	get_dev_info(file->f_dentry->d_inode, &devi);
+	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
 	down(&reqSem);
 
@@ -777,7 +777,7 @@ static int viotap_open(struct inode *ino
 	if (op == NULL)
 		return -ENOMEM;
 
-	get_dev_info(file->f_dentry->d_inode, &devi);
+	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
 	/* Note: We currently only support one mode! */
 	if ((devi.devno >= viotape_numdev) || (devi.mode)) {
@@ -822,7 +822,7 @@ static int viotap_release(struct inode *
 		return -ENOMEM;
 	init_completion(&op->com);
 
-	get_dev_info(file->f_dentry->d_inode, &devi);
+	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
 	if (devi.devno >= viotape_numdev) {
 		ret = -ENODEV;
diff -puN drivers/char/vr41xx_giu.c~struct-path-convert-char-drivers drivers/char/vr41xx_giu.c
--- a/drivers/char/vr41xx_giu.c~struct-path-convert-char-drivers
+++ a/drivers/char/vr41xx_giu.c
@@ -506,7 +506,7 @@ static ssize_t gpio_read(struct file *fi
 	unsigned int pin;
 	char value = '0';
 
-	pin = iminor(file->f_dentry->d_inode);
+	pin = iminor(file->f_path.dentry->d_inode);
 	if (pin >= giu_nr_pins)
 		return -EBADF;
 
@@ -530,7 +530,7 @@ static ssize_t gpio_write(struct file *f
 	char c;
 	int retval = 0;
 
-	pin = iminor(file->f_dentry->d_inode);
+	pin = iminor(file->f_path.dentry->d_inode);
 	if (pin >= giu_nr_pins)
 		return -EBADF;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-char-drivers.patch
struct-path-convert-coda.patch
struct-path-convert-cosa.patch
struct-path-convert-cramfs.patch
struct-path-convert-cris.patch
struct-path-convert-drm.patch
struct-path-convert-efs.patch
struct-path-convert-freevxfs.patch
struct-path-convert-frv.patch
struct-path-convert-fuse.patch
struct-path-convert-gfs2.patch
struct-path-convert-hfs.patch
struct-path-convert-hfsplus.patch
struct-path-convert-hostfs.patch
struct-path-convert-hpfs.patch
struct-path-convert-hppfs.patch
struct-path-convert-hugetlbfs.patch
struct-path-convert-i2c-drivers.patch
struct-path-convert-ia64.patch
struct-path-convert-ieee1394.patch
struct-path-convert-infiniband.patch
struct-path-convert-ipc.patch
struct-path-convert-ipmi.patch
struct-path-convert-isapnp.patch
struct-path-convert-isdn.patch
struct-path-convert-ixj.patch
struct-path-convert-jffs.patch
struct-path-convert-jffs2.patch
struct-path-convert-jfs.patch
struct-path-convert-kernel.patch
struct-path-convert-lockd.patch
struct-path-convert-md.patch
struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
struct-path-convert-ncpfs.patch
struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
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

