From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-use-pr_level.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:09 -0400
Message-ID: <201003150653.o2F6rgSc016010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363Ab0COGxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: use pr_<level>
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-use-pr_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: use pr_<level>
From: Joe Perches <joe@perches.com>

Convert bare printk to pr_info and pr_cont
Convert printk(KERN_ERR to pr_err

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |  353 +++++++++++++++++++--------------------
 1 file changed, 175 insertions(+), 178 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-use-pr_level drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-use-pr_level
+++ a/drivers/block/floppy.c
@@ -273,7 +273,7 @@ static inline void fallback_on_nodma_all
 		return;		/* we have the memory */
 	if (can_use_virtual_dma != 2)
 		return;		/* no fallback allowed */
-	printk("DMA memory shortage. Temporarily falling back on virtual DMA\n");
+	pr_info("DMA memory shortage. Temporarily falling back on virtual DMA\n");
 	*addr = (char *)nodma_mem_alloc(l);
 #else
 	return;
@@ -309,7 +309,7 @@ static int initialising = 1;
 #define UTESTF(x)	test_bit(x##_BIT, &UDRS->flags)
 
 #define DPRINT(format, args...) \
-	printk(DEVICE_NAME "%d: " format, current_drive, ##args)
+	pr_info(DEVICE_NAME "%d: " format, current_drive, ##args)
 
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
@@ -628,7 +628,7 @@ static inline void set_debugt(void)
 static inline void debugt(const char *message)
 {
 	if (DP->flags & DEBUGT)
-		printk("%s dtime=%lu\n", message, jiffies - debugtimer);
+		pr_info("%s dtime=%lu\n", message, jiffies - debugtimer);
 }
 #else
 static inline void set_debugt(void) { }
@@ -687,9 +687,7 @@ static void __reschedule_timeout(int dri
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
 	if (UDP->flags & FD_DEBUG) {
-		DPRINT("reschedule timeout ");
-		printk(message, marg);
-		printk("\n");
+		DPRINT("reschedule timeout %s %d\n", message, marg);
 	}
 	timeout_message = message;
 }
@@ -861,7 +859,7 @@ static void set_fdc(int drive)
 		current_drive = drive;
 	}
 	if (fdc != 1 && fdc != 0) {
-		printk("bad fdc value\n");
+		pr_info("bad fdc value\n");
 		return;
 	}
 	set_dor(fdc, ~0, 8);
@@ -878,8 +876,7 @@ static void set_fdc(int drive)
 static int _lock_fdc(int drive, int interruptible, int line)
 {
 	if (!usage_count) {
-		printk(KERN_ERR
-		       "Trying to lock fdc while usage count=0 at line %d\n",
+		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
 		       line);
 		return -1;
 	}
@@ -1115,16 +1112,16 @@ static void setup_DMA(void)
 	if (raw_cmd->length == 0) {
 		int i;
 
-		printk("zero dma transfer size:");
+		pr_info("zero dma transfer size:");
 		for (i = 0; i < raw_cmd->cmd_count; i++)
-			printk("%x,", raw_cmd->cmd[i]);
-		printk("\n");
+			pr_cont("%x,", raw_cmd->cmd[i]);
+		pr_cont("\n");
 		cont->done(0);
 		FDCS->reset = 1;
 		return;
 	}
 	if (((unsigned long)raw_cmd->kernel_data) % 512) {
-		printk("non aligned address: %p\n", raw_cmd->kernel_data);
+		pr_info("non aligned address: %p\n", raw_cmd->kernel_data);
 		cont->done(0);
 		FDCS->reset = 1;
 		return;
@@ -1427,10 +1424,40 @@ static int fdc_dtr(void)
 
 static void tell_sector(void)
 {
-	printk(": track %d, head %d, sector %d, size %d",
-	       R_TRACK, R_HEAD, R_SECTOR, R_SIZECODE);
+	pr_cont(": track %d, head %d, sector %d, size %d",
+		R_TRACK, R_HEAD, R_SECTOR, R_SIZECODE);
 }				/* tell_sector */
 
+static void print_errors(void)
+{
+	DPRINT("");
+	if (ST0 & ST0_ECE) {
+		pr_cont("Recalibrate failed!");
+	} else if (ST2 & ST2_CRC) {
+		pr_cont("data CRC error");
+		tell_sector();
+	} else if (ST1 & ST1_CRC) {
+		pr_cont("CRC error");
+		tell_sector();
+	} else if ((ST1 & (ST1_MAM | ST1_ND)) ||
+		   (ST2 & ST2_MAM)) {
+		if (!probing) {
+			pr_cont("sector not found");
+			tell_sector();
+		} else
+			pr_cont("probe failed...");
+	} else if (ST2 & ST2_WC) {	/* seek error */
+		pr_cont("wrong cylinder");
+	} else if (ST2 & ST2_BC) {	/* cylinder marked as bad */
+		pr_cont("bad cylinder");
+	} else {
+		pr_cont("unknown error. ST[0..2] are: 0x%x 0x%x 0x%x",
+			ST0, ST1, ST2);
+		tell_sector();
+	}
+	pr_cont("\n");
+}
+
 /*
  * OK, this error interpreting routine is called after a
  * DMA read/write has succeeded
@@ -1466,33 +1493,7 @@ static int interpret_errors(void)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
 		} else if (*errors >= DP->max_errors.reporting) {
-			DPRINT("");
-			if (ST0 & ST0_ECE) {
-				printk("Recalibrate failed!");
-			} else if (ST2 & ST2_CRC) {
-				printk("data CRC error");
-				tell_sector();
-			} else if (ST1 & ST1_CRC) {
-				printk("CRC error");
-				tell_sector();
-			} else if ((ST1 & (ST1_MAM | ST1_ND))
-				   || (ST2 & ST2_MAM)) {
-				if (!probing) {
-					printk("sector not found");
-					tell_sector();
-				} else
-					printk("probe failed...");
-			} else if (ST2 & ST2_WC) {	/* seek error */
-				printk("wrong cylinder");
-			} else if (ST2 & ST2_BC) {	/* cylinder marked as bad */
-				printk("bad cylinder");
-			} else {
-				printk
-				    ("unknown error. ST[0..2] are: 0x%x 0x%x 0x%x",
-				     ST0, ST1, ST2);
-				tell_sector();
-			}
-			printk("\n");
+			print_errors();
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
 			/* wrong cylinder => recal */
@@ -1591,8 +1592,7 @@ static void seek_interrupt(void)
 	if (DRS->track >= 0 && DRS->track != ST1 && !blind_seek) {
 #ifdef DCL_DEBUG
 		if (DP->flags & FD_DEBUG) {
-			DPRINT
-			    ("clearing NEWCHANGE flag because of effective seek\n");
+			DPRINT("clearing NEWCHANGE flag because of effective seek\n");
 			DPRINT("jiffies=%lu\n", jiffies);
 		}
 #endif
@@ -1712,10 +1712,8 @@ static void recal_interrupt(void)
 			 * be already at track 0.) Clear the
 			 * new change flag */
 #ifdef DCL_DEBUG
-			if (DP->flags & FD_DEBUG) {
-				DPRINT
-				    ("clearing NEWCHANGE flag because of second recalibrate\n");
-			}
+			if (DP->flags & FD_DEBUG)
+				DPRINT("clearing NEWCHANGE flag because of second recalibrate\n");
 #endif
 
 			CLEARF(FD_DISK_NEWCHANGE);
@@ -1744,8 +1742,8 @@ static void print_result(char *message, 
 	DPRINT("%s ", message);
 	if (inr >= 0)
 		for (i = 0; i < inr; i++)
-			printk("repl[%d]=%x ", i, reply_buffer[i]);
-	printk("\n");
+			pr_cont("repl[%d]=%x ", i, reply_buffer[i]);
+	pr_cont("\n");
 }
 
 /* interrupt handler. Note that this can be called externally on the Sparc */
@@ -1766,9 +1764,9 @@ irqreturn_t floppy_interrupt(int irq, vo
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
-		printk("DOR0=%x\n", fdc_state[0].dor);
-		printk("floppy interrupt on bizarre fdc %d\n", fdc);
-		printk("handler=%p\n", handler);
+		pr_info("DOR0=%x\n", fdc_state[0].dor);
+		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
+		pr_info("handler=%p\n", handler);
 		is_alive("bizarre fdc");
 		return IRQ_NONE;
 	}
@@ -1826,7 +1824,7 @@ static void reset_interrupt(void)
 	debugt("reset interrupt:");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
-		printk("reset set in interrupt, calling %p\n", cont->error);
+		pr_info("reset set in interrupt, calling %p\n", cont->error);
 		cont->error();	/* a reset just after a reset. BAD! */
 	}
 	cont->redo();
@@ -1864,46 +1862,44 @@ static void show_floppy(void)
 {
 	int i;
 
-	printk("\n");
-	printk("floppy driver state\n");
-	printk("-------------------\n");
-	printk("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
-	       jiffies, interruptjiffies, jiffies - interruptjiffies,
-	       lasthandler);
+	pr_info("\n");
+	pr_info("floppy driver state\n");
+	pr_info("-------------------\n");
+	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
+		jiffies, interruptjiffies, jiffies - interruptjiffies,
+		lasthandler);
 
 #ifdef FLOPPY_SANITY_CHECK
-	printk("timeout_message=%s\n", timeout_message);
-	printk("last output bytes:\n");
+	pr_info("timeout_message=%s\n", timeout_message);
+	pr_info("last output bytes:\n");
 	for (i = 0; i < OLOGSIZE; i++)
-		printk("%2x %2x %lu\n",
-		       output_log[(i + output_log_pos) % OLOGSIZE].data,
-		       output_log[(i + output_log_pos) % OLOGSIZE].status,
-		       output_log[(i + output_log_pos) % OLOGSIZE].jiffies);
-	printk("last result at %lu\n", resultjiffies);
-	printk("last redo_fd_request at %lu\n", lastredo);
-	for (i = 0; i < resultsize; i++) {
-		printk("%2x ", reply_buffer[i]);
-	}
-	printk("\n");
+		pr_info("%2x %2x %lu\n",
+			output_log[(i + output_log_pos) % OLOGSIZE].data,
+			output_log[(i + output_log_pos) % OLOGSIZE].status,
+			output_log[(i + output_log_pos) % OLOGSIZE].jiffies);
+	pr_info("last result at %lu\n", resultjiffies);
+	pr_info("last redo_fd_request at %lu\n", lastredo);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1,
+		       reply_buffer, resultsize, true);
 #endif
 
-	printk("status=%x\n", fd_inb(FD_STATUS));
-	printk("fdc_busy=%lu\n", fdc_busy);
+	pr_info("status=%x\n", fd_inb(FD_STATUS));
+	pr_info("fdc_busy=%lu\n", fdc_busy);
 	if (do_floppy)
-		printk("do_floppy=%p\n", do_floppy);
+		pr_info("do_floppy=%p\n", do_floppy);
 	if (work_pending(&floppy_work))
-		printk("floppy_work.func=%p\n", floppy_work.func);
+		pr_info("floppy_work.func=%p\n", floppy_work.func);
 	if (timer_pending(&fd_timer))
-		printk("fd_timer.function=%p\n", fd_timer.function);
+		pr_info("fd_timer.function=%p\n", fd_timer.function);
 	if (timer_pending(&fd_timeout)) {
-		printk("timer_function=%p\n", fd_timeout.function);
-		printk("expires=%lu\n", fd_timeout.expires - jiffies);
-		printk("now=%lu\n", jiffies);
-	}
-	printk("cont=%p\n", cont);
-	printk("current_req=%p\n", current_req);
-	printk("command_status=%d\n", command_status);
-	printk("\n");
+		pr_info("timer_function=%p\n", fd_timeout.function);
+		pr_info("expires=%lu\n", fd_timeout.expires - jiffies);
+		pr_info("now=%lu\n", jiffies);
+	}
+	pr_info("cont=%p\n", cont);
+	pr_info("current_req=%p\n", current_req);
+	pr_info("command_status=%d\n", command_status);
+	pr_info("\n");
 }
 
 static void floppy_shutdown(unsigned long data)
