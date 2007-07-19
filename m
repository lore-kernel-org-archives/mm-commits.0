From: akpm@linux-foundation.org
Subject: + floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:07:33 -0700
Message-ID: <200707190507.l6J57XXX014902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbXGSFHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     floppy: do a very minimal style cleanup of the floppy driver
has been added to the -mm tree.  Its filename is
     floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: floppy: do a very minimal style cleanup of the floppy driver
From: Jesper Juhl <jesper.juhl@gmail.com>

Yes, some of this will likely be replaced in later patches, but I do not see
anyone else coming out of the woodwork with any patches for this driver, so
I'll ignore comments about churn.  I want to get this driver cleaned up, and
if I'm going to do so I want to start with this basic style cleanup to reduce
the reading pain a bit.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |  129 +++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 52 deletions(-)

diff -puN drivers/block/floppy.c~floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver
+++ a/drivers/block/floppy.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 1993, 1994  Alain Knaff
  *  Copyright (C) 1998 Alan Cox
  */
+
 /*
  * 02.12.91 - Changed to static variables to indicate need for reset
  * and recalibrate. This makes some things easier (output_byte reset
@@ -149,7 +150,7 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG		/* debug disk change line */
+#define DCL_DEBUG	/* debug disk change line */
 
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
@@ -161,10 +162,8 @@ static int print_unex = 1;
 #include <linux/workqueue.h>
 #define FDPATCHES
 #include <linux/fdreg.h>
-
 #include <linux/fd.h>
 #include <linux/hdreg.h>
-
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -274,8 +273,7 @@ static inline void fallback_on_nodma_all
 		return;		/* we have the memory */
 	if (can_use_virtual_dma != 2)
 		return;		/* no fallback allowed */
-	printk
-	    ("DMA memory shortage. Temporarily falling back on virtual DMA\n");
+	printk("DMA memory shortage. Temporarily falling back on virtual DMA\n");
 	*addr = (char *)nodma_mem_alloc(l);
 #else
 	return;
@@ -291,8 +289,8 @@ static int initialising = 1;
 #define TOMINOR(x) ((x & 3) | ((x & 4) << 5))
 #define UNIT(x) ((x) & 0x03)	/* drive on fdc */
 #define FDC(x) (((x) & 0x04) >> 2)	/* fdc of drive */
+	/* reverse mapping from unit and fdc to drive */
 #define REVDRIVE(fdc, unit) ((unit) + ((fdc) << 2))
-				/* reverse mapping from unit and fdc to drive */
 #define DP (&drive_params[current_drive])
 #define DRS (&drive_state[current_drive])
 #define DRWE (&write_errors[current_drive])
@@ -356,7 +354,6 @@ static int inr;			/* size of reply buffe
 #define R_HEAD (reply_buffer[4])
 #define R_SECTOR (reply_buffer[5])
 #define R_SIZECODE (reply_buffer[6])
-
 #define SEL_DLY (2*HZ/100)
 
 /*
@@ -472,8 +469,8 @@ static struct floppy_struct floppy_type[
 	{ 6400,40,2,80,0,0x25,0x5B,0xCF,0x00,"E3200" }, /* 26 3.20MB 3.5"   */
 	{ 7040,44,2,80,0,0x25,0x5B,0xCF,0x00,"E3520" }, /* 27 3.52MB 3.5"   */
 	{ 7680,48,2,80,0,0x25,0x63,0xCF,0x00,"E3840" }, /* 28 3.84MB 3.5"   */
-
 	{ 3680,23,2,80,0,0x1C,0x10,0xCF,0x00,"H1840" }, /* 29 1.84MB 3.5"   */
+
 	{ 1600,10,2,80,0,0x25,0x02,0xDF,0x2E,"D800"  },	/* 30 800KB 3.5"    */
 	{ 3200,20,2,80,0,0x1C,0x00,0xCF,0x2C,"H1600" }, /* 31 1.6MB 3.5"    */
 };
@@ -539,12 +536,12 @@ static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
 static int *errors;
-typedef void (*done_f) (int);
+typedef void (*done_f)(int);
 static struct cont_t {
-	void (*interrupt) (void);	/* this is called after the interrupt of the
+	void (*interrupt)(void);	/* this is called after the interrupt of the
 					 * main command */
-	void (*redo) (void);	/* this is called to retry the operation */
-	void (*error) (void);	/* this is called to tally an error */
+	void (*redo)(void);	/* this is called to retry the operation */
+	void (*error)(void);	/* this is called to tally an error */
 	done_f done;		/* this is called to say if the operation has
 				 * succeeded/failed */
 } *cont;
@@ -694,7 +691,6 @@ static void reschedule_timeout(int drive
 }
 
 #define INFBOUND(a,b) (a)=max_t(int, a, b)
