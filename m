From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 26 Jul 2011 00:51:15 -0700
Message-ID: <201107260750.p6Q7oIsQ002894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab1GZHuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:50:51 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p6Q7oIvL014202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2011 00:50:18 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    3 --
 arch/powerpc/Kconfig                       |    3 --
 arch/powerpc/platforms/85xx/p1022_ds.c     |    6 -----
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |   21 -------------------
 drivers/cpufreq/Makefile                   |    3 --
 drivers/staging/gma500/mrst_hdmi.c         |    4 ---
 drivers/staging/tm6000/tm6000-alsa.c       |    8 -------
 7 files changed, 48 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~linux-next-git-rejects Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~linux-next-git-rejects
+++ a/Documentation/feature-removal-schedule.txt
@@ -556,8 +556,6 @@ Who:	Hans Verkuil <hans.verkuil@cisco.co
 
 ----------------------------
 
-<<<<<<< HEAD
-=======
 What:	Support for driver specific ioctls in the pwc driver (everything
 	defined in media/pwc-ioctl.h)
 When:	3.3
@@ -628,7 +626,6 @@ Who:    Lee, Chun-Yi <jlee@novell.com>
 
 ----------------------------
 
->>>>>>> linux-next/akpm-end
 What:	g_file_storage driver
 When:	3.8
 Why:	This driver has been superseded by g_mass_storage.
diff -puN arch/powerpc/Kconfig~linux-next-git-rejects arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~linux-next-git-rejects
+++ a/arch/powerpc/Kconfig
@@ -136,10 +136,7 @@ config PPC
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
-<<<<<<< HEAD
-=======
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
->>>>>>> linux-next/akpm-end
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/platforms/85xx/p1022_ds.c~linux-next-git-rejects arch/powerpc/platforms/85xx/p1022_ds.c
--- a/arch/powerpc/platforms/85xx/p1022_ds.c~linux-next-git-rejects
+++ a/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -212,12 +212,6 @@ void p1022ds_set_pixel_clock(unsigned in
 
 	/* Enable the clock and set the pxclk */
 	setbits32(&guts->clkdvdr, CLKDVDR_PXCKEN | (pxclk << 16));
-<<<<<<< HEAD
-
-	iounmap(guts);
-}
-=======
->>>>>>> linux-next/akpm-end
 
 	iounmap(guts);
 }
diff -puN arch/powerpc/platforms/86xx/mpc8610_hpcd.c~linux-next-git-rejects arch/powerpc/platforms/86xx/mpc8610_hpcd.c
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c~linux-next-git-rejects
+++ a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -249,27 +249,6 @@ void mpc8610hpcd_set_pixel_clock(unsigne
 	temp = 1000000000000ULL;
 	do_div(temp, pixclock);
 	freq = temp;
-<<<<<<< HEAD
-
-	/*
-	 * 'pxclk' is the ratio of the platform clock to the pixel clock.
-	 * On the MPC8610, the value programmed into CLKDVDR is the ratio
-	 * minus one.  The valid range of values is 2-31.
-	 */
-	pxclk = DIV_ROUND_CLOSEST(fsl_get_sys_freq(), freq) - 1;
-	pxclk = clamp_t(u32, pxclk, 2, 31);
-
-	/* Disable the pixel clock, and set it to non-inverted and no delay */
-	clrbits32(&guts->clkdvdr,
-		  CLKDVDR_PXCKEN | CLKDVDR_PXCKDLY | CLKDVDR_PXCLK_MASK);
-
-	/* Enable the clock and set the pxclk */
-	setbits32(&guts->clkdvdr, CLKDVDR_PXCKEN | (pxclk << 16));
-
-	iounmap(guts);
-}
-=======
->>>>>>> linux-next/akpm-end
 
 	/*
 	 * 'pxclk' is the ratio of the platform clock to the pixel clock.
diff -puN drivers/cpufreq/Makefile~linux-next-git-rejects drivers/cpufreq/Makefile
--- a/drivers/cpufreq/Makefile~linux-next-git-rejects
+++ a/drivers/cpufreq/Makefile
@@ -44,10 +44,7 @@ obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c
 obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
 
-<<<<<<< HEAD
-=======
 
->>>>>>> linux-next/akpm-end
 ##################################################################################
 # PowerPC platform drivers
 obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
diff -puN drivers/staging/gma500/mrst_hdmi.c~linux-next-git-rejects drivers/staging/gma500/mrst_hdmi.c
--- a/drivers/staging/gma500/mrst_hdmi.c~linux-next-git-rejects
+++ a/drivers/staging/gma500/mrst_hdmi.c
@@ -129,11 +129,7 @@ static void wait_for_vblank(struct drm_d
 {
 	/* FIXME: Can we do this as a sleep ? */
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
-<<<<<<< HEAD
-	udelay(20000);
-=======
 	mdelay(20);
->>>>>>> linux-next/akpm-end
 }
 
 static void scu_busy_loop(void *scu_base)
diff -puN drivers/staging/tm6000/tm6000-alsa.c~linux-next-git-rejects drivers/staging/tm6000/tm6000-alsa.c
--- a/drivers/staging/tm6000/tm6000-alsa.c~linux-next-git-rejects
+++ a/drivers/staging/tm6000/tm6000-alsa.c
@@ -254,13 +254,9 @@ static int tm6000_fillbuf(struct tm6000_
 		memcpy(runtime->dma_area + buf_pos * stride, buf,
 			length * stride);
 
-<<<<<<< HEAD
 #ifndef NO_PCM_LOCK
 	snd_pcm_stream_lock(substream);
 #endif
-=======
-	snd_pcm_stream_lock(substream);
->>>>>>> linux-next/akpm-end
 
 	chip->buf_pos += length;
 	if (chip->buf_pos >= runtime->buffer_size)
@@ -272,13 +268,9 @@ static int tm6000_fillbuf(struct tm6000_
 		period_elapsed = 1;
 	}
 
-<<<<<<< HEAD
 #ifndef NO_PCM_LOCK
 	snd_pcm_stream_unlock(substream);
 #endif
-=======
-	snd_pcm_stream_unlock(substream);
->>>>>>> linux-next/akpm-end
 
 	if (period_elapsed)
 		snd_pcm_period_elapsed(substream);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