@@ -1929,7 +1925,7 @@ static void floppy_shutdown(unsigned lon
 		cont->done(0);
 		cont->redo();	/* this will recall reset when needed */
 	} else {
-		printk("no cont in shutdown!\n");
+		pr_info("no cont in shutdown!\n");
 		process_fd_request();
 	}
 	is_alive("floppy shutdown");
@@ -2329,10 +2325,10 @@ static void request_done(int uptodate)
 	int block;
 
 	probing = 0;
-	reschedule_timeout(MAXTIMEOUT, "request done %d", uptodate);
+	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
 
 	if (!req) {
-		printk("floppy.c: no request in request_done\n");
+		pr_info("floppy.c: no request in request_done\n");
 		return;
 	}
 
@@ -2405,13 +2401,13 @@ static void rw_interrupt(void)
 	    DIV_ROUND_UP(in_sector_offset + current_count_sectors, ssize)) {
 		DPRINT("long rw: %x instead of %lx\n",
 		       nr_sectors, current_count_sectors);
-		printk("rs=%d s=%d\n", R_SECTOR, SECTOR);
-		printk("rh=%d h=%d\n", R_HEAD, HEAD);
-		printk("rt=%d t=%d\n", R_TRACK, TRACK);
-		printk("heads=%d eoc=%d\n", heads, eoc);
-		printk("spt=%d st=%d ss=%d\n", SECT_PER_TRACK,
-		       fsector_t, ssize);
-		printk("in_sector_offset=%d\n", in_sector_offset);
+		pr_info("rs=%d s=%d\n", R_SECTOR, SECTOR);
+		pr_info("rh=%d h=%d\n", R_HEAD, HEAD);
+		pr_info("rt=%d t=%d\n", R_TRACK, TRACK);
+		pr_info("heads=%d eoc=%d\n", heads, eoc);
+		pr_info("spt=%d st=%d ss=%d\n",
+			SECT_PER_TRACK, fsector_t, ssize);
+		pr_info("in_sector_offset=%d\n", in_sector_offset);
 	}
 #endif
 
