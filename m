From: akpm@linux-foundation.org
Subject: + change-acquire-release_console_sem-to-console_lock-unlock.patch added to -mm tree
Date: Thu, 20 Jan 2011 12:36:43 -0800
Message-ID: <201101202036.p0KKah8n000936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab1ATUhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 15:37:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torbenh@gmx.de, gregkh@suse.de, mingo@elte.hu, tglx@tglx.de


The patch titled
     console: rename acquire/release_console_sem() to console_lock/unlock()
has been added to the -mm tree.  Its filename is
     change-acquire-release_console_sem-to-console_lock-unlock.patch

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
Subject: console: rename acquire/release_console_sem() to console_lock/unlock()
From: Torben Hohn <torbenh@gmx.de>

The -rt patches change the console_semaphore to console_mutex.  so a quite
large chunk of the patches changes all acquire/release_console_sem() to
acquire/release_console_mutex()

This commit makes things use more neutral function names which dont make
implications about the underlying lock.

The only real change is the return value of console_trylock which is
inverted from try_acquire_console_sem()

This patch also paves the way to switching console_sem from a semaphore to
a mutex.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Thomas Gleixner <tglx@tglx.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/pm24xx.c           |    4 
 arch/arm/mach-omap2/pm34xx.c           |    4 
 arch/arm/mach-omap2/serial.c           |    4 
 arch/parisc/kernel/pdc_cons.c          |    4 
 drivers/char/bfin_jtag_comm.c          |    8 -
 drivers/gpu/drm/nouveau/nouveau_drv.c  |    8 -
 drivers/gpu/drm/radeon/radeon_device.c |   10 -
 drivers/serial/sb1250-duart.c          |    2 
 drivers/staging/msm/msm_fb.c           |    8 -
 drivers/staging/olpc_dcon/olpc_dcon.c  |   10 -
 drivers/staging/sm7xx/smtcfb.c         |    8 -
 drivers/tty/tty_io.c                   |    4 
 drivers/tty/vt/selection.c             |    4 
 drivers/tty/vt/vc_screen.c             |   16 +-
 drivers/tty/vt/vt.c                    |  124 +++++++++++------------
 drivers/tty/vt/vt_ioctl.c              |   60 +++++------
 drivers/video/arkfb.c                  |   12 +-
 drivers/video/aty/aty128fb.c           |   12 +-
 drivers/video/aty/atyfb_base.c         |   10 -
 drivers/video/aty/radeon_pm.c          |   10 -
 drivers/video/chipsfb.c                |    8 -
 drivers/video/console/fbcon.c          |   42 +++----
 drivers/video/da8xx-fb.c               |    8 -
 drivers/video/fbmem.c                  |   12 +-
 drivers/video/fbsysfs.c                |   20 +--
 drivers/video/geode/gxfb_core.c        |    8 -
 drivers/video/geode/lxfb_core.c        |    8 -
 drivers/video/i810/i810_main.c         |    8 -
 drivers/video/jz4740_fb.c              |    8 -
 drivers/video/mx3fb.c                  |    8 -
 drivers/video/nvidia/nvidia.c          |    8 -
 drivers/video/ps3fb.c                  |   16 +-
 drivers/video/s3fb.c                   |   16 +-
 drivers/video/savage/savagefb_driver.c |    8 -
 drivers/video/sh_mobile_hdmi.c         |    8 -
 drivers/video/sh_mobile_lcdcfb.c       |    4 
 drivers/video/sm501fb.c                |    8 -
 drivers/video/tmiofb.c                 |   10 -
 drivers/video/via/viafbdev.c           |    8 -
 drivers/video/vt8623fb.c               |   12 +-
 drivers/video/xen-fbfront.c            |    4 
 fs/proc/consoles.c                     |    4 
 include/linux/console.h                |    6 -
 kernel/printk.c                        |  100 ++++++++++--------
 44 files changed, 336 insertions(+), 328 deletions(-)

