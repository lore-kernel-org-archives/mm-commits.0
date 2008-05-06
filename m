From: akpm@linux-foundation.org
Subject: + drivers-char-rtcc-make-2-functions-static.patch added to -mm tree
Date: Tue, 06 May 2008 11:37:04 -0700
Message-ID: <200805061837.m46Ib4RU021273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbYEFShU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bwalle@suse.de, p_gortmaker@yahoo.com


The patch titled
     drivers/char/rtc.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     drivers-char-rtcc-make-2-functions-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/rtc.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

The following functions can now become static:
- rtc_interrupt()
- rtc_get_rtc_time()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Bernhard Walle <bwalle@suse.de>
Acked-by: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c  |    5 +++--
 include/linux/rtc.h |    2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/char/rtc.c~drivers-char-rtcc-make-2-functions-static drivers/char/rtc.c
--- a/drivers/char/rtc.c~drivers-char-rtcc-make-2-functions-static
+++ a/drivers/char/rtc.c
@@ -145,6 +145,7 @@ static ssize_t rtc_read(struct file *fil
 
 static int rtc_ioctl(struct inode *inode, struct file *file,
 		     unsigned int cmd, unsigned long arg);
+static void rtc_get_rtc_time(struct rtc_time *rtc_tm);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
@@ -236,7 +237,7 @@ static inline unsigned char rtc_is_updat
  *	(See ./arch/XXXX/kernel/time.c for the set_rtc_mmss() function.)
  */
 
-irqreturn_t rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t rtc_interrupt(int irq, void *dev_id)
 {
 	/*
 	 *	Can be an alarm interrupt, update complete interrupt,
@@ -1297,7 +1298,7 @@ static int rtc_proc_open(struct inode *i
 }
 #endif
 
-void rtc_get_rtc_time(struct rtc_time *rtc_tm)
+static void rtc_get_rtc_time(struct rtc_time *rtc_tm)
 {
 	unsigned long uip_watchdog = jiffies, flags;
 	unsigned char ctrl;
diff -puN include/linux/rtc.h~drivers-char-rtcc-make-2-functions-static include/linux/rtc.h
--- a/include/linux/rtc.h~drivers-char-rtcc-make-2-functions-static
+++ a/include/linux/rtc.h
@@ -208,8 +208,6 @@ typedef struct rtc_task {
 int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
-void rtc_get_rtc_time(struct rtc_time *rtc_tm);
-irqreturn_t rtc_interrupt(int irq, void *dev_id);
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