@@ -2521,14 +2517,14 @@ static void copy_buffer(int ssize, int m
 #ifdef FLOPPY_SANITY_CHECK
 	if (remaining > blk_rq_bytes(current_req) && CT(COMMAND) == FD_WRITE) {
 		DPRINT("in copy buffer\n");
-		printk("current_count_sectors=%ld\n", current_count_sectors);
-		printk("remaining=%d\n", remaining >> 9);
-		printk("current_req->nr_sectors=%u\n",
-		       blk_rq_sectors(current_req));
-		printk("current_req->current_nr_sectors=%u\n",
-		       blk_rq_cur_sectors(current_req));
-		printk("max_sector=%d\n", max_sector);
-		printk("ssize=%d\n", ssize);
+		pr_info("current_count_sectors=%ld\n", current_count_sectors);
+		pr_info("remaining=%d\n", remaining >> 9);
+		pr_info("current_req->nr_sectors=%u\n",
+			blk_rq_sectors(current_req));
+		pr_info("current_req->current_nr_sectors=%u\n",
+			blk_rq_cur_sectors(current_req));
+		pr_info("max_sector=%d\n", max_sector);
+		pr_info("ssize=%d\n", ssize);
 	}
 #endif
 
@@ -2551,16 +2547,15 @@ static void copy_buffer(int ssize, int m
 		    floppy_track_buffer + (max_buffer_sectors << 10) ||
 		    dma_buffer < floppy_track_buffer) {
 			DPRINT("buffer overrun in copy buffer %d\n",
-			       (int)((floppy_track_buffer -
-				      dma_buffer) >> 9));
-			printk("fsector_t=%d buffer_min=%d\n",
-			       fsector_t, buffer_min);
-			printk("current_count_sectors=%ld\n",
-			       current_count_sectors);
+			       (int)((floppy_track_buffer - dma_buffer) >> 9));
+			pr_info("fsector_t=%d buffer_min=%d\n",
+				fsector_t, buffer_min);
+			pr_info("current_count_sectors=%ld\n",
+				current_count_sectors);
 			if (CT(COMMAND) == FD_READ)
-				printk("read\n");
+				pr_info("read\n");
 			if (CT(COMMAND) == FD_WRITE)
-				printk("write\n");
+				pr_info("write\n");
 			break;
 		}
 		if (((unsigned long)buffer) % 512)