diff -puN arch/arm/mach-omap2/pm24xx.c~change-acquire-release_console_sem-to-console_lock-unlock arch/arm/mach-omap2/pm24xx.c
--- a/arch/arm/mach-omap2/pm24xx.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/arch/arm/mach-omap2/pm24xx.c
@@ -134,7 +134,7 @@ static void omap2_enter_full_retention(v
 
 	/* Block console output in case it is on one of the OMAP UARTs */
 	if (!is_suspending())
-		if (try_acquire_console_sem())
+		if (!console_trylock())
 			goto no_sleep;
 
 	omap_uart_prepare_idle(0);
@@ -151,7 +151,7 @@ static void omap2_enter_full_retention(v
 	omap_uart_resume_idle(0);
 
 	if (!is_suspending())
-		release_console_sem();
+		console_unlock();
 
 no_sleep:
 	if (omap2_pm_debug) {
diff -puN arch/arm/mach-omap2/pm34xx.c~change-acquire-release_console_sem-to-console_lock-unlock arch/arm/mach-omap2/pm34xx.c
--- a/arch/arm/mach-omap2/pm34xx.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/arch/arm/mach-omap2/pm34xx.c
@@ -398,7 +398,7 @@ void omap_sram_idle(void)
 	if (!is_suspending())
 		if (per_next_state < PWRDM_POWER_ON ||
 		    core_next_state < PWRDM_POWER_ON)
-			if (try_acquire_console_sem())
+			if (!console_trylock())
 				goto console_still_active;
 
 	/* PER */
@@ -481,7 +481,7 @@ void omap_sram_idle(void)
 	}
 
 	if (!is_suspending())
-		release_console_sem();
+		console_unlock();
 
 console_still_active:
 	/* Disable IO-PAD and IO-CHAIN wakeup */
diff -puN arch/arm/mach-omap2/serial.c~change-acquire-release_console_sem-to-console_lock-unlock arch/arm/mach-omap2/serial.c
--- a/arch/arm/mach-omap2/serial.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/arch/arm/mach-omap2/serial.c
@@ -812,7 +812,7 @@ void __init omap_serial_init_port(struct
 
 	oh->dev_attr = uart;
 
-	acquire_console_sem(); /* in case the earlycon is on the UART */
+	console_lock(); /* in case the earlycon is on the UART */
 
 	/*
 	 * Because of early UART probing, UART did not get idled
@@ -838,7 +838,7 @@ void __init omap_serial_init_port(struct
 	omap_uart_block_sleep(uart);
 	uart->timeout = DEFAULT_TIMEOUT;
 
-	release_console_sem();
+	console_unlock();
 
 	if ((cpu_is_omap34xx() && uart->padconf) ||
 	    (uart->wk_en && uart->wk_mask)) {
diff -puN arch/parisc/kernel/pdc_cons.c~change-acquire-release_console_sem-to-console_lock-unlock arch/parisc/kernel/pdc_cons.c
--- a/arch/parisc/kernel/pdc_cons.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/arch/parisc/kernel/pdc_cons.c
@@ -169,11 +169,11 @@ static int __init pdc_console_tty_driver
 
 	struct console *tmp;
 
-	acquire_console_sem();
+	console_lock();
 	for_each_console(tmp)
 		if (tmp == &pdc_cons)
 			break;
-	release_console_sem();
+	console_unlock();
 
 	if (!tmp) {
 		printk(KERN_INFO "PDC console driver not registered anymore, not creating %s\n", pdc_cons.name);
diff -puN drivers/char/bfin_jtag_comm.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/char/bfin_jtag_comm.c
--- a/drivers/char/bfin_jtag_comm.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/char/bfin_jtag_comm.c
@@ -183,16 +183,16 @@ bfin_jc_circ_write(const unsigned char *
 }
 
 #ifndef CONFIG_BFIN_JTAG_COMM_CONSOLE
-# define acquire_console_sem()
-# define release_console_sem()
+# define console_lock()
+# define console_unlock()
 #endif
 static int
 bfin_jc_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
 	int i;
-	acquire_console_sem();
+	console_lock();
 	i = bfin_jc_circ_write(buf, count);
-	release_console_sem();
+	console_unlock();
 	wake_up_process(bfin_jc_kthread);
 	return i;
 }
diff -puN drivers/gpu/drm/nouveau/nouveau_drv.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/gpu/drm/nouveau/nouveau_drv.c
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -234,9 +234,9 @@ nouveau_pci_suspend(struct pci_dev *pdev
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 
-	acquire_console_sem();
+	console_lock();
 	nouveau_fbcon_set_suspend(dev, 1);
-	release_console_sem();
+	console_unlock();
 	nouveau_fbcon_restore_accel(dev);
 	return 0;
 
@@ -359,9 +359,9 @@ nouveau_pci_resume(struct pci_dev *pdev)
 		nv_crtc->lut.depth = 0;
 	}
 
-	acquire_console_sem();
+	console_lock();
 	nouveau_fbcon_set_suspend(dev, 0);
-	release_console_sem();
+	console_unlock();
 
 	nouveau_fbcon_zfill_all(dev);
 
diff -puN drivers/gpu/drm/radeon/radeon_device.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/gpu/drm/radeon/radeon_device.c
--- a/drivers/gpu/drm/radeon/radeon_device.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/gpu/drm/radeon/radeon_device.c
@@ -891,9 +891,9 @@ int radeon_suspend_kms(struct drm_device
 		pci_disable_device(dev->pdev);
 		pci_set_power_state(dev->pdev, PCI_D3hot);
 	}
-	acquire_console_sem();
+	console_lock();
 	radeon_fbdev_set_suspend(rdev, 1);
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 
@@ -905,11 +905,11 @@ int radeon_resume_kms(struct drm_device 
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 	pci_set_power_state(dev->pdev, PCI_D0);
 	pci_restore_state(dev->pdev);
 	if (pci_enable_device(dev->pdev)) {
-		release_console_sem();
+		console_unlock();
 		return -1;
 	}
 	pci_set_master(dev->pdev);
@@ -920,7 +920,7 @@ int radeon_resume_kms(struct drm_device 
 	radeon_restore_bios_scratch_regs(rdev);
 
 	radeon_fbdev_set_suspend(rdev, 0);
-	release_console_sem();
+	console_unlock();
 
 	/* reset hpd state */
 	radeon_hpd_init(rdev);
diff -puN drivers/serial/sb1250-duart.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/serial/sb1250-duart.c
--- a/drivers/serial/sb1250-duart.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/serial/sb1250-duart.c
@@ -829,7 +829,7 @@ static void __init sbd_probe_duarts(void
 #ifdef CONFIG_SERIAL_SB1250_DUART_CONSOLE
 /*
  * Serial console stuff.  Very basic, polling driver for doing serial
- * console output.  The console_sem is held by the caller, so we
+ * console output.  The console_lock is held by the caller, so we
  * shouldn't be interrupted for more console activity.
  */
 static void sbd_console_putchar(struct uart_port *uport, int ch)
diff -puN drivers/staging/msm/msm_fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/staging/msm/msm_fb.c
--- a/drivers/staging/msm/msm_fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/staging/msm/msm_fb.c
@@ -347,7 +347,7 @@ static int msm_fb_suspend(struct platfor
 	if ((!mfd) || (mfd->key != MFD_KEY))
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(mfd->fbi, 1);
 
 	ret = msm_fb_suspend_sub(mfd);
@@ -358,7 +358,7 @@ static int msm_fb_suspend(struct platfor
 		pdev->dev.power.power_state = state;
 	}
 
-	release_console_sem();
+	console_unlock();
 	return ret;
 }
 #else
@@ -431,11 +431,11 @@ static int msm_fb_resume(struct platform
 	if ((!mfd) || (mfd->key != MFD_KEY))
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 	ret = msm_fb_resume_sub(mfd);
 	pdev->dev.power.power_state = PMSG_ON;
 	fb_set_suspend(mfd->fbi, 1);
-	release_console_sem();
+	console_unlock();
 
 	return ret;
 }
diff -puN drivers/staging/olpc_dcon/olpc_dcon.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/staging/olpc_dcon/olpc_dcon.c
--- a/drivers/staging/olpc_dcon/olpc_dcon.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -373,17 +373,17 @@ static void dcon_source_switch(struct wo
 		 *
 		 * For now, we just hope..
 		 */
-		acquire_console_sem();
+		console_lock();
 		ignore_fb_events = 1;
 		if (fb_blank(fbinfo, FB_BLANK_UNBLANK)) {
 			ignore_fb_events = 0;
-			release_console_sem();
+			console_unlock();
 			printk(KERN_ERR "olpc-dcon:  Failed to enter CPU mode\n");
 			dcon_pending = DCON_SOURCE_DCON;
 			return;
 		}
 		ignore_fb_events = 0;
-		release_console_sem();
+		console_unlock();
 
 		/* And turn off the DCON */
 		pdata->set_dconload(1);
@@ -435,12 +435,12 @@ static void dcon_source_switch(struct wo
 			}
 		}
 
-		acquire_console_sem();
+		console_lock();
 		ignore_fb_events = 1;
 		if (fb_blank(fbinfo, FB_BLANK_POWERDOWN))
 			printk(KERN_ERR "olpc-dcon:  couldn't blank fb!\n");
 		ignore_fb_events = 0;
-		release_console_sem();
+		console_unlock();
 
 		printk(KERN_INFO "olpc-dcon: The DCON has control\n");
 		break;
diff -puN drivers/staging/sm7xx/smtcfb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/staging/sm7xx/smtcfb.c
--- a/drivers/staging/sm7xx/smtcfb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/staging/sm7xx/smtcfb.c
@@ -1044,9 +1044,9 @@ static int __maybe_unused smtcfb_suspend
 
 	/* when doing suspend, call fb apis and pci apis */
 	if (msg.event == PM_EVENT_SUSPEND) {
-		acquire_console_sem();
+		console_lock();
 		fb_set_suspend(&sfb->fb, 1);
-		release_console_sem();
+		console_unlock();
 		retv = pci_save_state(pdev);
 		pci_disable_device(pdev);
 		retv = pci_choose_state(pdev, msg);
@@ -1105,9 +1105,9 @@ static int __maybe_unused smtcfb_resume(
 
 	smtcfb_setmode(sfb);
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(&sfb->fb, 0);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/tty/tty_io.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/tty/tty_io.c
--- a/drivers/tty/tty_io.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/tty/tty_io.c
@@ -3256,7 +3256,7 @@ static ssize_t show_cons_active(struct d
 	struct console *c;
 	ssize_t count = 0;
 
-	acquire_console_sem();
+	console_lock();
 	for (c = console_drivers; c; c = c->next) {
 		if (!c->device)
 			continue;
@@ -3271,7 +3271,7 @@ static ssize_t show_cons_active(struct d
 	while (i--)
 		count += sprintf(buf + count, "%s%d%c",
 				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
-	release_console_sem();
+	console_unlock();
 
 	return count;
 }
diff -puN drivers/tty/vt/selection.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/tty/vt/selection.c
--- a/drivers/tty/vt/selection.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/tty/vt/selection.c
@@ -316,9 +316,9 @@ int paste_selection(struct tty_struct *t
 	/* always called with BTM from vt_ioctl */
 	WARN_ON(!tty_locked());
 
-	acquire_console_sem();
+	console_lock();
 	poke_blanked_console();
-	release_console_sem();
+	console_unlock();
 
 	ld = tty_ldisc_ref(tty);
 	if (!ld) {
diff -puN drivers/tty/vt/vc_screen.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/tty/vt/vc_screen.c
--- a/drivers/tty/vt/vc_screen.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/tty/vt/vc_screen.c
@@ -202,7 +202,7 @@ vcs_read(struct file *file, char __user 
 	/* Select the proper current console and verify
 	 * sanity of the situation under the console lock.
 	 */
-	acquire_console_sem();
+	console_lock();
 
 	attr = (currcons & 128);
 	currcons = (currcons & 127);
@@ -336,9 +336,9 @@ vcs_read(struct file *file, char __user 
 		 * the pagefault handling code may want to call printk().
 		 */
 
-		release_console_sem();
+		console_unlock();
 		ret = copy_to_user(buf, con_buf_start, orig_count);
-		acquire_console_sem();
+		console_lock();
 
 		if (ret) {
 			read += (orig_count - ret);
@@ -354,7 +354,7 @@ vcs_read(struct file *file, char __user 
 	if (read)
 		ret = read;
 unlock_out:
-	release_console_sem();
+	console_unlock();
 	mutex_unlock(&con_buf_mtx);
 	return ret;
 }
@@ -379,7 +379,7 @@ vcs_write(struct file *file, const char 
 	/* Select the proper current console and verify
 	 * sanity of the situation under the console lock.
 	 */
-	acquire_console_sem();
+	console_lock();
 
 	attr = (currcons & 128);
 	currcons = (currcons & 127);
@@ -414,9 +414,9 @@ vcs_write(struct file *file, const char 
 		/* Temporarily drop the console lock so that we can read
 		 * in the write data from userspace safely.
 		 */
-		release_console_sem();
+		console_unlock();
 		ret = copy_from_user(con_buf, buf, this_round);
-		acquire_console_sem();
+		console_lock();
 
 		if (ret) {
 			this_round -= ret;
@@ -542,7 +542,7 @@ vcs_write(struct file *file, const char 
 		vcs_scr_updated(vc);
 
 unlock_out:
-	release_console_sem();
+	console_unlock();
 
 	mutex_unlock(&con_buf_mtx);
 
diff -puN drivers/tty/vt/vt.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/tty/vt/vt.c
@@ -1003,9 +1003,9 @@ static int vt_resize(struct tty_struct *
 	struct vc_data *vc = tty->driver_data;
 	int ret;
 
-	acquire_console_sem();
+	console_lock();
 	ret = vc_do_resize(tty, vc, ws->ws_col, ws->ws_row);
-	release_console_sem();
+	console_unlock();
 	return ret;
 }
 
@@ -1271,7 +1271,7 @@ static void default_attr(struct vc_data 
 	vc->vc_color = vc->vc_def_color;
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void csi_m(struct vc_data *vc)
 {
 	int i;
@@ -1415,7 +1415,7 @@ int mouse_reporting(void)
 	return vc_cons[fg_console].d->vc_report_mouse;
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void set_mode(struct vc_data *vc, int on_off)
 {
 	int i;
@@ -1485,7 +1485,7 @@ static void set_mode(struct vc_data *vc,
 		}
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void setterm_command(struct vc_data *vc)
 {
 	switch(vc->vc_par[0]) {
@@ -1545,7 +1545,7 @@ static void setterm_command(struct vc_da
 	}
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void csi_at(struct vc_data *vc, unsigned int nr)
 {
 	if (nr > vc->vc_cols - vc->vc_x)
@@ -1555,7 +1555,7 @@ static void csi_at(struct vc_data *vc, u
 	insert_char(vc, nr);
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void csi_L(struct vc_data *vc, unsigned int nr)
 {
 	if (nr > vc->vc_rows - vc->vc_y)
@@ -1566,7 +1566,7 @@ static void csi_L(struct vc_data *vc, un
 	vc->vc_need_wrap = 0;
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void csi_P(struct vc_data *vc, unsigned int nr)
 {
 	if (nr > vc->vc_cols - vc->vc_x)
@@ -1576,7 +1576,7 @@ static void csi_P(struct vc_data *vc, un
 	delete_char(vc, nr);
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void csi_M(struct vc_data *vc, unsigned int nr)
 {
 	if (nr > vc->vc_rows - vc->vc_y)
@@ -1587,7 +1587,7 @@ static void csi_M(struct vc_data *vc, un
 	vc->vc_need_wrap = 0;
 }
 
-/* console_sem is held (except via vc_init->reset_terminal */
+/* console_lock is held (except via vc_init->reset_terminal */
 static void save_cur(struct vc_data *vc)
 {
 	vc->vc_saved_x		= vc->vc_x;
@@ -1603,7 +1603,7 @@ static void save_cur(struct vc_data *vc)
 	vc->vc_saved_G1		= vc->vc_G1_charset;
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void restore_cur(struct vc_data *vc)
 {
 	gotoxy(vc, vc->vc_saved_x, vc->vc_saved_y);
@@ -1625,7 +1625,7 @@ enum { ESnormal, ESesc, ESsquare, ESgetp
 	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
 	ESpalette };
 
-/* console_sem is held (except via vc_init()) */
+/* console_lock is held (except via vc_init()) */
 static void reset_terminal(struct vc_data *vc, int do_clear)
 {
 	vc->vc_top		= 0;
@@ -1685,7 +1685,7 @@ static void reset_terminal(struct vc_dat
 	    csi_J(vc, 2);
 }
 
-/* console_sem is held */
+/* console_lock is held */
 static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 {
 	/*
@@ -2119,7 +2119,7 @@ static int is_double_width(uint32_t ucs)
 	return bisearch(ucs, double_width, ARRAY_SIZE(double_width) - 1);
 }
 
-/* acquires console_sem */
+/* acquires console_lock */
 static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
 #ifdef VT_BUF_VRAM_ONLY
@@ -2147,11 +2147,11 @@ static int do_con_write(struct tty_struc
 
 	might_sleep();
 
-	acquire_console_sem();
+	console_lock();
 	vc = tty->driver_data;
 	if (vc == NULL) {
 		printk(KERN_ERR "vt: argh, driver_data is NULL !\n");
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 
@@ -2159,7 +2159,7 @@ static int do_con_write(struct tty_struc
 	if (!vc_cons_allocated(currcons)) {
 	    /* could this happen? */
 		printk_once("con_write: tty %d not allocated\n", currcons+1);
-	    release_console_sem();
+	    console_unlock();
 	    return 0;
 	}
 
@@ -2375,7 +2375,7 @@ rescan_last_byte:
 	}
 	FLUSH
 	console_conditional_schedule();
-	release_console_sem();
+	console_unlock();
 	notify_update(vc);
 	return n;
 #undef FLUSH
@@ -2388,11 +2388,11 @@ rescan_last_byte:
  * us to do the switches asynchronously (needed when we want
  * to switch due to a keyboard interrupt).  Synchronization
  * with other console code and prevention of re-entrancy is
- * ensured with console_sem.
+ * ensured with console_lock.
  */
 static void console_callback(struct work_struct *ignored)
 {
-	acquire_console_sem();
+	console_lock();
 
 	if (want_console >= 0) {
 		if (want_console != fg_console &&
@@ -2422,7 +2422,7 @@ static void console_callback(struct work
 	}
 	notify_update(vc_cons[fg_console].d);
 
-	release_console_sem();
+	console_unlock();
 }
 
 int set_console(int nr)
@@ -2603,7 +2603,7 @@ static struct console vt_console_driver 
  */
 
 /*
- * Generally a bit racy with respect to console_sem().
+ * Generally a bit racy with respect to console_lock();.
  *
  * There are some functions which don't need it.
  *
@@ -2629,17 +2629,17 @@ int tioclinux(struct tty_struct *tty, un
 	switch (type)
 	{
 		case TIOCL_SETSEL:
-			acquire_console_sem();
+			console_lock();
 			ret = set_selection((struct tiocl_selection __user *)(p+1), tty);
-			release_console_sem();
+			console_unlock();
 			break;
 		case TIOCL_PASTESEL:
 			ret = paste_selection(tty);
 			break;
 		case TIOCL_UNBLANKSCREEN:
-			acquire_console_sem();
+			console_lock();
 			unblank_screen();
-			release_console_sem();
+			console_unlock();
 			break;
 		case TIOCL_SELLOADLUT:
 			ret = sel_loadlut(p);
@@ -2688,10 +2688,10 @@ int tioclinux(struct tty_struct *tty, un
 			}
 			break;
 		case TIOCL_BLANKSCREEN:	/* until explicitly unblanked, not only poked */
-			acquire_console_sem();
+			console_lock();
 			ignore_poke = 1;
 			do_blank_screen(0);
-			release_console_sem();
+			console_unlock();
 			break;
 		case TIOCL_BLANKEDSCREEN:
 			ret = console_blanked;
@@ -2790,11 +2790,11 @@ static void con_flush_chars(struct tty_s
 		return;
 
 	/* if we race with con_close(), vt may be null */
-	acquire_console_sem();
+	console_lock();
 	vc = tty->driver_data;
 	if (vc)
 		set_cursor(vc);
-	release_console_sem();
+	console_unlock();
 }
 
 /*
@@ -2805,7 +2805,7 @@ static int con_open(struct tty_struct *t
 	unsigned int currcons = tty->index;
 	int ret = 0;
 
-	acquire_console_sem();
+	console_lock();
 	if (tty->driver_data == NULL) {
 		ret = vc_allocate(currcons);
 		if (ret == 0) {
@@ -2813,7 +2813,7 @@ static int con_open(struct tty_struct *t
 
 			/* Still being freed */
 			if (vc->port.tty) {
-				release_console_sem();
+				console_unlock();
 				return -ERESTARTSYS;
 			}
 			tty->driver_data = vc;
@@ -2827,11 +2827,11 @@ static int con_open(struct tty_struct *t
 				tty->termios->c_iflag |= IUTF8;
 			else
 				tty->termios->c_iflag &= ~IUTF8;
-			release_console_sem();
+			console_unlock();
 			return ret;
 		}
 	}
-	release_console_sem();
+	console_unlock();
 	return ret;
 }
 
@@ -2844,9 +2844,9 @@ static void con_shutdown(struct tty_stru
 {
 	struct vc_data *vc = tty->driver_data;
 	BUG_ON(vc == NULL);
-	acquire_console_sem();
+	console_lock();
 	vc->port.tty = NULL;
-	release_console_sem();
+	console_unlock();
 	tty_shutdown(tty);
 }
 
@@ -2893,13 +2893,13 @@ static int __init con_init(void)
 	struct vc_data *vc;
 	unsigned int currcons = 0, i;
 
-	acquire_console_sem();
+	console_lock();
 
 	if (conswitchp)
 		display_desc = conswitchp->con_startup();
 	if (!display_desc) {
 		fg_console = 0;
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 
@@ -2946,7 +2946,7 @@ static int __init con_init(void)
 	printable = 1;
 	printk("\n");
 
-	release_console_sem();
+	console_unlock();
 
 #ifdef CONFIG_VT_CONSOLE
 	register_console(&vt_console_driver);
@@ -3037,7 +3037,7 @@ static int bind_con_driver(const struct 
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	acquire_console_sem();
+	console_lock();
 
 	/* check if driver is registered */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3122,7 +3122,7 @@ static int bind_con_driver(const struct 
 
 	retval = 0;
 err:
-	release_console_sem();
+	console_unlock();
 	module_put(owner);
 	return retval;
 };
@@ -3171,7 +3171,7 @@ int unbind_con_driver(const struct consw
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	acquire_console_sem();
+	console_lock();
 
 	/* check if driver is registered and if it is unbindable */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3185,7 +3185,7 @@ int unbind_con_driver(const struct consw
 	}
 
 	if (retval) {
-		release_console_sem();
+		console_unlock();
 		goto err;
 	}
 
@@ -3204,12 +3204,12 @@ int unbind_con_driver(const struct consw
 	}
 
 	if (retval) {
-		release_console_sem();
+		console_unlock();
 		goto err;
 	}
 
 	if (!con_is_bound(csw)) {
-		release_console_sem();
+		console_unlock();
 		goto err;
 	}
 
@@ -3238,7 +3238,7 @@ int unbind_con_driver(const struct consw
 	if (!con_is_bound(csw))
 		con_driver->flag &= ~CON_DRIVER_FLAG_INIT;
 
-	release_console_sem();
+	console_unlock();
 	/* ignore return value, binding should not fail */
 	bind_con_driver(defcsw, first, last, deflt);
 err:
@@ -3538,7 +3538,7 @@ int register_con_driver(const struct con
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	acquire_console_sem();
+	console_lock();
 
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_driver = &registered_con_driver[i];
@@ -3592,7 +3592,7 @@ int register_con_driver(const struct con
 	}
 
 err:
-	release_console_sem();
+	console_unlock();
 	module_put(owner);
 	return retval;
 }
@@ -3613,7 +3613,7 @@ int unregister_con_driver(const struct c
 {
 	int i, retval = -ENODEV;
 
-	acquire_console_sem();
+	console_lock();
 
 	/* cannot unregister a bound driver */
 	if (con_is_bound(csw))
@@ -3639,7 +3639,7 @@ int unregister_con_driver(const struct c
 		}
 	}
 err:
-	release_console_sem();
+	console_unlock();
 	return retval;
 }
 EXPORT_SYMBOL(unregister_con_driver);
@@ -3934,9 +3934,9 @@ int con_set_cmap(unsigned char __user *a
 {
 	int rc;
 
-	acquire_console_sem();
+	console_lock();
 	rc = set_get_cmap (arg,1);
-	release_console_sem();
+	console_unlock();
 
 	return rc;
 }
@@ -3945,9 +3945,9 @@ int con_get_cmap(unsigned char __user *a
 {
 	int rc;
 
-	acquire_console_sem();
+	console_lock();
 	rc = set_get_cmap (arg,0);
-	release_console_sem();
+	console_unlock();
 
 	return rc;
 }
@@ -3994,12 +3994,12 @@ static int con_font_get(struct vc_data *
 	} else
 		font.data = NULL;
 
-	acquire_console_sem();
+	console_lock();
 	if (vc->vc_sw->con_font_get)
 		rc = vc->vc_sw->con_font_get(vc, &font);
 	else
 		rc = -ENOSYS;
-	release_console_sem();
+	console_unlock();
 
 	if (rc)
 		goto out;
@@ -4076,12 +4076,12 @@ static int con_font_set(struct vc_data *
 	font.data = memdup_user(op->data, size);
 	if (IS_ERR(font.data))
 		return PTR_ERR(font.data);
-	acquire_console_sem();
+	console_lock();
 	if (vc->vc_sw->con_font_set)
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
 	else
 		rc = -ENOSYS;
-	release_console_sem();
+	console_unlock();
 	kfree(font.data);
 	return rc;
 }
@@ -4103,12 +4103,12 @@ static int con_font_default(struct vc_da
 	else
 		name[MAX_FONT_NAME - 1] = 0;
 
-	acquire_console_sem();
+	console_lock();
 	if (vc->vc_sw->con_font_default)
 		rc = vc->vc_sw->con_font_default(vc, &font, s);
 	else
 		rc = -ENOSYS;
-	release_console_sem();
+	console_unlock();
 	if (!rc) {
 		op->width = font.width;
 		op->height = font.height;
@@ -4124,7 +4124,7 @@ static int con_font_copy(struct vc_data 
 	if (vc->vc_mode != KD_TEXT)
 		return -EINVAL;
 
-	acquire_console_sem();
+	console_lock();
 	if (!vc->vc_sw->con_font_copy)
 		rc = -ENOSYS;
 	else if (con < 0 || !vc_cons_allocated(con))
@@ -4133,7 +4133,7 @@ static int con_font_copy(struct vc_data 
 		rc = 0;
 	else
 		rc = vc->vc_sw->con_font_copy(vc, con);
-	release_console_sem();
+	console_unlock();
 	return rc;
 }
 
diff -puN drivers/tty/vt/vt_ioctl.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/tty/vt/vt_ioctl.c
--- a/drivers/tty/vt/vt_ioctl.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/tty/vt/vt_ioctl.c
@@ -649,12 +649,12 @@ int vt_ioctl(struct tty_struct *tty, str
 		/*
 		 * explicitly blank/unblank the screen if switching modes
 		 */
-		acquire_console_sem();
+		console_lock();
 		if (arg == KD_TEXT)
 			do_unblank_screen(1);
 		else
 			do_blank_screen(1);
-		release_console_sem();
+		console_unlock();
 		break;
 
 	case KDGETMODE:
@@ -893,7 +893,7 @@ int vt_ioctl(struct tty_struct *tty, str
 			ret = -EINVAL;
 			goto out;
 		}
-		acquire_console_sem();
+		console_lock();
 		vc->vt_mode = tmp;
 		/* the frsig is ignored, so we set it to 0 */
 		vc->vt_mode.frsig = 0;
@@ -901,7 +901,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		vc->vt_pid = get_pid(task_pid(current));
 		/* no switch is required -- saw@shade.msu.ru */
 		vc->vt_newvt = -1;
-		release_console_sem();
+		console_unlock();
 		break;
 	}
 
@@ -910,9 +910,9 @@ int vt_ioctl(struct tty_struct *tty, str
 		struct vt_mode tmp;
 		int rc;
 
-		acquire_console_sem();
+		console_lock();
 		memcpy(&tmp, &vc->vt_mode, sizeof(struct vt_mode));
-		release_console_sem();
+		console_unlock();
 
 		rc = copy_to_user(up, &tmp, sizeof(struct vt_mode));
 		if (rc)
@@ -965,9 +965,9 @@ int vt_ioctl(struct tty_struct *tty, str
 			ret =  -ENXIO;
 		else {
 			arg--;
-			acquire_console_sem();
+			console_lock();
 			ret = vc_allocate(arg);
-			release_console_sem();
+			console_unlock();
 			if (ret)
 				break;
 			set_console(arg);
@@ -990,7 +990,7 @@ int vt_ioctl(struct tty_struct *tty, str
 			ret = -ENXIO;
 		else {
 			vsa.console--;
-			acquire_console_sem();
+			console_lock();
 			ret = vc_allocate(vsa.console);
 			if (ret == 0) {
 				struct vc_data *nvc;
@@ -1003,7 +1003,7 @@ int vt_ioctl(struct tty_struct *tty, str
 				put_pid(nvc->vt_pid);
 				nvc->vt_pid = get_pid(task_pid(current));
 			}
-			release_console_sem();
+			console_unlock();
 			if (ret)
 				break;
 			/* Commence switch and lock */
@@ -1044,7 +1044,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		/*
 		 * Switching-from response
 		 */
-		acquire_console_sem();
+		console_lock();
 		if (vc->vt_newvt >= 0) {
 			if (arg == 0)
 				/*
@@ -1063,7 +1063,7 @@ int vt_ioctl(struct tty_struct *tty, str
 				vc->vt_newvt = -1;
 				ret = vc_allocate(newvt);
 				if (ret) {
-					release_console_sem();
+					console_unlock();
 					break;
 				}
 				/*
@@ -1083,7 +1083,7 @@ int vt_ioctl(struct tty_struct *tty, str
 			if (arg != VT_ACKACQ)
 				ret = -EINVAL;
 		}
-		release_console_sem();
+		console_unlock();
 		break;
 
 	 /*
@@ -1096,20 +1096,20 @@ int vt_ioctl(struct tty_struct *tty, str
 		}
 		if (arg == 0) {
 		    /* deallocate all unused consoles, but leave 0 */
-			acquire_console_sem();
+			console_lock();
 			for (i=1; i<MAX_NR_CONSOLES; i++)
 				if (! VT_BUSY(i))
 					vc_deallocate(i);
-			release_console_sem();
+			console_unlock();
 		} else {
 			/* deallocate a single console, if possible */
 			arg--;
 			if (VT_BUSY(arg))
 				ret = -EBUSY;
 			else if (arg) {			      /* leave 0 */
-				acquire_console_sem();
+				console_lock();
 				vc_deallocate(arg);
-				release_console_sem();
+				console_unlock();
 			}
 		}
 		break;
@@ -1126,7 +1126,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		    get_user(cc, &vtsizes->v_cols))
 			ret = -EFAULT;
 		else {
-			acquire_console_sem();
+			console_lock();
 			for (i = 0; i < MAX_NR_CONSOLES; i++) {
 				vc = vc_cons[i].d;
 
@@ -1135,7 +1135,7 @@ int vt_ioctl(struct tty_struct *tty, str
 					vc_resize(vc_cons[i].d, cc, ll);
 				}
 			}
-			release_console_sem();
+			console_unlock();
 		}
 		break;
 	}
@@ -1187,14 +1187,14 @@ int vt_ioctl(struct tty_struct *tty, str
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			if (!vc_cons[i].d)
 				continue;
-			acquire_console_sem();
+			console_lock();
 			if (vlin)
 				vc_cons[i].d->vc_scan_lines = vlin;
 			if (clin)
 				vc_cons[i].d->vc_font.height = clin;
 			vc_cons[i].d->vc_resize_user = 1;
 			vc_resize(vc_cons[i].d, cc, ll);
-			release_console_sem();
+			console_unlock();
 		}
 		break;
 	}
@@ -1367,7 +1367,7 @@ void vc_SAK(struct work_struct *work)
 	struct vc_data *vc;
 	struct tty_struct *tty;
 
-	acquire_console_sem();
+	console_lock();
 	vc = vc_con->d;
 	if (vc) {
 		tty = vc->port.tty;
@@ -1379,7 +1379,7 @@ void vc_SAK(struct work_struct *work)
 			__do_SAK(tty);
 		reset_vc(vc);
 	}
-	release_console_sem();
+	console_unlock();
 }
 
 #ifdef CONFIG_COMPAT
@@ -1737,10 +1737,10 @@ int vt_move_to_console(unsigned int vt, 
 {
 	int prev;
 
-	acquire_console_sem();
+	console_lock();
 	/* Graphics mode - up to X */
 	if (disable_vt_switch) {
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 	prev = fg_console;
@@ -1748,7 +1748,7 @@ int vt_move_to_console(unsigned int vt, 
 	if (alloc && vc_allocate(vt)) {
 		/* we can't have a free VC for now. Too bad,
 		 * we don't want to mess the screen for now. */
-		release_console_sem();
+		console_unlock();
 		return -ENOSPC;
 	}
 
@@ -1758,10 +1758,10 @@ int vt_move_to_console(unsigned int vt, 
 		 * Let the calling function know so it can decide
 		 * what to do.
 		 */
-		release_console_sem();
+		console_unlock();
 		return -EIO;
 	}
-	release_console_sem();
+	console_unlock();
 	tty_lock();
 	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
@@ -1781,8 +1781,8 @@ int vt_move_to_console(unsigned int vt, 
  */
 void pm_set_vt_switch(int do_switch)
 {
-	acquire_console_sem();
+	console_lock();
 	disable_vt_switch = !do_switch;
-	release_console_sem();
+	console_unlock();
 }
 EXPORT_SYMBOL(pm_set_vt_switch);
diff -puN drivers/video/arkfb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/arkfb.c
@@ -23,7 +23,7 @@
 #include <linux/svga.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/console.h> /* Why should fb driver call console functions? because acquire_console_sem() */
+#include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */
 #include <video/vga.h>
 
 #ifdef CONFIG_MTRR
@@ -1091,12 +1091,12 @@ static int ark_pci_suspend (struct pci_d
 
 	dev_info(info->device, "suspend\n");
 
-	acquire_console_sem();
+	console_lock();
 	mutex_lock(&(par->open_lock));
 
 	if ((state.event == PM_EVENT_FREEZE) || (par->ref_count == 0)) {
 		mutex_unlock(&(par->open_lock));
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 
@@ -1107,7 +1107,7 @@ static int ark_pci_suspend (struct pci_d
 	pci_set_power_state(dev, pci_choose_state(dev, state));
 
 	mutex_unlock(&(par->open_lock));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -1122,7 +1122,7 @@ static int ark_pci_resume (struct pci_de
 
 	dev_info(info->device, "resume\n");
 
-	acquire_console_sem();
+	console_lock();
 	mutex_lock(&(par->open_lock));
 
 	if (par->ref_count == 0)
@@ -1141,7 +1141,7 @@ static int ark_pci_resume (struct pci_de
 
 fail:
 	mutex_unlock(&(par->open_lock));
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 #else
diff -puN drivers/video/aty/aty128fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/aty/aty128fb.c
@@ -1861,11 +1861,11 @@ static void aty128_early_resume(void *da
 {
         struct aty128fb_par *par = data;
 
-	if (try_acquire_console_sem())
+	if (!console_trylock())
 		return;
 	pci_restore_state(par->pdev);
 	aty128_do_resume(par->pdev);
-	release_console_sem();
+	console_unlock();
 }
 #endif /* CONFIG_PPC_PMAC */
 
@@ -2439,7 +2439,7 @@ static int aty128_pci_suspend(struct pci
 
 	printk(KERN_DEBUG "aty128fb: suspending...\n");
 	
-	acquire_console_sem();
+	console_lock();
 
 	fb_set_suspend(info, 1);
 
@@ -2471,7 +2471,7 @@ static int aty128_pci_suspend(struct pci
 	if (state.event != PM_EVENT_ON)
 		aty128_set_suspend(par, 1);
 
-	release_console_sem();
+	console_unlock();
 
 	pdev->dev.power.power_state = state;
 
@@ -2528,9 +2528,9 @@ static int aty128_pci_resume(struct pci_
 {
 	int rc;
 
-	acquire_console_sem();
+	console_lock();
 	rc = aty128_do_resume(pdev);
-	release_console_sem();
+	console_unlock();
 
 	return rc;
 }
diff -puN drivers/video/aty/atyfb_base.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/aty/atyfb_base.c
@@ -2069,7 +2069,7 @@ static int atyfb_pci_suspend(struct pci_
 	if (state.event == pdev->dev.power.power_state.event)
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 
 	fb_set_suspend(info, 1);
 
@@ -2097,14 +2097,14 @@ static int atyfb_pci_suspend(struct pci_
 		par->lock_blank = 0;
 		atyfb_blank(FB_BLANK_UNBLANK, info);
 		fb_set_suspend(info, 0);
-		release_console_sem();
+		console_unlock();
 		return -EIO;
 	}
 #else
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 #endif
 
-	release_console_sem();
+	console_unlock();
 
 	pdev->dev.power.power_state = state;
 
@@ -2133,7 +2133,7 @@ static int atyfb_pci_resume(struct pci_d
 	if (pdev->dev.power.power_state.event == PM_EVENT_ON)
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 
 	/*
 	 * PCI state will have been restored by the core, so
@@ -2161,7 +2161,7 @@ static int atyfb_pci_resume(struct pci_d
 	par->lock_blank = 0;
 	atyfb_blank(FB_BLANK_UNBLANK, info);
 
-	release_console_sem();
+	console_unlock();
 
 	pdev->dev.power.power_state = PMSG_ON;
 
diff -puN drivers/video/aty/radeon_pm.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/aty/radeon_pm.c
@@ -2626,7 +2626,7 @@ int radeonfb_pci_suspend(struct pci_dev 
 		goto done;
 	}
 
-	acquire_console_sem();
+	console_lock();
 
 	fb_set_suspend(info, 1);
 
@@ -2690,7 +2690,7 @@ int radeonfb_pci_suspend(struct pci_dev 
 	if (rinfo->pm_mode & radeon_pm_d2)
 		radeon_set_suspend(rinfo, 1);
 
-	release_console_sem();
+	console_unlock();
 
  done:
 	pdev->dev.power.power_state = mesg;
@@ -2715,10 +2715,10 @@ int radeonfb_pci_resume(struct pci_dev *
 		return 0;
 
 	if (rinfo->no_schedule) {
-		if (try_acquire_console_sem())
+		if (!console_trylock())
 			return 0;
 	} else
-		acquire_console_sem();
+		console_lock();
 
 	printk(KERN_DEBUG "radeonfb (%s): resuming from state: %d...\n",
 	       pci_name(pdev), pdev->dev.power.power_state.event);
@@ -2783,7 +2783,7 @@ int radeonfb_pci_resume(struct pci_dev *
 	pdev->dev.power.power_state = PMSG_ON;
 
  bail:
-	release_console_sem();
+	console_unlock();
 
 	return rc;
 }
diff -puN drivers/video/chipsfb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/chipsfb.c
--- a/drivers/video/chipsfb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/chipsfb.c
@@ -460,10 +460,10 @@ static int chipsfb_pci_suspend(struct pc
 	if (!(state.event & PM_EVENT_SLEEP))
 		goto done;
 
-	acquire_console_sem();
+	console_lock();
 	chipsfb_blank(1, p);
 	fb_set_suspend(p, 1);
-	release_console_sem();
+	console_unlock();
  done:
 	pdev->dev.power.power_state = state;
 	return 0;
@@ -473,10 +473,10 @@ static int chipsfb_pci_resume(struct pci
 {
         struct fb_info *p = pci_get_drvdata(pdev);
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(p, 0);
 	chipsfb_blank(0, p);
-	release_console_sem();
+	console_unlock();
 
 	pdev->dev.power.power_state = PMSG_ON;
 	return 0;
diff -puN drivers/video/console/fbcon.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/console/fbcon.c
@@ -375,14 +375,14 @@ static void fb_flashcursor(struct work_s
 	int c;
 	int mode;
 
-	acquire_console_sem();
+	console_lock();
 	if (ops && ops->currcon != -1)
 		vc = vc_cons[ops->currcon].d;
 
 	if (!vc || !CON_IS_VISIBLE(vc) ||
  	    registered_fb[con2fb_map[vc->vc_num]] != info ||
 	    vc->vc_deccm != 1) {
-		release_console_sem();
+		console_unlock();
 		return;
 	}
 
@@ -392,7 +392,7 @@ static void fb_flashcursor(struct work_s
 		CM_ERASE : CM_DRAW;
 	ops->cursor(vc, info, mode, softback_lines, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
-	release_console_sem();
+	console_unlock();
 }
 
 static void cursor_timer_handler(unsigned long dev_addr)
@@ -836,7 +836,7 @@ static int set_con2fb_map(int unit, int 
 
 	found = search_fb_in_map(newidx);
 
-	acquire_console_sem();
+	console_lock();
 	con2fb_map[unit] = newidx;
 	if (!err && !found)
  		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
@@ -863,7 +863,7 @@ static int set_con2fb_map(int unit, int 
 	if (!search_fb_in_map(info_idx))
 		info_idx = newidx;
 
-	release_console_sem();
+	console_unlock();
  	return err;
 }
 
@@ -3321,7 +3321,7 @@ static ssize_t store_rotate(struct devic
 	if (fbcon_has_exited)
 		return count;
 
-	acquire_console_sem();
+	console_lock();
 	idx = con2fb_map[fg_console];
 
 	if (idx == -1 || registered_fb[idx] == NULL)
@@ -3331,7 +3331,7 @@ static ssize_t store_rotate(struct devic
 	rotate = simple_strtoul(buf, last, 0);
 	fbcon_rotate(info, rotate);
 err:
-	release_console_sem();
+	console_unlock();
 	return count;
 }
 
@@ -3346,7 +3346,7 @@ static ssize_t store_rotate_all(struct d
 	if (fbcon_has_exited)
 		return count;
 
-	acquire_console_sem();
+	console_lock();
 	idx = con2fb_map[fg_console];
 
 	if (idx == -1 || registered_fb[idx] == NULL)
@@ -3356,7 +3356,7 @@ static ssize_t store_rotate_all(struct d
 	rotate = simple_strtoul(buf, last, 0);
 	fbcon_rotate_all(info, rotate);
 err:
-	release_console_sem();
+	console_unlock();
 	return count;
 }
 
@@ -3369,7 +3369,7 @@ static ssize_t show_rotate(struct device
 	if (fbcon_has_exited)
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 	idx = con2fb_map[fg_console];
 
 	if (idx == -1 || registered_fb[idx] == NULL)
@@ -3378,7 +3378,7 @@ static ssize_t show_rotate(struct device
 	info = registered_fb[idx];
 	rotate = fbcon_get_rotate(info);
 err:
-	release_console_sem();
+	console_unlock();
 	return snprintf(buf, PAGE_SIZE, "%d\n", rotate);
 }
 
@@ -3392,7 +3392,7 @@ static ssize_t show_cursor_blink(struct 
 	if (fbcon_has_exited)
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 	idx = con2fb_map[fg_console];
 
 	if (idx == -1 || registered_fb[idx] == NULL)
@@ -3406,7 +3406,7 @@ static ssize_t show_cursor_blink(struct 
 
 	blink = (ops->flags & FBCON_FLAGS_CURSOR_TIMER) ? 1 : 0;
 err:
-	release_console_sem();
+	console_unlock();
 	return snprintf(buf, PAGE_SIZE, "%d\n", blink);
 }
 
@@ -3421,7 +3421,7 @@ static ssize_t store_cursor_blink(struct
 	if (fbcon_has_exited)
 		return count;
 
-	acquire_console_sem();
+	console_lock();
 	idx = con2fb_map[fg_console];
 
 	if (idx == -1 || registered_fb[idx] == NULL)
@@ -3443,7 +3443,7 @@ static ssize_t store_cursor_blink(struct
 	}
 
 err:
-	release_console_sem();
+	console_unlock();
 	return count;
 }
 
@@ -3482,7 +3482,7 @@ static void fbcon_start(void)
 	if (num_registered_fb) {
 		int i;
 
-		acquire_console_sem();
+		console_lock();
 
 		for (i = 0; i < FB_MAX; i++) {
 			if (registered_fb[i] != NULL) {
@@ -3491,7 +3491,7 @@ static void fbcon_start(void)
 			}
 		}
 
-		release_console_sem();
+		console_unlock();
 		fbcon_takeover(0);
 	}
 }
@@ -3552,7 +3552,7 @@ static int __init fb_console_init(void)
 {
 	int i;
 
-	acquire_console_sem();
+	console_lock();
 	fb_register_client(&fbcon_event_notifier);
 	fbcon_device = device_create(fb_class, NULL, MKDEV(0, 0), NULL,
 				     "fbcon");
@@ -3568,7 +3568,7 @@ static int __init fb_console_init(void)
 	for (i = 0; i < MAX_NR_CONSOLES; i++)
 		con2fb_map[i] = -1;
 
-	release_console_sem();
+	console_unlock();
 	fbcon_start();
 	return 0;
 }
@@ -3591,12 +3591,12 @@ static void __exit fbcon_deinit_device(v
 
 static void __exit fb_console_exit(void)
 {
-	acquire_console_sem();
+	console_lock();
 	fb_unregister_client(&fbcon_event_notifier);
 	fbcon_deinit_device();
 	device_destroy(fb_class, MKDEV(0, 0));
 	fbcon_exit();
-	release_console_sem();
+	console_unlock();
 	unregister_con_driver(&fb_con);
 }	
 
diff -puN drivers/video/da8xx-fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/da8xx-fb.c
@@ -1130,14 +1130,14 @@ static int fb_suspend(struct platform_de
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct da8xx_fb_par *par = info->par;
 
-	acquire_console_sem();
+	console_lock();
 	if (par->panel_power_ctrl)
 		par->panel_power_ctrl(0);
 
 	fb_set_suspend(info, 1);
 	lcd_disable_raster();
 	clk_disable(par->lcdc_clk);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -1146,14 +1146,14 @@ static int fb_resume(struct platform_dev
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct da8xx_fb_par *par = info->par;
 
-	acquire_console_sem();
+	console_lock();
 	if (par->panel_power_ctrl)
 		par->panel_power_ctrl(1);
 
 	clk_enable(par->lcdc_clk);
 	lcd_enable_raster();
 	fb_set_suspend(info, 0);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/video/fbmem.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/fbmem.c
@@ -1036,11 +1036,11 @@ static long do_fb_ioctl(struct fb_info *
 			return -EFAULT;
 		if (!lock_fb_info(info))
 			return -ENODEV;
-		acquire_console_sem();
+		console_lock();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
-		release_console_sem();
+		console_unlock();
 		unlock_fb_info(info);
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
 			ret = -EFAULT;
@@ -1072,9 +1072,9 @@ static long do_fb_ioctl(struct fb_info *
 			return -EFAULT;
 		if (!lock_fb_info(info))
 			return -ENODEV;
-		acquire_console_sem();
+		console_lock();
 		ret = fb_pan_display(info, &var);
-		release_console_sem();
+		console_unlock();
 		unlock_fb_info(info);
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
 			return -EFAULT;
@@ -1119,11 +1119,11 @@ static long do_fb_ioctl(struct fb_info *
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
 			return -ENODEV;
-		acquire_console_sem();
+		console_lock();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
-		release_console_sem();
+		console_unlock();
 		unlock_fb_info(info);
 		break;
 	default:
diff -puN drivers/video/fbsysfs.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/fbsysfs.c
@@ -90,11 +90,11 @@ static int activate(struct fb_info *fb_i
 	int err;
 
 	var->activate |= FB_ACTIVATE_FORCE;
-	acquire_console_sem();
+	console_lock();
 	fb_info->flags |= FBINFO_MISC_USEREVENT;
 	err = fb_set_var(fb_info, var);
 	fb_info->flags &= ~FBINFO_MISC_USEREVENT;
-	release_console_sem();
+	console_unlock();
 	if (err)
 		return err;
 	return 0;
@@ -175,7 +175,7 @@ static ssize_t store_modes(struct device
 	if (i * sizeof(struct fb_videomode) != count)
 		return -EINVAL;
 
-	acquire_console_sem();
+	console_lock();
 	list_splice(&fb_info->modelist, &old_list);
 	fb_videomode_to_modelist((const struct fb_videomode *)buf, i,
 				 &fb_info->modelist);
@@ -185,7 +185,7 @@ static ssize_t store_modes(struct device
 	} else
 		fb_destroy_modelist(&old_list);
 
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -301,11 +301,11 @@ static ssize_t store_blank(struct device
 	char *last = NULL;
 	int err;
 
-	acquire_console_sem();
+	console_lock();
 	fb_info->flags |= FBINFO_MISC_USEREVENT;
 	err = fb_blank(fb_info, simple_strtoul(buf, &last, 0));
 	fb_info->flags &= ~FBINFO_MISC_USEREVENT;
-	release_console_sem();
+	console_unlock();
 	if (err < 0)
 		return err;
 	return count;
@@ -364,9 +364,9 @@ static ssize_t store_pan(struct device *
 		return -EINVAL;
 	var.yoffset = simple_strtoul(last, &last, 0);
 
-	acquire_console_sem();
+	console_lock();
 	err = fb_pan_display(fb_info, &var);
-	release_console_sem();
+	console_unlock();
 
 	if (err < 0)
 		return err;
@@ -399,9 +399,9 @@ static ssize_t store_fbstate(struct devi
 
 	state = simple_strtoul(buf, &last, 0);
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(fb_info, (int)state);
-	release_console_sem();
+	console_unlock();
 
 	return count;
 }
diff -puN drivers/video/geode/gxfb_core.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/geode/gxfb_core.c
@@ -344,10 +344,10 @@ static int gxfb_suspend(struct pci_dev *
 	struct fb_info *info = pci_get_drvdata(pdev);
 
 	if (state.event == PM_EVENT_SUSPEND) {
-		acquire_console_sem();
+		console_lock();
 		gx_powerdown(info);
 		fb_set_suspend(info, 1);
-		release_console_sem();
+		console_unlock();
 	}
 
 	/* there's no point in setting PCI states; we emulate PCI, so
@@ -361,7 +361,7 @@ static int gxfb_resume(struct pci_dev *p
 	struct fb_info *info = pci_get_drvdata(pdev);
 	int ret;
 
-	acquire_console_sem();
+	console_lock();
 	ret = gx_powerup(info);
 	if (ret) {
 		printk(KERN_ERR "gxfb:  power up failed!\n");
@@ -369,7 +369,7 @@ static int gxfb_resume(struct pci_dev *p
 	}
 
 	fb_set_suspend(info, 0);
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 #endif
diff -puN drivers/video/geode/lxfb_core.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/geode/lxfb_core.c
@@ -465,10 +465,10 @@ static int lxfb_suspend(struct pci_dev *
 	struct fb_info *info = pci_get_drvdata(pdev);
 
 	if (state.event == PM_EVENT_SUSPEND) {
-		acquire_console_sem();
+		console_lock();
 		lx_powerdown(info);
 		fb_set_suspend(info, 1);
-		release_console_sem();
+		console_unlock();
 	}
 
 	/* there's no point in setting PCI states; we emulate PCI, so
@@ -482,7 +482,7 @@ static int lxfb_resume(struct pci_dev *p
 	struct fb_info *info = pci_get_drvdata(pdev);
 	int ret;
 
-	acquire_console_sem();
+	console_lock();
 	ret = lx_powerup(info);
 	if (ret) {
 		printk(KERN_ERR "lxfb:  power up failed!\n");
@@ -490,7 +490,7 @@ static int lxfb_resume(struct pci_dev *p
 	}
 
 	fb_set_suspend(info, 0);
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 #else
diff -puN drivers/video/i810/i810_main.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/i810/i810_main.c
@@ -1574,7 +1574,7 @@ static int i810fb_suspend(struct pci_dev
 		return 0;
 	}
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(info, 1);
 
 	if (info->fbops->fb_sync)
@@ -1587,7 +1587,7 @@ static int i810fb_suspend(struct pci_dev
 	pci_save_state(dev);
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, mesg));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -1605,7 +1605,7 @@ static int i810fb_resume(struct pci_dev 
 		return 0;
 	}
 
-	acquire_console_sem();
+	console_lock();
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
 
@@ -1621,7 +1621,7 @@ static int i810fb_resume(struct pci_dev 
 	fb_set_suspend (info, 0);
 	info->fbops->fb_blank(VESA_NO_BLANKING, info);
 fail:
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 /***********************************************************************
diff -puN drivers/video/jz4740_fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/jz4740_fb.c
--- a/drivers/video/jz4740_fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/jz4740_fb.c
@@ -778,9 +778,9 @@ static int jzfb_suspend(struct device *d
 {
 	struct jzfb *jzfb = dev_get_drvdata(dev);
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(jzfb->fb, 1);
-	release_console_sem();
+	console_unlock();
 
 	mutex_lock(&jzfb->lock);
 	if (jzfb->is_enabled)
@@ -800,9 +800,9 @@ static int jzfb_resume(struct device *de
 		jzfb_enable(jzfb);
 	mutex_unlock(&jzfb->lock);
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(jzfb->fb, 0);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/video/mx3fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/mx3fb.c
@@ -1177,9 +1177,9 @@ static int mx3fb_suspend(struct platform
 	struct mx3fb_data *mx3fb = platform_get_drvdata(pdev);
 	struct mx3fb_info *mx3_fbi = mx3fb->fbi->par;
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(mx3fb->fbi, 1);
-	release_console_sem();
+	console_unlock();
 
 	if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
 		sdc_disable_channel(mx3_fbi);
@@ -1202,9 +1202,9 @@ static int mx3fb_resume(struct platform_
 		sdc_set_brightness(mx3fb, mx3fb->backlight_level);
 	}
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(mx3fb->fbi, 0);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/video/nvidia/nvidia.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/nvidia/nvidia.c
@@ -1057,7 +1057,7 @@ static int nvidiafb_suspend(struct pci_d
 
 	if (mesg.event == PM_EVENT_PRETHAW)
 		mesg.event = PM_EVENT_FREEZE;
-	acquire_console_sem();
+	console_lock();
 	par->pm_state = mesg.event;
 
 	if (mesg.event & PM_EVENT_SLEEP) {
@@ -1070,7 +1070,7 @@ static int nvidiafb_suspend(struct pci_d
 	}
 	dev->dev.power.power_state = mesg;
 
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 
@@ -1079,7 +1079,7 @@ static int nvidiafb_resume(struct pci_de
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct nvidia_par *par = info->par;
 
-	acquire_console_sem();
+	console_lock();
 	pci_set_power_state(dev, PCI_D0);
 
 	if (par->pm_state != PM_EVENT_FREEZE) {
@@ -1097,7 +1097,7 @@ static int nvidiafb_resume(struct pci_de
 	nvidiafb_blank(FB_BLANK_UNBLANK, info);
 
 fail:
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 #else
diff -puN drivers/video/ps3fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/ps3fb.c
@@ -513,9 +513,9 @@ static int ps3fb_release(struct fb_info 
 	if (atomic_dec_and_test(&ps3fb.f_count)) {
 		if (atomic_read(&ps3fb.ext_flip)) {
 			atomic_set(&ps3fb.ext_flip, 0);
-			if (!try_acquire_console_sem()) {
+			if (console_trylock()) {
 				ps3fb_sync(info, 0);	/* single buffer */
-				release_console_sem();
+				console_unlock();
 			}
 		}
 	}
@@ -830,14 +830,14 @@ static int ps3fb_ioctl(struct fb_info *i
 			if (vmode) {
 				var = info->var;
 				fb_videomode_to_var(&var, vmode);
-				acquire_console_sem();
+				console_lock();
 				info->flags |= FBINFO_MISC_USEREVENT;
 				/* Force, in case only special bits changed */
 				var.activate |= FB_ACTIVATE_FORCE;
 				par->new_mode_id = val;
 				retval = fb_set_var(info, &var);
 				info->flags &= ~FBINFO_MISC_USEREVENT;
-				release_console_sem();
+				console_unlock();
 			}
 			break;
 		}
@@ -881,9 +881,9 @@ static int ps3fb_ioctl(struct fb_info *i
 			break;
 
 		dev_dbg(info->device, "PS3FB_IOCTL_FSEL:%d\n", val);
-		acquire_console_sem();
+		console_lock();
 		retval = ps3fb_sync(info, val);
-		release_console_sem();
+		console_unlock();
 		break;
 
 	default:
@@ -903,9 +903,9 @@ static int ps3fbd(void *arg)
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (ps3fb.is_kicked) {
 			ps3fb.is_kicked = 0;
-			acquire_console_sem();
+			console_lock();
 			ps3fb_sync(info, 0);	/* single buffer */
-			release_console_sem();
+			console_unlock();
 		}
 		schedule();
 	}
diff -puN drivers/video/s3fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/s3fb.c
@@ -22,7 +22,7 @@
 #include <linux/svga.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/console.h> /* Why should fb driver call console functions? because acquire_console_sem() */
+#include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */
 #include <video/vga.h>
 
 #ifdef CONFIG_MTRR
@@ -1113,12 +1113,12 @@ static int s3_pci_suspend(struct pci_dev
 
 	dev_info(info->device, "suspend\n");
 
-	acquire_console_sem();
+	console_lock();
 	mutex_lock(&(par->open_lock));
 
 	if ((state.event == PM_EVENT_FREEZE) || (par->ref_count == 0)) {
 		mutex_unlock(&(par->open_lock));
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 
@@ -1129,7 +1129,7 @@ static int s3_pci_suspend(struct pci_dev
 	pci_set_power_state(dev, pci_choose_state(dev, state));
 
 	mutex_unlock(&(par->open_lock));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -1145,12 +1145,12 @@ static int s3_pci_resume(struct pci_dev*
 
 	dev_info(info->device, "resume\n");
 
-	acquire_console_sem();
+	console_lock();
 	mutex_lock(&(par->open_lock));
 
 	if (par->ref_count == 0) {
 		mutex_unlock(&(par->open_lock));
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 
@@ -1159,7 +1159,7 @@ static int s3_pci_resume(struct pci_dev*
 	err = pci_enable_device(dev);
 	if (err) {
 		mutex_unlock(&(par->open_lock));
-		release_console_sem();
+		console_unlock();
 		dev_err(info->device, "error %d enabling device for resume\n", err);
 		return err;
 	}
@@ -1169,7 +1169,7 @@ static int s3_pci_resume(struct pci_dev*
 	fb_set_suspend(info, 0);
 
 	mutex_unlock(&(par->open_lock));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/video/savage/savagefb_driver.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/savage/savagefb_driver.c
@@ -2373,7 +2373,7 @@ static int savagefb_suspend(struct pci_d
 	if (mesg.event == PM_EVENT_FREEZE)
 		return 0;
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(info, 1);
 
 	if (info->fbops->fb_sync)
@@ -2385,7 +2385,7 @@ static int savagefb_suspend(struct pci_d
 	pci_save_state(dev);
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, mesg));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -2409,7 +2409,7 @@ static int savagefb_resume(struct pci_de
 		return 0;
 	}
 
-	acquire_console_sem();
+	console_lock();
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -2423,7 +2423,7 @@ static int savagefb_resume(struct pci_de
 	savagefb_set_par(info);
 	fb_set_suspend(info, 0);
 	savagefb_blank(FB_BLANK_UNBLANK, info);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/video/sh_mobile_hdmi.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/sh_mobile_hdmi.c
--- a/drivers/video/sh_mobile_hdmi.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/sh_mobile_hdmi.c
@@ -1151,7 +1151,7 @@ static void sh_hdmi_edid_work_fn(struct 
 
 		ch = info->par;
 
-		acquire_console_sem();
+		console_lock();
 
 		/* HDMI plug in */
 		if (!sh_hdmi_must_reconfigure(hdmi) &&
@@ -1171,7 +1171,7 @@ static void sh_hdmi_edid_work_fn(struct 
 			fb_set_suspend(info, 0);
 		}
 
-		release_console_sem();
+		console_unlock();
 	} else {
 		ret = 0;
 		if (!hdmi->info)
@@ -1181,12 +1181,12 @@ static void sh_hdmi_edid_work_fn(struct 
 		fb_destroy_modedb(hdmi->monspec.modedb);
 		hdmi->monspec.modedb = NULL;
 
-		acquire_console_sem();
+		console_lock();
 
 		/* HDMI disconnect */
 		fb_set_suspend(hdmi->info, 1);
 
-		release_console_sem();
+		console_unlock();
 		pm_runtime_put(hdmi->dev);
 	}
 
diff -puN drivers/video/sh_mobile_lcdcfb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/sh_mobile_lcdcfb.c
--- a/drivers/video/sh_mobile_lcdcfb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/sh_mobile_lcdcfb.c
@@ -912,9 +912,9 @@ static int sh_mobile_release(struct fb_i
 
 	/* Nothing to reconfigure, when called from fbcon */
 	if (user) {
-		acquire_console_sem();
+		console_lock();
 		sh_mobile_fb_reconfig(info);
-		release_console_sem();
+		console_unlock();
 	}
 
 	mutex_unlock(&ch->open_lock);
diff -puN drivers/video/sm501fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/sm501fb.c
@@ -2010,9 +2010,9 @@ static int sm501fb_suspend_fb(struct sm5
 
 	/* tell console/fb driver we are suspending */
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(fbi, 1);
-	release_console_sem();
+	console_unlock();
 
 	/* backup copies in case chip is powered down over suspend */
 
@@ -2069,9 +2069,9 @@ static void sm501fb_resume_fb(struct sm5
 		memcpy_toio(par->cursor.k_addr, par->store_cursor,
 			    par->cursor.size);
 
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(fbi, 0);
-	release_console_sem();
+	console_unlock();
 
 	vfree(par->store_fb);
 	vfree(par->store_cursor);
diff -puN drivers/video/tmiofb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/tmiofb.c
--- a/drivers/video/tmiofb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/tmiofb.c
@@ -25,7 +25,7 @@
 #include <linux/fb.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-/* Why should fb driver call console functions? because acquire_console_sem() */
+/* Why should fb driver call console functions? because console_lock() */
 #include <linux/console.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tmio.h>
@@ -944,7 +944,7 @@ static int tmiofb_suspend(struct platfor
 	struct mfd_cell *cell = dev->dev.platform_data;
 	int retval = 0;
 
-	acquire_console_sem();
+	console_lock();
 
 	fb_set_suspend(info, 1);
 
@@ -965,7 +965,7 @@ static int tmiofb_suspend(struct platfor
 	if (cell->suspend)
 		retval = cell->suspend(dev);
 
-	release_console_sem();
+	console_unlock();
 
 	return retval;
 }
@@ -976,7 +976,7 @@ static int tmiofb_resume(struct platform
 	struct mfd_cell *cell = dev->dev.platform_data;
 	int retval = 0;
 
-	acquire_console_sem();
+	console_lock();
 
 	if (cell->resume) {
 		retval = cell->resume(dev);
@@ -992,7 +992,7 @@ static int tmiofb_resume(struct platform
 
 	fb_set_suspend(info, 0);
 out:
-	release_console_sem();
+	console_unlock();
 	return retval;
 }
 #else
diff -puN drivers/video/via/viafbdev.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/via/viafbdev.c
@@ -1674,17 +1674,17 @@ static int parse_mode(const char *str, u
 #ifdef CONFIG_PM
 static int viafb_suspend(void *unused)
 {
-	acquire_console_sem();
+	console_lock();
 	fb_set_suspend(viafbinfo, 1);
 	viafb_sync(viafbinfo);
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
 
 static int viafb_resume(void *unused)
 {
-	acquire_console_sem();
+	console_lock();
 	if (viaparinfo->shared->vdev->engine_mmio)
 		viafb_reset_engine(viaparinfo);
 	viafb_set_par(viafbinfo);
@@ -1692,7 +1692,7 @@ static int viafb_resume(void *unused)
 		viafb_set_par(viafbinfo1);
 	fb_set_suspend(viafbinfo, 0);
 
-	release_console_sem();
+	console_unlock();
 	return 0;
 }
 
diff -puN drivers/video/vt8623fb.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/vt8623fb.c
@@ -23,7 +23,7 @@
 #include <linux/svga.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/console.h> /* Why should fb driver call console functions? because acquire_console_sem() */
+#include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */
 #include <video/vga.h>
 
 #ifdef CONFIG_MTRR
@@ -819,12 +819,12 @@ static int vt8623_pci_suspend(struct pci
 
 	dev_info(info->device, "suspend\n");
 
-	acquire_console_sem();
+	console_lock();
 	mutex_lock(&(par->open_lock));
 
 	if ((state.event == PM_EVENT_FREEZE) || (par->ref_count == 0)) {
 		mutex_unlock(&(par->open_lock));
-		release_console_sem();
+		console_unlock();
 		return 0;
 	}
 
@@ -835,7 +835,7 @@ static int vt8623_pci_suspend(struct pci
 	pci_set_power_state(dev, pci_choose_state(dev, state));
 
 	mutex_unlock(&(par->open_lock));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
@@ -850,7 +850,7 @@ static int vt8623_pci_resume(struct pci_
 
 	dev_info(info->device, "resume\n");
 
-	acquire_console_sem();
+	console_lock();
 	mutex_lock(&(par->open_lock));
 
 	if (par->ref_count == 0)
@@ -869,7 +869,7 @@ static int vt8623_pci_resume(struct pci_
 
 fail:
 	mutex_unlock(&(par->open_lock));
-	release_console_sem();
+	console_unlock();
 
 	return 0;
 }
diff -puN drivers/video/xen-fbfront.c~change-acquire-release_console_sem-to-console_lock-unlock drivers/video/xen-fbfront.c
--- a/drivers/video/xen-fbfront.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/drivers/video/xen-fbfront.c
@@ -491,12 +491,12 @@ xenfb_make_preferred_console(void)
 	if (console_set_on_cmdline)
 		return;
 
-	acquire_console_sem();
+	console_lock();
 	for_each_console(c) {
 		if (!strcmp(c->name, "tty") && c->index == 0)
 			break;
 	}
-	release_console_sem();
+	console_unlock();
 	if (c) {
 		unregister_console(c);
 		c->flags |= CON_CONSDEV;
diff -puN fs/proc/consoles.c~change-acquire-release_console_sem-to-console_lock-unlock fs/proc/consoles.c
--- a/fs/proc/consoles.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/fs/proc/consoles.c
@@ -67,7 +67,7 @@ static void *c_start(struct seq_file *m,
 	struct console *con;
 	loff_t off = 0;
 
-	acquire_console_sem();
+	console_lock();
 	for_each_console(con)
 		if (off++ == *pos)
 			break;
@@ -84,7 +84,7 @@ static void *c_next(struct seq_file *m, 
 
 static void c_stop(struct seq_file *m, void *v)
 {
-	release_console_sem();
+	console_unlock();
 }
 
 static const struct seq_operations consoles_op = {
diff -puN include/linux/console.h~change-acquire-release_console_sem-to-console_lock-unlock include/linux/console.h
--- a/include/linux/console.h~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/include/linux/console.h
@@ -139,9 +139,9 @@ extern int update_console_cmdline(char *
 extern void register_console(struct console *);
 extern int unregister_console(struct console *);
 extern struct console *console_drivers;
-extern void acquire_console_sem(void);
-extern int try_acquire_console_sem(void);
-extern void release_console_sem(void);
+extern void console_lock(void);
+extern int console_trylock(void);
+extern void console_unlock(void);
 extern void console_conditional_schedule(void);
 extern void console_unblank(void);
 extern struct tty_driver *console_device(int *);
diff -puN kernel/printk.c~change-acquire-release_console_sem-to-console_lock-unlock kernel/printk.c
--- a/kernel/printk.c~change-acquire-release_console_sem-to-console_lock-unlock
+++ a/kernel/printk.c
@@ -97,7 +97,7 @@ static int console_locked, console_suspe
 /*
  * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
  * It is also used in interesting ways to provide interlocking in
- * release_console_sem().
+ * console_unlock();.
  */
 static DEFINE_SPINLOCK(logbuf_lock);
 
@@ -501,7 +501,7 @@ static void _call_console_drivers(unsign
 /*
  * Call the console drivers, asking them to write out
  * log_buf[start] to log_buf[end - 1].
- * The console_sem must be held.
+ * The console_lock must be held.
  */
 static void call_console_drivers(unsigned start, unsigned end)
 {
@@ -604,11 +604,11 @@ static int have_callable_console(void)
  *
  * This is printk().  It can be called from any context.  We want it to work.
  *
- * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
+ * We try to grab the console_lock.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
  * into the log buffer and return.  The current holder of the console_sem will
- * notice the new output in release_console_sem() and will send it to the
- * consoles before releasing the semaphore.
+ * notice the new output in console_unlock(); and will send it to the
+ * consoles before releasing the lock.
  *
  * One effect of this deferred printing is that code which calls printk() and
  * then changes console_loglevel may break. This is because console_loglevel
@@ -659,19 +659,19 @@ static inline int can_use_console(unsign
 /*
  * Try to get console ownership to actually show the kernel
  * messages from a 'printk'. Return true (and with the
- * console_semaphore held, and 'console_locked' set) if it
+ * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  *
  * This gets called with the 'logbuf_lock' spinlock held and
  * interrupts disabled. It should return with 'lockbuf_lock'
  * released but interrupts still disabled.
  */
-static int acquire_console_semaphore_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(unsigned int cpu)
 	__releases(&logbuf_lock)
 {
 	int retval = 0;
 
-	if (!try_acquire_console_sem()) {
+	if (console_trylock()) {
 		retval = 1;
 
 		/*
@@ -827,12 +827,12 @@ asmlinkage int vprintk(const char *fmt, 
 	 * actual magic (print out buffers, wake up klogd,
 	 * etc). 
 	 *
-	 * The acquire_console_semaphore_for_printk() function
+	 * The console_trylock_for_printk() function
 	 * will release 'logbuf_lock' regardless of whether it
 	 * actually gets the semaphore or not.
 	 */
-	if (acquire_console_semaphore_for_printk(this_cpu))
-		release_console_sem();
+	if (console_trylock_for_printk(this_cpu))
+		console_unlock();
 
 	lockdep_on();
 out_restore_irqs:
@@ -993,7 +993,7 @@ void suspend_console(void)
 	if (!console_suspend_enabled)
 		return;
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
-	acquire_console_sem();
+	console_lock();;
 	console_suspended = 1;
 	up(&console_sem);
 }
@@ -1004,7 +1004,7 @@ void resume_console(void)
 		return;
 	down(&console_sem);
 	console_suspended = 0;
-	release_console_sem();
+	console_unlock();
 }
 
 /**
@@ -1027,21 +1027,21 @@ static int __cpuinit console_cpu_notify(
 	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
-		acquire_console_sem();
-		release_console_sem();
+		console_lock();;
+		console_unlock();
 	}
 	return NOTIFY_OK;
 }
 
 /**
- * acquire_console_sem - lock the console system for exclusive use.
+ * console_lock - lock the console system for exclusive use.
  *
- * Acquires a semaphore which guarantees that the caller has
+ * Acquires a lock which guarantees that the caller has
  * exclusive access to the console system and the console_drivers list.
  *
  * Can sleep, returns nothing.
  */
-void acquire_console_sem(void)
+void console_lock(void)
 {
 	BUG_ON(in_interrupt());
 	down(&console_sem);
@@ -1050,21 +1050,29 @@ void acquire_console_sem(void)
 	console_locked = 1;
 	console_may_schedule = 1;
 }
-EXPORT_SYMBOL(acquire_console_sem);
+EXPORT_SYMBOL(console_lock);
 
-int try_acquire_console_sem(void)
+/**
+ * console_trylock - try to lock the console system for exclusive use.
+ *
+ * Tried to acquire a lock which guarantees that the caller has
+ * exclusive access to the console system and the console_drivers list.
+ *
+ * returns -1 on success, and 0 on failure to acquire the lock.
+ */
+int console_trylock(void)
 {
 	if (down_trylock(&console_sem))
-		return -1;
+		return 0;
 	if (console_suspended) {
 		up(&console_sem);
-		return -1;
+		return 0;
 	}
 	console_locked = 1;
 	console_may_schedule = 0;
-	return 0;
+	return -1;
 }
-EXPORT_SYMBOL(try_acquire_console_sem);
+EXPORT_SYMBOL(console_trylock);
 
 int is_console_locked(void)
 {
@@ -1095,20 +1103,20 @@ void wake_up_klogd(void)
 }
 
 /**
- * release_console_sem - unlock the console system
+ * console_unlock - unlock the console system
  *
- * Releases the semaphore which the caller holds on the console system
+ * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the semaphore was held, console output may have been buffered
- * by printk().  If this is the case, release_console_sem() emits
- * the output prior to releasing the semaphore.
+ * While the console_lock was held, console output may have been buffered
+ * by printk().  If this is the case, console_unlock(); emits
+ * the output prior to releasing the lock.
  *
  * If there is output waiting for klogd, we wake it up.
  *
- * release_console_sem() may be called from any context.
+ * console_unlock(); may be called from any context.
  */
-void release_console_sem(void)
+void console_unlock(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
@@ -1141,7 +1149,7 @@ void release_console_sem(void)
 	if (wake_klogd)
 		wake_up_klogd();
 }
-EXPORT_SYMBOL(release_console_sem);
+EXPORT_SYMBOL(console_unlock);
 
 /**
  * console_conditional_schedule - yield the CPU if required
@@ -1150,7 +1158,7 @@ EXPORT_SYMBOL(release_console_sem);
  * if this CPU should yield the CPU to another task, do
  * so here.
  *
- * Must be called within acquire_console_sem().
+ * Must be called within console_lock();.
  */
 void __sched console_conditional_schedule(void)
 {
@@ -1171,14 +1179,14 @@ void console_unblank(void)
 		if (down_trylock(&console_sem) != 0)
 			return;
 	} else
-		acquire_console_sem();
+		console_lock();
 
 	console_locked = 1;
 	console_may_schedule = 0;
 	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
 			c->unblank();
-	release_console_sem();
+	console_unlock();
 }
 
 /*
@@ -1189,7 +1197,7 @@ struct tty_driver *console_device(int *i
 	struct console *c;
 	struct tty_driver *driver = NULL;
 
-	acquire_console_sem();
+	console_lock();
 	for_each_console(c) {
 		if (!c->device)
 			continue;
@@ -1197,7 +1205,7 @@ struct tty_driver *console_device(int *i
 		if (driver)
 			break;
 	}
-	release_console_sem();
+	console_unlock();
 	return driver;
 }
 
@@ -1208,17 +1216,17 @@ struct tty_driver *console_device(int *i
  */
 void console_stop(struct console *console)
 {
-	acquire_console_sem();
+	console_lock();
 	console->flags &= ~CON_ENABLED;
-	release_console_sem();
+	console_unlock();
 }
 EXPORT_SYMBOL(console_stop);
 
 void console_start(struct console *console)
 {
-	acquire_console_sem();
+	console_lock();
 	console->flags |= CON_ENABLED;
-	release_console_sem();
+	console_unlock();
 }
 EXPORT_SYMBOL(console_start);
 
@@ -1340,7 +1348,7 @@ void register_console(struct console *ne
 	 *	Put this console in the list - keep the
 	 *	preferred driver at the head of the list.
 	 */
-	acquire_console_sem();
+	console_lock();
 	if ((newcon->flags & CON_CONSDEV) || console_drivers == NULL) {
 		newcon->next = console_drivers;
 		console_drivers = newcon;
@@ -1352,14 +1360,14 @@ void register_console(struct console *ne
 	}
 	if (newcon->flags & CON_PRINTBUFFER) {
 		/*
-		 * release_console_sem() will print out the buffered messages
+		 * console_unlock(); will print out the buffered messages
 		 * for us.
 		 */
 		spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
-	release_console_sem();
+	console_unlock();
 	console_sysfs_notify();
 
 	/*
@@ -1396,7 +1404,7 @@ int unregister_console(struct console *c
 		return braille_unregister_console(console);
 #endif
 
-	acquire_console_sem();
+	console_lock();
 	if (console_drivers == console) {
 		console_drivers=console->next;
 		res = 0;
@@ -1418,7 +1426,7 @@ int unregister_console(struct console *c
 	if (console_drivers != NULL && console->flags & CON_CONSDEV)
 		console_drivers->flags |= CON_CONSDEV;
 
-	release_console_sem();
+	console_unlock();
 	console_sysfs_notify();
 	return res;
 }
_

Patches currently in -mm which might be from torbenh@gmx.de are

change-acquire-release_console_sem-to-console_lock-unlock.patch