-
 #define SUPBOUND(a,b) (a)=min_t(int, a, b)
 
 /*
@@ -733,6 +729,7 @@ static void reschedule_timeout(int drive
 static int disk_change(int drive)
 {
 	int fdc = FDC(drive);
+
 #ifdef FLOPPY_SANITY_CHECK
 	if (time_before(jiffies, UDRS->select_date + UDP->select_delay))
 		DPRINT("WARNING disk change called early\n");
@@ -892,7 +889,6 @@ static int _lock_fdc(int drive, int inte
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&fdc_wait, &wait);
-
 		flush_scheduled_work();
 	}
 	command_status = FD_COMMAND_NONE;
@@ -968,7 +964,9 @@ static void floppy_off(unsigned int driv
  */
 static void scandrives(void)
 {
-	int i, drive, saved_drive;
+	int i;
+	int drive;
+	int saved_drive;
 
 	if (DP->select_delay)
 		return;
@@ -1146,7 +1144,9 @@ static void show_floppy(void);
 /* waits until the fdc becomes ready */
 static int wait_til_ready(void)
 {
-	int counter, status;
+	int status;
+	int counter;
+
 	if (FDCS->reset)
 		return -1;
 	for (counter = 0; counter < 10000; counter++) {
@@ -1193,7 +1193,8 @@ static int output_byte(char byte)
 /* gets the response from the fdc */
 static int result(void)
 {
-	int i, status = 0;
+	int i;
+	int status = 0;
 
 	for (i = 0; i < MAX_REPLIES; i++) {
 		if ((status = wait_til_ready()) < 0)
@@ -1226,6 +1227,7 @@ static int result(void)
 static int need_more_output(void)
 {
 	int status;
+
 	if ((status = wait_til_ready()) < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
@@ -1309,8 +1311,11 @@ static int fdc_configure(void)
  */
 static void fdc_specify(void)
 {
-	unsigned char spec1, spec2;
-	unsigned long srt, hlt, hut;
+	unsigned char spec1;
+	unsigned char spec2;
+	unsigned long srt;
+	unsigned long hlt;
+	unsigned long hut;
 	unsigned long dtr = NOMINAL_DTR;
 	unsigned long scale_dtr = NOMINAL_DTR;
 	int hlt_max_code = 0x7f;
@@ -1472,7 +1477,6 @@ static int interpret_errors(void)
 				tell_sector();
 			}
 			printk("\n");
-
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
 			/* wrong cylinder => recal */
@@ -1498,7 +1502,10 @@ static int interpret_errors(void)
  */
 static void setup_rw_floppy(void)
 {
-	int i, r, flags, dflags;
+	int i;
+	int r;
+	int flags;
+	int dflags;
 	unsigned long ready_date;
 	timeout_fn function;
 
@@ -1728,9 +1735,9 @@ static void print_result(char *message, 
 /* interrupt handler. Note that this can be called externally on the Sparc */
 irqreturn_t floppy_interrupt(int irq, void *dev_id)
 {
-	void (*handler) (void) = do_floppy;
 	int do_print;
 	unsigned long f;
+	void (*handler)(void) = do_floppy;
 
 	lasthandler = handler;
 	interruptjiffies = jiffies;
@@ -1915,9 +1922,10 @@ static void floppy_shutdown(unsigned lon
 /*typedef void (*timeout_fn)(unsigned long);*/
 
 /* start motor, check media-changed condition and write protection */
-static int start_motor(void (*function) (void))
+static int start_motor(void (*function)(void))
 {
-	int mask, data;
+	int mask;
+	int data;
 
 	mask = 0xfc;
 	data = UNIT(current_drive);
@@ -2020,17 +2028,17 @@ static struct cont_t wakeup_cont = {
 	.interrupt	= empty,
 	.redo		= do_wakeup,
 	.error		= empty,
-	.done		= (done_f) empty
+	.done		= (done_f)empty
 };
 
 static struct cont_t intr_cont = {
 	.interrupt	= empty,
 	.redo		= process_fd_request,
 	.error		= empty,
-	.done		= (done_f) empty
+	.done		= (done_f)empty
 };
 
-static int wait_til_done(void (*handler) (void), int interruptible)
+static int wait_til_done(void (*handler)(void), int interruptible)
 {
 	int ret;
 
@@ -2049,7 +2057,6 @@ static int wait_til_done(void (*handler)
 				break;
 
 			is_alive("wait_til_done");
-
 			schedule();
 		}
 
@@ -2141,6 +2148,7 @@ static void bad_flp_intr(void)
 static void set_floppy(int drive)
 {
 	int type = ITYPE(UDRS->fd_device);
+
 	if (type)
 		_floppy = floppy_type + type;
 	else
@@ -2169,11 +2177,14 @@ static void format_interrupt(void)
 #define CT(x) ((x) | 0xc0)
 static void setup_format_params(int track)
 {
+	int n;
+	int il;
+	int count;
+	int head_shift;
+	int track_shift;
 	struct fparm {
 		unsigned char track, head, sect, size;
 	} *here = (struct fparm *)floppy_track_buffer;
-	int il, n;
-	int count, head_shift, track_shift;
 
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->track = track;
@@ -2344,7 +2355,10 @@ static void request_done(int uptodate)
 /* Interrupt handler evaluating the result of the r/w operation */
 static void rw_interrupt(void)
 {
-	int nr_sectors, ssize, eoc, heads;
+	int eoc;
+	int ssize;
+	int heads;
+	int nr_sectors;
 
 	if (R_HEAD >= 2) {
 		/* some Toshiba floppy controllers occasionnally seem to
@@ -2439,7 +2453,8 @@ static int buffer_chain_size(void)
 {
 	struct bio *bio;
 	struct bio_vec *bv;
-	int size, i;
+	int size;
+	int i;
 	char *base;
 
 	base = bio_data(current_req->bio);
@@ -2480,8 +2495,10 @@ static void copy_buffer(int ssize, int m
 	int remaining;		/* number of transferred 512-byte sectors */
 	struct bio_vec *bv;
 	struct bio *bio;
-	char *buffer, *dma_buffer;
-	int size, i;
+	char *buffer;
+	char *dma_buffer;
+	int size;
+	int i;
 
 	max_sector = transfer_size(ssize,
 				   min(max_sector, max_sector_2),
@@ -2583,7 +2600,8 @@ static inline int check_dma_crossing(cha
  */
 static void virtualdmabug_workaround(void)
 {
-	int hard_sectors, end_sector;
+	int hard_sectors;
+	int end_sector;
 
 	if (CT(COMMAND) == FD_WRITE) {
 		COMMAND &= ~0x80;	/* switch off multiple track mode */
@@ -2615,7 +2633,10 @@ static void virtualdmabug_workaround(voi
 static int make_raw_rw_request(void)
 {
 	int aligned_sector_t;
-	int max_sector, max_size, tracksize, ssize;
+	int max_sector;
+	int max_size;
+	int tracksize;
+	int ssize;
 
 	if (max_buffer_sectors == 0) {
 		printk("VFS: Block I/O scheduled on unopened device\n");
@@ -2782,8 +2803,8 @@ static int make_raw_rw_request(void)
 				       indirect, direct, fsector_t);
 				return 0;
 			}
-/*			check_dma_crossing(raw_cmd->kernel_data, 
-					   raw_cmd->length, 
+/*			check_dma_crossing(raw_cmd->kernel_data,
+					   raw_cmd->length,
 					   "end of make_raw_request [1]");*/
 
 			virtualdmabug_workaround();
@@ -3016,6 +3037,7 @@ static struct cont_t poll_cont = {
 static int poll_drive(int interruptible, int flag)
 {
 	int ret;
+
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = flag;
@@ -3178,7 +3200,8 @@ static inline int raw_cmd_copyout(int cm
 
 static void raw_cmd_free(struct floppy_raw_cmd **ptr)
 {
-	struct floppy_raw_cmd *next, *this;
+	struct floppy_raw_cmd *next;
+	struct floppy_raw_cmd *this;
 
 	this = *ptr;
 	*ptr = NULL;
@@ -3250,8 +3273,10 @@ static inline int raw_cmd_copyin(int cmd
 
 static int raw_cmd_ioctl(int cmd, void __user *param)
 {
-	int drive, ret, ret2;
 	struct floppy_raw_cmd *my_raw_cmd;
+	int drive;
+	int ret2;
+	int ret;
 
 	if (FDCS->rawcmd <= 1)
 		FDCS->rawcmd = 1;
@@ -3458,7 +3483,8 @@ static int fd_ioctl(struct inode *inode,
 #define IN(c,x,tag) case c: *(x) = inparam. tag ; return 0
 
 	int drive = (long)inode->i_bdev->bd_disk->private_data;
-	int i, type = ITYPE(UDRS->fd_device);
+	int type = ITYPE(UDRS->fd_device);
+	int i;
 	int ret;
 	int size;
 	union inparam {
@@ -3624,8 +3650,7 @@ static void __init config_types(void)
 	if (!UDP->cmos && FLOPPY1_TYPE)
 		UDP->cmos = FLOPPY1_TYPE;
 
-	/* XXX */
-	/* additional physical CMOS drive detection should go here */
+	/* FIXME: additional physical CMOS drive detection should go here */
 
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		unsigned int type = UDP->cmos;
@@ -3912,13 +3937,13 @@ static int floppy_revalidate(struct gend
 }
 
 static struct block_device_operations floppy_fops = {
-	.owner		= THIS_MODULE,
-	.open		= floppy_open,
-	.release	= floppy_release,
-	.ioctl		= fd_ioctl,
-	.getgeo		= fd_getgeo,
-	.media_changed	= check_floppy_change,
-	.revalidate_disk = floppy_revalidate,
+	.owner			= THIS_MODULE,
+	.open			= floppy_open,
+	.release		= floppy_release,
+	.ioctl			= fd_ioctl,
+	.getgeo			= fd_getgeo,
+	.media_changed		= check_floppy_change,
+	.revalidate_disk	= floppy_revalidate,
 };
 
 /*
@@ -4433,8 +4458,8 @@ static int floppy_grab_irq_and_dma(void)
 		if (FDCS->address != -1)
 			fd_outb(FDCS->dor, FD_DOR);
 	/*
-	 *      The driver will try and free resources and relies on us
-	 *      to know if they were allocated or not.
+	 * The driver will try and free resources and relies on us
+	 * to know if they were allocated or not.
 	 */
 	fdc = 0;
 	irqdma_allocated = 1;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-mtd.patch
remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
