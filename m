From: akpm@linux-foundation.org
Subject: - mpt-fusion-shut-up-uninitialized-variable.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:15 -0700
Message-ID: <200710051958.l95JwFoY022533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763236AbXJEUBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, eric.moore@lsi.com, mm-commits@vger.kernel.org


The patch titled
     mpt fusion: shut up uninitialized variable  warnings
has been removed from the -mm tree.  Its filename was
     mpt-fusion-shut-up-uninitialized-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mpt fusion: shut up uninitialized variable  warnings


drivers/message/fusion/mptctl.c: In function `mptctl_mpt_command':
drivers/message/fusion/mptctl.c:1764: warning: `bufIn.len' may be used uninitialized in this function
drivers/message/fusion/mptctl.c:1765: warning: `bufOut.len' may be used uninitialized in this function

come because gcc gets confused by some "goto" statements in above function.
 The warnings have been verified to be bogus, however, the function does
initialize these later (after the offending goto's) in the function anyway.
 So let's move those initializations to top of function, thereby also
shutting up these warnings.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Eric Moore <eric.moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptctl.c~mpt-fusion-shut-up-uninitialized-variable drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~mpt-fusion-shut-up-uninitialized-variable
+++ a/drivers/message/fusion/mptctl.c
@@ -1774,7 +1774,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
 
+	/* bufIn and bufOut are used for user to kernel space transfers
+	 */
 	bufIn.kptr = bufOut.kptr = NULL;
+	bufIn.len = bufOut.len = 0;
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
@@ -2108,11 +2111,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	psge = (char *) (((int *) mf) + karg.dataSgeOffset);
 	flagsLength = 0;
 
-	/* bufIn and bufOut are used for user to kernel space transfers
-	 */
-	bufIn.kptr = bufOut.kptr = NULL;
-	bufIn.len = bufOut.len = 0;
-
 	if (karg.dataOutSize > 0)
 		sgSize ++;
 
_

Patches currently in -mm which might be from satyam@infradead.org are

git-cpufreq.patch
git-powerpc.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
git-infiniband.patch
git-libata-all.patch
git-net.patch
git-s390.patch
git-scsi-misc.patch
git-block.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
