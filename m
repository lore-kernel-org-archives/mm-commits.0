From: akpm@linux-foundation.org
Subject: + revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch added to -mm tree
Date: Wed, 22 Jul 2009 23:56:54 -0700
Message-ID: <200907230656.n6N6us1r017485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbZGWG53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 02:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, torvalds@linux-foundation.org


The patch titled
     revert "pty: Rework the pty layer to use the normal buffering logic"
has been added to the -mm tree.  Its filename is
     revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch

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
Subject: revert "pty: Rework the pty layer to use the normal buffering logic"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 

: commit d945cb9cce20ac7143c2de8d88b187f62db99bdc
: Author:     Alan Cox <alan@linux.intel.com>
: AuthorDate: Tue Jul 7 16:39:41 2009 +0100
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Wed Jul 8 09:47:59 2009 -0700
: 
:     pty: Rework the pty layer to use the normal buffering logic

Due to http://bugzilla.kernel.org/show_bug.cgi?id=13815

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pty.c |  152 ++++++++++++++++++++++++++-----------------
 1 file changed, 94 insertions(+), 58 deletions(-)

diff -puN drivers/char/pty.c~revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic drivers/char/pty.c
--- a/drivers/char/pty.c~revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic
+++ a/drivers/char/pty.c
@@ -76,88 +76,114 @@ static void pty_close(struct tty_struct 
  */
 static void pty_unthrottle(struct tty_struct *tty)
 {
-	tty_wakeup(tty->link);
-	set_bit(TTY_THROTTLED, &tty->flags);
-}
+	struct tty_struct *o_tty = tty->link;
 
-/**
- *	pty_space	-	report space left for writing
- *	@to: tty we are writing into
- *
- *	The tty buffers allow 64K but we sneak a peak and clip at 8K this
- *	allows a lot of overspill room for echo and other fun messes to
- *	be handled properly
- */
+	if (!o_tty)
+		return;
 
-static int pty_space(struct tty_struct *to)
-{
-	int n = 8192 - to->buf.memory_used;
-	if (n < 0)
-		return 0;
-	return n;
+	tty_wakeup(o_tty);
+	set_bit(TTY_THROTTLED, &tty->flags);
 }
 
-/**
- *	pty_write		-	write to a pty
- *	@tty: the tty we write from
- *	@buf: kernel buffer of data
- *	@count: bytes to write
+/*
+ * WSH 05/24/97: modified to
+ *   (1) use space in tty->flip instead of a shared temp buffer
+ *	 The flip buffers aren't being used for a pty, so there's lots
+ *	 of space available.  The buffer is protected by a per-pty
+ *	 semaphore that should almost never come under contention.
+ *   (2) avoid redundant copying for cases where count >> receive_room
+ * N.B. Calls from user space may now return an error code instead of
+ * a count.
+ *
+ * FIXME: Our pty_write method is called with our ldisc lock held but
+ * not our partners. We can't just wait on the other one blindly without
+ * risking deadlocks. At some point when everything has settled down we need
+ * to look into making pty_write at least able to sleep over an ldisc change.
  *
- *	Our "hardware" write method. Data is coming from the ldisc which
- *	may be in a non sleeping state. We simply throw this at the other
- *	end of the link as if we were an IRQ handler receiving stuff for
- *	the other side of the pty/tty pair.
+ * The return on no ldisc is a bit counter intuitive but the logic works
+ * like this. During an ldisc change the other end will flush its buffers. We
+ * thus return the full length which is identical to the case where we had
+ * proper locking and happened to queue the bytes just before the flush during
+ * the ldisc change.
  */
-
 static int pty_write(struct tty_struct *tty, const unsigned char *buf,
 								int count)
 {
 	struct tty_struct *to = tty->link;
-	int c;
+	struct tty_ldisc *ld;
+	int c = count;
 
-	if (tty->stopped)
+	if (!to || tty->stopped)
 		return 0;
+	ld = tty_ldisc_ref(to);
 
-	/* This isn't locked but our 8K is quite sloppy so no
-	   big deal */
-
-	c = pty_space(to);
-	if (c > count)
-		c = count;
-	if (c > 0) {
-		/* Stuff the data into the input queue of the other end */
-		c = tty_insert_flip_string(to, buf, c);
-		/* And shovel */
-		tty_flip_buffer_push(to);
-		tty_wakeup(tty);
+	if (ld) {
+		c = to->receive_room;
+		if (c > count)
+			c = count;
+		ld->ops->receive_buf(to, buf, NULL, c);
+		tty_ldisc_deref(ld);
 	}
 	return c;
 }
 
-/**
- *	pty_write_room	-	write space
- *	@tty: tty we are writing from
- *
- *	Report how many bytes the ldisc can send into the queue for
- *	the other device.
- */
-
 static int pty_write_room(struct tty_struct *tty)
 {
-	return pty_space(tty->link);
+	struct tty_struct *to = tty->link;
+
+	if (!to || tty->stopped)
+		return 0;
+
+	return to->receive_room;
 }
 
-/**
- *	pty_chars_in_buffer	-	characters currently in our tx queue
- *	@tty: our tty
+/*
+ *	WSH 05/24/97:  Modified for asymmetric MASTER/SLAVE behavior
+ *	The chars_in_buffer() value is used by the ldisc select() function
+ *	to hold off writing when chars_in_buffer > WAKEUP_CHARS (== 256).
+ *	The pty driver chars_in_buffer() Master/Slave must behave differently:
  *
- *	Report how much we have in the transmit queue. As everything is
- *	instantly at the other end this is easy to implement.
+ *      The Master side needs to allow typed-ahead commands to accumulate
+ *      while being canonicalized, so we report "our buffer" as empty until
+ *	some threshold is reached, and then report the count. (Any count >
+ *	WAKEUP_CHARS is regarded by select() as "full".)  To avoid deadlock
+ *	the count returned must be 0 if no canonical data is available to be
+ *	read. (The N_TTY ldisc.chars_in_buffer now knows this.)
+ *
+ *	The Slave side passes all characters in raw mode to the Master side's
+ *	buffer where they can be read immediately, so in this case we can
+ *	return the true count in the buffer.
  */
-
 static int pty_chars_in_buffer(struct tty_struct *tty)
 {
-	return 0;
+	struct tty_struct *to = tty->link;
+	struct tty_ldisc *ld;
+	int count = 0;
+
+	/* We should get the line discipline lock for "tty->link" */
+	if (!to)
+		return 0;
+	/* We cannot take a sleeping reference here without deadlocking with
+	   an ldisc change - but it doesn't really matter */
+	ld = tty_ldisc_ref(to);
+	if (ld == NULL)
+		return 0;
+
+	/* The ldisc must report 0 if no characters available to be read */
+	if (ld->ops->chars_in_buffer)
+		count = ld->ops->chars_in_buffer(to);
+
+	tty_ldisc_deref(ld);
+
+	if (tty->driver->subtype == PTY_TYPE_SLAVE)
+		return count;
+
+	/* Master side driver ... if the other side's read buffer is less than
+	 * half full, return 0 to allow writers to proceed; otherwise return
+	 * the count.  This leaves a comfortable margin to avoid overflow,
+	 * and still allows half a buffer's worth of typed-ahead commands.
+	 */
+	return (count < N_TTY_BUF_SIZE/2) ? 0 : count;
 }
 
 /* Set the lock flag on a pty */
@@ -177,10 +203,20 @@ static void pty_flush_buffer(struct tty_
 {
 	struct tty_struct *to = tty->link;
 	unsigned long flags;
+	struct tty_ldisc *ld;
 
 	if (!to)
 		return;
-	/* tty_buffer_flush(to); FIXME */
+	ld = tty_ldisc_ref(to);
+
+	/* The other end is changing discipline */
+	if (!ld)
+		return;
+
+	if (ld->ops->flush_buffer)
+		to->ldisc->ops->flush_buffer(to);
+	tty_ldisc_deref(ld);
+
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-serial-add-irqflags-support.patch
revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations-checkpatch-fixes.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

