From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-define-space-and-column-neatening.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:20 -0800
Message-ID: <201001270037.o0R0bKZG032508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab0A0Ah5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: #define space and column neatening
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-define-space-and-column-neatening.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: #define space and column neatening
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |  182 +++++++++++++++++++++------------------
 1 file changed, 98 insertions(+), 84 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-define-space-and-column-neatening drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-define-space-and-column-neatening
+++ a/drivers/block/floppy.c
@@ -150,7 +150,7 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG	/* debug disk change line */
+#define DCL_DEBUG		/* debug disk change line */
 
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
@@ -250,7 +250,7 @@ static int irqdma_allocated;
 
 static struct request *current_req;
 static struct request_queue *floppy_queue;
-static void do_fd_request(struct request_queue * q);
+static void do_fd_request(struct request_queue *q);
 
 #ifndef fd_get_dma_residue
 #define fd_get_dma_residue() get_dma_residue(FLOPPY_DMA)
@@ -263,7 +263,7 @@ static void do_fd_request(struct request
 #endif
 
 #ifndef fd_dma_mem_alloc
-#define fd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL,get_order(size))
+#define fd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL, get_order(size))
 #endif
 
 static inline void fallback_on_nodma_alloc(char **addr, size_t l)
@@ -285,57 +285,59 @@ static inline void fallback_on_nodma_all
 static unsigned long fake_change;
 static int initialising = 1;
 
-#define ITYPE(x) (((x)>>2) & 0x1f)
-#define TOMINOR(x) ((x & 3) | ((x & 4) << 5))
-#define UNIT(x) ((x) & 0x03)	/* drive on fdc */
-#define FDC(x) (((x) & 0x04) >> 2)	/* fdc of drive */
+#define ITYPE(x)	(((x) >> 2) & 0x1f)
+#define TOMINOR(x)	((x & 3) | ((x & 4) << 5))
+#define UNIT(x)		((x) & 0x03)		/* drive on fdc */
+#define FDC(x)		(((x) & 0x04) >> 2)	/* fdc of drive */
 	/* reverse mapping from unit and fdc to drive */
 #define REVDRIVE(fdc, unit) ((unit) + ((fdc) << 2))
-#define DP (&drive_params[current_drive])
-#define DRS (&drive_state[current_drive])
-#define DRWE (&write_errors[current_drive])
-#define FDCS (&fdc_state[fdc])
-#define CLEARF(x) clear_bit(x##_BIT, &DRS->flags)
-#define SETF(x) set_bit(x##_BIT, &DRS->flags)
-#define TESTF(x) test_bit(x##_BIT, &DRS->flags)
-
-#define UDP (&drive_params[drive])
-#define UDRS (&drive_state[drive])
-#define UDRWE (&write_errors[drive])
-#define UFDCS (&fdc_state[FDC(drive)])
-#define UCLEARF(x) clear_bit(x##_BIT, &UDRS->flags)
-#define USETF(x) set_bit(x##_BIT, &UDRS->flags)
-#define UTESTF(x) test_bit(x##_BIT, &UDRS->flags)
 
-#define DPRINT(format, args...) printk(DEVICE_NAME "%d: " format, current_drive , ## args)
+#define DP	(&drive_params[current_drive])
+#define DRS	(&drive_state[current_drive])
+#define DRWE	(&write_errors[current_drive])
+#define FDCS	(&fdc_state[fdc])
+#define CLEARF(x)	clear_bit(x##_BIT, &DRS->flags)
+#define SETF(x)		set_bit(x##_BIT, &DRS->flags)
+#define TESTF(x)	test_bit(x##_BIT, &DRS->flags)
+
+#define UDP	(&drive_params[drive])
+#define UDRS	(&drive_state[drive])
+#define UDRWE	(&write_errors[drive])
+#define UFDCS	(&fdc_state[FDC(drive)])
+#define UCLEARF(x)	clear_bit(x##_BIT, &UDRS->flags)
+#define USETF(x)	set_bit(x##_BIT, &UDRS->flags)
+#define UTESTF(x)	test_bit(x##_BIT, &UDRS->flags)
 
-#define PH_HEAD(floppy,head) (((((floppy)->stretch & 2) >>1) ^ head) << 2)
-#define STRETCH(floppy) ((floppy)->stretch & FD_STRETCH)
+#define DPRINT(format, args...) \
+	printk(DEVICE_NAME "%d: " format, current_drive, ##args)
 
-#define CLEARSTRUCT(x) memset((x), 0, sizeof(*(x)))
+#define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
+#define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
+
+#define CLEARSTRUCT(x)	memset((x), 0, sizeof(*(x)))
 
 /* read/write */
-#define COMMAND raw_cmd->cmd[0]
-#define DR_SELECT raw_cmd->cmd[1]
-#define TRACK raw_cmd->cmd[2]
-#define HEAD raw_cmd->cmd[3]
-#define SECTOR raw_cmd->cmd[4]
-#define SIZECODE raw_cmd->cmd[5]
-#define SECT_PER_TRACK raw_cmd->cmd[6]
-#define GAP raw_cmd->cmd[7]
-#define SIZECODE2 raw_cmd->cmd[8]
+#define COMMAND		(raw_cmd->cmd[0])
+#define DR_SELECT	(raw_cmd->cmd[1])
+#define TRACK		(raw_cmd->cmd[2])
+#define HEAD		(raw_cmd->cmd[3])
+#define SECTOR		(raw_cmd->cmd[4])
+#define SIZECODE	(raw_cmd->cmd[5])
+#define SECT_PER_TRACK	(raw_cmd->cmd[6])
+#define GAP		(raw_cmd->cmd[7])
+#define SIZECODE2	(raw_cmd->cmd[8])
 #define NR_RW 9
 
 /* format */
-#define F_SIZECODE raw_cmd->cmd[2]
-#define F_SECT_PER_TRACK raw_cmd->cmd[3]
-#define F_GAP raw_cmd->cmd[4]
-#define F_FILL raw_cmd->cmd[5]
+#define F_SIZECODE	(raw_cmd->cmd[2])
+#define F_SECT_PER_TRACK (raw_cmd->cmd[3])
+#define F_GAP		(raw_cmd->cmd[4])
+#define F_FILL		(raw_cmd->cmd[5])
 #define NR_F 6
 
 /*
- * Maximum disk size (in kilobytes). This default is used whenever the
- * current disk size is unknown.
+ * Maximum disk size (in kilobytes).
+ * This default is used whenever the current disk size is unknown.
  * [Now it is rather a minimum]
  */
 #define MAX_DISK_SIZE 4		/* 3984 */
@@ -346,15 +348,16 @@ static int initialising = 1;
 #define MAX_REPLIES 16
 static unsigned char reply_buffer[MAX_REPLIES];
 static int inr;			/* size of reply buffer, when called from interrupt */
-#define ST0 (reply_buffer[0])
-#define ST1 (reply_buffer[1])
-#define ST2 (reply_buffer[2])
-#define ST3 (reply_buffer[0])	/* result of GETSTATUS */
-#define R_TRACK (reply_buffer[3])
-#define R_HEAD (reply_buffer[4])
-#define R_SECTOR (reply_buffer[5])
-#define R_SIZECODE (reply_buffer[6])
-#define SEL_DLY (2*HZ/100)
+#define ST0		(reply_buffer[0])
+#define ST1		(reply_buffer[1])
+#define ST2		(reply_buffer[2])
+#define ST3		(reply_buffer[0])	/* result of GETSTATUS */
+#define R_TRACK		(reply_buffer[3])
+#define R_HEAD		(reply_buffer[4])
+#define R_SECTOR	(reply_buffer[5])
+#define R_SIZECODE	(reply_buffer[6])
+
+#define SEL_DLY		(2 * HZ / 100)
 
 /*
  * this struct defines the different floppy drive types.
@@ -505,9 +508,9 @@ static char floppy_device_name[] = "flop
 static int probing;
 
 /* Synchronization of FDC access. */
-#define FD_COMMAND_NONE -1
-#define FD_COMMAND_ERROR 2
-#define FD_COMMAND_OKAY 3
+#define FD_COMMAND_NONE		-1
+#define FD_COMMAND_ERROR	2
+#define FD_COMMAND_OKAY		3
 
 static volatile int command_status = FD_COMMAND_NONE;
 static unsigned long fdc_busy;
@@ -515,11 +518,11 @@ static DECLARE_WAIT_QUEUE_HEAD(fdc_wait)
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
-#define CALL(x) if ((x) == -EINTR) return -EINTR
-#define ECALL(x) if ((ret = (x))) return ret;
-#define _WAIT(x,i) CALL(ret=wait_til_done((x),i))
-#define WAIT(x) _WAIT((x),interruptible)
-#define IWAIT(x) _WAIT((x),1)
+#define CALL(x)		if ((x) == -EINTR) return -EINTR
+#define ECALL(x)	if ((ret = (x))) return ret;
+#define _WAIT(x,i)	CALL(ret=wait_til_done((x),i))
+#define WAIT(x)		_WAIT((x),interruptible)
+#define IWAIT(x)	_WAIT((x),1)
 
 /* Errors during formatting are counted here. */
 static int format_errors;
@@ -545,8 +548,9 @@ static int max_buffer_sectors;
 static int *errors;
 typedef void (*done_f)(int);
 static struct cont_t {
-	void (*interrupt)(void);	/* this is called after the interrupt of the
-					 * main command */
+	void (*interrupt)(void);
+				/* this is called after the interrupt of the
+				 * main command */
 	void (*redo)(void);	/* this is called to retry the operation */
 	void (*error)(void);	/* this is called to tally an error */
 	done_f done;		/* this is called to say if the operation has
@@ -579,9 +583,9 @@ static void reset_fdc(void);
  * information to interrupts. They are the data used for the current
  * request.
  */
-#define NO_TRACK -1
-#define NEED_1_RECAL -2
-#define NEED_2_RECAL -3
+#define NO_TRACK	-1
+#define NEED_1_RECAL	-2
+#define NEED_2_RECAL	-3
 
 static int usage_count;
 
@@ -647,13 +651,13 @@ static void is_alive(const char *message
 }
 #endif
 
-static void (*do_floppy) (void) = NULL;
+static void (*do_floppy)(void) = NULL;
 
 #ifdef FLOPPY_SANITY_CHECK
 
 #define OLOGSIZE 20
 
-static void (*lasthandler) (void);
+static void (*lasthandler)(void);
 static unsigned long interruptjiffies;
 static unsigned long resultjiffies;
 static int resultsize;
@@ -699,8 +703,8 @@ static void reschedule_timeout(int drive
 	spin_unlock_irqrestore(&floppy_lock, flags);
 }
 
-#define INFBOUND(a,b) (a)=max_t(int, a, b)
-#define SUPBOUND(a,b) (a)=min_t(int, a, b)
+#define INFBOUND(a, b) (a) = max_t(int, a, b)
+#define SUPBOUND(a, b) (a) = min_t(int, a, b)
 
 /*
  * Bottom half floppy driver.
@@ -909,10 +913,12 @@ static int _lock_fdc(int drive, int inte
 	return 0;
 }
 
-#define lock_fdc(drive,interruptible) _lock_fdc(drive,interruptible, __LINE__)
+#define lock_fdc(drive, interruptible)			\
+	_lock_fdc(drive, interruptible, __LINE__)
 
-#define LOCK_FDC(drive,interruptible) \
-if (lock_fdc(drive,interruptible)) return -EINTR;
+#define LOCK_FDC(drive, interruptible)	    \
+	if (lock_fdc(drive, interruptible)) \
+		return -EINTR;
 
 /* unlocks the driver */
 static inline void unlock_fdc(void)
@@ -1003,7 +1009,7 @@ static void empty(void)
 
 static DECLARE_WORK(floppy_work, NULL);
 
-static void schedule_bh(void (*handler) (void))
+static void schedule_bh(void (*handler)(void))
 {
 	PREPARE_WORK(&floppy_work, (work_func_t)handler);
 	schedule_work(&floppy_work);
@@ -2181,8 +2187,9 @@ static void format_interrupt(void)
 }
 
 #define CODE2SIZE (ssize = ((1 << SIZECODE) + 3) >> 2)
-#define FM_MODE(x,y) ((y) & ~(((x)->rate & 0x80) >>1))
+#define FM_MODE(x, y) ((y) & ~(((x)->rate & 0x80) >> 1))
 #define CT(x) ((x) | 0xc0)
+
 static void setup_format_params(int track)
 {
 	int n;
@@ -2197,8 +2204,8 @@ static void setup_format_params(int trac
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->track = track;
 
-	raw_cmd->flags = FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_SPIN |
-	    FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
+	raw_cmd->flags = (FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_SPIN |
+			  FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK);
 	raw_cmd->rate = _floppy->rate & 0x43;
 	raw_cmd->cmd_count = NR_F;
 	COMMAND = FM_MODE(_floppy, FD_FORMAT);
@@ -2600,8 +2607,9 @@ static void virtualdmabug_workaround(voi
 			return;
 		}
 #endif
-		SECT_PER_TRACK = end_sector;	/* make sure SECT_PER_TRACK points
-						 * to end of transfer */
+		SECT_PER_TRACK = end_sector;
+					/* make sure SECT_PER_TRACK
+					 * points to end of transfer */
 	}
 }
 
@@ -3075,16 +3083,19 @@ static inline int fd_copyout(void __user
 	return copy_to_user(param, address, size) ? -EFAULT : 0;
 }
 
-static inline int fd_copyin(void __user *param, void *address, unsigned long size)
+static inline int fd_copyin(void __user *param, void *address,
+			    unsigned long size)
 {
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-#define _COPYOUT(x) (copy_to_user((void __user *)param, &(x), sizeof(x)) ? -EFAULT : 0)
-#define _COPYIN(x) (copy_from_user(&(x), (void __user *)param, sizeof(x)) ? -EFAULT : 0)
+#define _COPYOUT(x)	(copy_to_user((void __user *)param, &(x), sizeof(x)) \
+			 ? -EFAULT : 0)
+#define _COPYIN(x)	(copy_from_user(&(x), (void __user *)param, sizeof(x)) \
+			 ? -EFAULT : 0)
 
-#define COPYOUT(x) ECALL(_COPYOUT(x))
-#define COPYIN(x) ECALL(_COPYIN(x))
+#define COPYOUT(x)	ECALL(_COPYOUT(x))
+#define COPYIN(x)	ECALL(_COPYIN(x))
 
 static inline const char *drive_name(int type, int drive)
 {
@@ -4148,7 +4159,8 @@ static ssize_t floppy_cmos_show(struct d
 	drive = p->id;
 	return sprintf(buf, "%X\n", UDP->cmos);
 }
-DEVICE_ATTR(cmos,S_IRUGO,floppy_cmos_show,NULL);
+
+DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
 
 static void floppy_device_release(struct device *dev)
 {
@@ -4625,6 +4637,7 @@ static void __exit floppy_module_exit(vo
 	/* eject disk, if any */
 	fd_eject(0);
 }
+
 module_exit(floppy_module_exit);
 
 module_param(floppy, charp, 0);
@@ -4636,9 +4649,10 @@ MODULE_LICENSE("GPL");
 
 /* This doesn't actually get used other than for module information */
 static const struct pnp_device_id floppy_pnpids[] = {
-	{ "PNP0700", 0 },
-	{ }
+	{"PNP0700", 0},
+	{}
 };
+
 MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
 
 #else
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

