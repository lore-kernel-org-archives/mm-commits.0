From: akpm@linux-foundation.org
Subject: - drivers-char-rtcc-make-2-functions-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:20 -0700
Message-ID: <200807262118.m6QLIKJo020082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758042AbYGZVSc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bwalle@suse.de, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/rtc.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     drivers-char-rtcc-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -144,6 +144,7 @@ static ssize_t rtc_read(struct file *fil
 			size_t count, loff_t *ppos);
 
 static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static void rtc_get_rtc_time(struct rtc_time *rtc_tm);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
@@ -235,7 +236,7 @@ static inline unsigned char rtc_is_updat
  *	(See ./arch/XXXX/kernel/time.c for the set_rtc_mmss() function.)
  */
 
-irqreturn_t rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t rtc_interrupt(int irq, void *dev_id)
 {
 	/*
 	 *	Can be an alarm interrupt, update complete interrupt,
@@ -1303,7 +1304,7 @@ static int rtc_proc_open(struct inode *i
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
@@ -225,8 +225,6 @@ typedef struct rtc_task {
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
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

