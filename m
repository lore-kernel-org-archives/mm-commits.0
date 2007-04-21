From: akpm@linux-foundation.org
Subject: + the-scheduled-einval-for-invalid-timevals-in-setitimer.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:10:03 -0700
Message-ID: <200704210010.l3L0A5FM027040@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbXDUAKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     The scheduled -EINVAL for invalid timevals in setitimer
has been added to the -mm tree.  Its filename is
     the-scheduled-einval-for-invalid-timevals-in-setitimer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: The scheduled -EINVAL for invalid timevals in setitimer
From: Adrian Bunk <bunk@stusta.de>

As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   12 ---
 kernel/itimer.c                            |   59 -------------------
 2 files changed, 3 insertions(+), 68 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~the-scheduled-einval-for-invalid-timevals-in-setitimer Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~the-scheduled-einval-for-invalid-timevals-in-setitimer
+++ a/Documentation/feature-removal-schedule.txt
@@ -93,18 +93,6 @@ Who:    Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
-What:	Usage of invalid timevals in setitimer
-When:	March 2007
-Why:	POSIX requires to validate timevals in the setitimer call. This
-	was never done by Linux. The invalid (e.g. negative timevals) were
-	silently converted to more or less random timeouts and intervals.
-	Until the removal a per boot limited number of warnings is printed
-	and the timevals are sanitized.
-
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
 	(temporary transition config option provided until then)
 	The transition config option will also be removed at the same time.
diff -puN kernel/itimer.c~the-scheduled-einval-for-invalid-timevals-in-setitimer kernel/itimer.c
--- a/kernel/itimer.c~the-scheduled-einval-for-invalid-timevals-in-setitimer
+++ a/kernel/itimer.c
@@ -138,59 +138,11 @@ enum hrtimer_restart it_real_fn(struct h
 }
 
 /*
- * We do not care about correctness. We just sanitize the values so
- * the ktime_t operations which expect normalized values do not
- * break. This converts negative values to long timeouts similar to
- * the code in kernel versions < 2.6.16
- *
- * Print a limited number of warning messages when an invalid timeval
- * is detected.
- */
-static void fixup_timeval(struct timeval *tv, int interval)
-{
-	static int warnlimit = 10;
-	unsigned long tmp;
-
-	if (warnlimit > 0) {
-		warnlimit--;
-		printk(KERN_WARNING
-		       "setitimer: %s (pid = %d) provided "
-		       "invalid timeval %s: tv_sec = %ld tv_usec = %ld\n",
-		       current->comm, current->pid,
-		       interval ? "it_interval" : "it_value",
-		       tv->tv_sec, (long) tv->tv_usec);
-	}
-
-	tmp = tv->tv_usec;
-	if (tmp >= USEC_PER_SEC) {
-		tv->tv_usec = tmp % USEC_PER_SEC;
-		tv->tv_sec += tmp / USEC_PER_SEC;
-	}
-
-	tmp = tv->tv_sec;
-	if (tmp > LONG_MAX)
-		tv->tv_sec = LONG_MAX;
-}
-
-/*
  * Returns true if the timeval is in canonical form
  */
 #define timeval_valid(t) \
 	(((t)->tv_sec >= 0) && (((unsigned long) (t)->tv_usec) < USEC_PER_SEC))
 
-/*
- * Check for invalid timevals, sanitize them and print a limited
- * number of warnings.
- */
-static void check_itimerval(struct itimerval *value) {
-
-	if (unlikely(!timeval_valid(&value->it_value)))
-		fixup_timeval(&value->it_value, 0);
-
-	if (unlikely(!timeval_valid(&value->it_interval)))
-		fixup_timeval(&value->it_interval, 1);
-}
-
 int do_setitimer(int which, struct itimerval *value, struct itimerval *ovalue)
 {
 	struct task_struct *tsk = current;
@@ -200,15 +152,10 @@ int do_setitimer(int which, struct itime
 
 	/*
 	 * Validate the timevals in value.
-	 *
-	 * Note: Although the spec requires that invalid values shall
-	 * return -EINVAL, we just fixup the value and print a limited
-	 * number of warnings in order not to break users of this
-	 * historical misfeature.
-	 *
-	 * Scheduled for replacement in March 2007
 	 */
-	check_itimerval(value);
+	if (!timeval_valid(&value->it_value) ||
+	    !timeval_valid(&value->it_interval))
+		return -EINVAL;
 
 	switch (which) {
 	case ITIMER_REAL:
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-possible-cleanups.patch
fs-ocfs2-make-3-functions-static.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-wireless.patch
git-ipwireless_cs.patch
alsa-intel8x0-fix-oops-in-crash-kernel.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
maps2-add-proc-kpagemap-interface-fix.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