@@ -2602,8 +2597,8 @@ static void virtualdmabug_workaround(voi
 		end_sector = SECTOR + hard_sectors - 1;
 #ifdef FLOPPY_SANITY_CHECK
 		if (end_sector > SECT_PER_TRACK) {
-			printk("too many sectors %d > %d\n",
-			       end_sector, SECT_PER_TRACK);
+			pr_info("too many sectors %d > %d\n",
+				end_sector, SECT_PER_TRACK);
 			return;
 		}
 #endif
@@ -2632,7 +2627,7 @@ static int make_raw_rw_request(void)
 	int ssize;
 
 	if (max_buffer_sectors == 0) {
-		printk("VFS: Block I/O scheduled on unopened device\n");
+		pr_info("VFS: Block I/O scheduled on unopened device\n");
 		return 0;
 	}
 
@@ -2853,19 +2848,19 @@ static int make_raw_rw_request(void)
 		DPRINT("fractionary current count b=%lx s=%lx\n",
 		       raw_cmd->length, current_count_sectors);
 		if (raw_cmd->kernel_data != current_req->buffer)
-			printk("addr=%d, length=%ld\n",
-			       (int)((raw_cmd->kernel_data -
-				      floppy_track_buffer) >> 9),
-			       current_count_sectors);
-		printk("st=%d ast=%d mse=%d msi=%d\n",
-		       fsector_t, aligned_sector_t, max_sector, max_size);
-		printk("ssize=%x SIZECODE=%d\n", ssize, SIZECODE);
-		printk("command=%x SECTOR=%d HEAD=%d, TRACK=%d\n",
-		       COMMAND, SECTOR, HEAD, TRACK);
-		printk("buffer drive=%d\n", buffer_drive);
-		printk("buffer track=%d\n", buffer_track);
-		printk("buffer_min=%d\n", buffer_min);
-		printk("buffer_max=%d\n", buffer_max);
+			pr_info("addr=%d, length=%ld\n",
+				(int)((raw_cmd->kernel_data -
+				       floppy_track_buffer) >> 9),
+				current_count_sectors);
+		pr_info("st=%d ast=%d mse=%d msi=%d\n",
+			fsector_t, aligned_sector_t, max_sector, max_size);
+		pr_info("ssize=%x SIZECODE=%d\n", ssize, SIZECODE);
+		pr_info("command=%x SECTOR=%d HEAD=%d, TRACK=%d\n",
+			COMMAND, SECTOR, HEAD, TRACK);
+		pr_info("buffer drive=%d\n", buffer_drive);
+		pr_info("buffer track=%d\n", buffer_track);
+		pr_info("buffer_min=%d\n", buffer_min);
+		pr_info("buffer_max=%d\n", buffer_max);
 		return 0;
 	}
 
