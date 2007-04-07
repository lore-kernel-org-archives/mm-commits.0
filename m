From: akpm@linux-foundation.org
Subject: + cris-remove-code-related-to-pre-22-kernel.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:26:26 -0700
Message-ID: <200704072226.l37MQQpD011295@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965992AbXDGW03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:26:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     CRIS: remove code related to pre-2.2 kernel
has been added to the -mm tree.  Its filename is
     cris-remove-code-related-to-pre-22-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS: remove code related to pre-2.2 kernel
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove conditionals and code related to checking for a pre-2.2 kernel.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/kernel/fasttimer.c |   30 +-----------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff -puN arch/cris/arch-v32/kernel/fasttimer.c~cris-remove-code-related-to-pre-22-kernel arch/cris/arch-v32/kernel/fasttimer.c
--- a/arch/cris/arch-v32/kernel/fasttimer.c~cris-remove-code-related-to-pre-22-kernel
+++ a/arch/cris/arch-v32/kernel/fasttimer.c
@@ -603,23 +603,8 @@ void schedule_usleep(unsigned long us)
 
 #ifdef CONFIG_PROC_FS
 static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-                       ,int *eof, void *data_unused
-#else
-                        ,int unused
-#endif
-                               );
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
+                       ,int *eof, void *data_unused);
 static struct proc_dir_entry *fasttimer_proc_entry;
-#else
-static struct proc_dir_entry fasttimer_proc_entry =
-{
-  0, 9, "fasttimer",
-  S_IFREG | S_IRUGO, 1, 0, 0,
-  0, NULL /* ops -- default to array */,
-  &proc_fasttimer_read /* get_info */,
-};
-#endif
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_PROC_FS
@@ -628,12 +613,7 @@ static struct proc_dir_entry fasttimer_p
 #define BIG_BUF_SIZE (500 + NUM_TIMER_STATS * 300)
 
 static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-                       ,int *eof, void *data_unused
-#else
-                        ,int unused
-#endif
-                               )
+                       ,int *eof, void *data_unused)
 {
   unsigned long flags;
   int i = 0;
@@ -808,9 +788,7 @@ static int proc_fasttimer_read(char *buf
 
   memcpy(buf, bigbuf + offset, len);
   *start = buf;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
   *eof = 1;
-#endif
 
   return len;
 }
@@ -974,12 +952,8 @@ void fast_timer_init(void)
     printk("fast_timer_init()\n");
 
 #ifdef CONFIG_PROC_FS
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
    if ((fasttimer_proc_entry = create_proc_entry( "fasttimer", 0, 0 )))
      fasttimer_proc_entry->read_proc = proc_fasttimer_read;
-#else
-    proc_register_dynamic(&proc_root, &fasttimer_proc_entry);
-#endif
 #endif /* PROC_FS */
     if(request_irq(TIMER_INTR_VECT, timer_trig_interrupt, IRQF_DISABLED,
                    "fast timer int", NULL))
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-input.patch
git-mtd.patch
git-netdev-all.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