@@ -2876,14 +2871,14 @@ static int make_raw_rw_request(void)
 		    raw_cmd->kernel_data + raw_cmd->length >
 		    floppy_track_buffer + (max_buffer_sectors << 10)) {
 			DPRINT("buffer overrun in schedule dma\n");
-			printk("fsector_t=%d buffer_min=%d current_count=%ld\n",
-			       fsector_t, buffer_min, raw_cmd->length >> 9);
-			printk("current_count_sectors=%ld\n",
-			       current_count_sectors);
+			pr_info("fsector_t=%d buffer_min=%d current_count=%ld\n",
+				fsector_t, buffer_min, raw_cmd->length >> 9);
+			pr_info("current_count_sectors=%ld\n",
+				current_count_sectors);
 			if (CT(COMMAND) == FD_READ)
-				printk("read\n");
+				pr_info("read\n");
 			if (CT(COMMAND) == FD_WRITE)
-				printk("write\n");
+				pr_info("write\n");
 			return 0;
 		}
 	} else if (raw_cmd->length > blk_rq_bytes(current_req) ||
@@ -2892,8 +2887,8 @@ static int make_raw_rw_request(void)
 		return 0;
 	} else if (raw_cmd->length < current_count_sectors << 9) {
 		DPRINT("more sectors than bytes\n");
-		printk("bytes=%ld\n", raw_cmd->length >> 9);
-		printk("sectors=%ld\n", current_count_sectors);
+		pr_info("bytes=%ld\n", raw_cmd->length >> 9);
+		pr_info("sectors=%ld\n", current_count_sectors);
 	}
 	if (raw_cmd->length == 0) {
 		DPRINT("zero dma transfer attempted from make_raw_request\n");
@@ -2990,16 +2985,16 @@ static void process_fd_request(void)
 static void do_fd_request(struct request_queue * q)
 {
 	if (max_buffer_sectors == 0) {
-		printk("VFS: do_fd_request called on non-open device\n");
+		pr_info("VFS: do_fd_request called on non-open device\n");
 		return;
 	}
 
 	if (usage_count == 0) {
-		printk("warning: usage count=0, current_req=%p exiting\n",
-		       current_req);
-		printk("sect=%ld type=%x flags=%x\n",
-		       (long)blk_rq_pos(current_req), current_req->cmd_type,
-		       current_req->cmd_flags);
+		pr_info("warning: usage count=0, current_req=%p exiting\n",
+			current_req);
+		pr_info("sect=%ld type=%x flags=%x\n",
+			(long)blk_rq_pos(current_req), current_req->cmd_type,
+			current_req->cmd_flags);
 		return;
 	}
 	if (test_bit(0, &fdc_busy)) {
@@ -3047,7 +3042,7 @@ static int poll_drive(int interruptible,
 
 static void reset_intr(void)
 {
-	printk("weird, reset interrupt called\n");
+	pr_info("weird, reset interrupt called\n");
 }
 
 static struct cont_t reset_cont = {
@@ -3426,7 +3421,7 @@ static inline int normalize_ioctl(int *c
 			*size = _IOC_SIZE(*cmd);
 			*cmd = ioctl_table[i];
 			if (*size > _IOC_SIZE(*cmd)) {
-				printk("ioctl not yet supported\n");
+				pr_info("ioctl not yet supported\n");
 				return -EFAULT;
 			}
 			return 0;
@@ -3634,7 +3629,7 @@ static int fd_ioctl(struct block_device 
 
 static void __init config_types(void)
 {
-	int first = 1;
+	bool has_drive = false;
 	int drive;
 
 	/* read drive info out of physical CMOS */
@@ -3666,17 +3661,22 @@ static void __init config_types(void)
 			name = temparea;
 		}
 		if (name) {
-			const char *prepend = ",";
-			if (first) {
-				prepend = KERN_INFO "Floppy drive(s):";
-				first = 0;
+			const char *prepend;
+			if (!has_drive) {
+				prepend = "";
+				has_drive = true;
+				pr_info("Floppy drive(s):");
+			} else {
+				prepend = ",";
 			}
-			printk("%s fd%d is %s", prepend, drive, name);
+
+			pr_cont("%s fd%d is %s", prepend, drive, name);
 		}
 		*UDP = *params;
 	}
-	if (!first)
-		printk("\n");
+
+	if (has_drive)
+		pr_cont("\n");
 }
 
 static int floppy_release(struct gendisk *disk, fmode_t mode)
@@ -3891,7 +3891,7 @@ static int floppy_revalidate(struct gend
 	if (UTESTF(FD_DISK_CHANGED) ||
 	    UTESTF(FD_VERIFY) || test_bit(drive, &fake_change) || NO_GEOM) {
 		if (usage_count == 0) {
-			printk("VFS: revalidate called on non-open device.\n");
+			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
 		lock_fdc(drive, 0);
@@ -3948,18 +3948,17 @@ static char __init get_fdc_version(void)
 	if ((r = result()) <= 0x00)
 		return FDC_NONE;	/* No FDC present ??? */
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
-		printk(KERN_INFO "FDC %d is an 8272A\n", fdc);
+		pr_info("FDC %d is an 8272A\n", fdc);
 		return FDC_8272A;	/* 8272a/765 don't know DUMPREGS */
 	}
 	if (r != 10) {
-		printk
-		    ("FDC %d init: DUMPREGS: unexpected return of %d bytes.\n",
-		     fdc, r);
+		pr_info("FDC %d init: DUMPREGS: unexpected return of %d bytes.\n",
+			fdc, r);
 		return FDC_UNKNOWN;
 	}
 
 	if (!fdc_configure()) {
-		printk(KERN_INFO "FDC %d is an 82072\n", fdc);
+		pr_info("FDC %d is an 82072\n", fdc);
 		return FDC_82072;	/* 82072 doesn't know CONFIGURE */
 	}
 
@@ -3967,52 +3966,50 @@ static char __init get_fdc_version(void)
 	if (need_more_output() == MORE_OUTPUT) {
 		output_byte(0);
 	} else {
-		printk(KERN_INFO "FDC %d is an 82072A\n", fdc);
+		pr_info("FDC %d is an 82072A\n", fdc);
 		return FDC_82072A;	/* 82072A as found on Sparcs. */
 	}
 
 	output_byte(FD_UNLOCK);
 	r = result();
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
-		printk(KERN_INFO "FDC %d is a pre-1991 82077\n", fdc);
+		pr_info("FDC %d is a pre-1991 82077\n", fdc);
 		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know 
 					 * LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
-		printk("FDC %d init: UNLOCK: unexpected return of %d bytes.\n",
-		       fdc, r);
+		pr_info("FDC %d init: UNLOCK: unexpected return of %d bytes.\n",
+			fdc, r);
 		return FDC_UNKNOWN;
 	}
 	output_byte(FD_PARTID);
 	r = result();
 	if (r != 1) {
-		printk("FDC %d init: PARTID: unexpected return of %d bytes.\n",
-		       fdc, r);
+		pr_info("FDC %d init: PARTID: unexpected return of %d bytes.\n",
+			fdc, r);
 		return FDC_UNKNOWN;
 	}
 	if (reply_buffer[0] == 0x80) {
-		printk(KERN_INFO "FDC %d is a post-1991 82077\n", fdc);
+		pr_info("FDC %d is a post-1991 82077\n", fdc);
 		return FDC_82077;	/* Revised 82077AA passes all the tests */
 	}
 	switch (reply_buffer[0] >> 5) {
 	case 0x0:
 		/* Either a 82078-1 or a 82078SL running at 5Volt */
-		printk(KERN_INFO "FDC %d is an 82078.\n", fdc);
+		pr_info("FDC %d is an 82078.\n", fdc);
 		return FDC_82078;
 	case 0x1:
-		printk(KERN_INFO "FDC %d is a 44pin 82078\n", fdc);
+		pr_info("FDC %d is a 44pin 82078\n", fdc);
 		return FDC_82078;
 	case 0x2:
-		printk(KERN_INFO "FDC %d is a S82078B\n", fdc);
+		pr_info("FDC %d is a S82078B\n", fdc);
 		return FDC_S82078B;
 	case 0x3:
-		printk(KERN_INFO "FDC %d is a National Semiconductor PC87306\n",
-		       fdc);
+		pr_info("FDC %d is a National Semiconductor PC87306\n", fdc);
 		return FDC_87306;
 	default:
-		printk(KERN_INFO
-		       "FDC %d init: 82078 variant with unknown PARTID=%d.\n",
-		       fdc, reply_buffer[0] >> 5);
+		pr_info("FDC %d init: 82078 variant with unknown PARTID=%d.\n",
+			fdc, reply_buffer[0] >> 5);
 		return FDC_82078_UNKN;
 	}
 }				/* get_fdc_version */
@@ -4140,8 +4137,8 @@ static int __init floppy_setup(char *str
 
 		DPRINT("allowed options are:");
 		for (i = 0; i < ARRAY_SIZE(config_params); i++)
-			printk(" %s", config_params[i].name);
-		printk("\n");
+			pr_cont(" %s", config_params[i].name);
+		pr_cont("\n");
 	} else
 		DPRINT("botched floppy option\n");
 	DPRINT("Read Documentation/blockdev/floppy.txt\n");
@@ -4563,15 +4560,15 @@ static void floppy_release_irq_and_dma(v
 #ifndef __sparc__
 	for (drive = 0; drive < N_FDC * 4; drive++)
 		if (timer_pending(motor_off_timer + drive))
-			printk("motor off timer %d still active\n", drive);
+			pr_info("motor off timer %d still active\n", drive);
 #endif
 
 	if (timer_pending(&fd_timeout))
-		printk("floppy timer still active:%s\n", timeout_message);
+		pr_info("floppy timer still active:%s\n", timeout_message);
 	if (timer_pending(&fd_timer))
-		printk("auxiliary floppy timer still active\n");
+		pr_info("auxiliary floppy timer still active\n");
 	if (work_pending(&floppy_work))
-		printk("work still pending\n");
+		pr_info("work still pending\n");
 #endif
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

