From: akpm@linux-foundation.org
Subject: + mpt-fusion-shut-up-uninitialized-variable.patch added to -mm tree
Date: Wed, 19 Sep 2007 23:21:48 -0700
Message-ID: <200709200621.l8K6LmKw031789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbXITGWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 02:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, eric.moore@lsi.com


The patch titled
     mpt fusion: shut up uninitialized variable  warnings
has been added to the -mm tree.  Its filename is
     mpt-fusion-shut-up-uninitialized-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: mpt fusion: shut up uninitialized variable  warnings


drivers/message/fusion/mptctl.c: In function =E2=80=98mptctl_mpt_comman=
d=E2=80=99:
drivers/message/fusion/mptctl.c:1764: warning: =E2=80=98bufIn.len=E2=80=
=99 may be used uninitialized in this function
drivers/message/fusion/mptctl.c:1765: warning: =E2=80=98bufOut.len=E2=80=
=99 may be used uninitialized in this function

come because gcc gets confused by some "goto" statements in above funct=
ion.
 The warnings have been verified to be bogus, however, the function doe=
s
initialize these later (after the offending goto's) in the function any=
way.
 So let's move those initializations to top of function, thereby also
shutting up these warnings.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Eric Moore <eric.moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptctl.c~mpt-fusion-shut-up-uninitiali=
zed-variable drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~mpt-fusion-shut-up-uninitialized-=
variable
+++ a/drivers/message/fusion/mptctl.c
@@ -1774,7 +1774,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
=20
+	/* bufIn and bufOut are used for user to kernel space transfers
+	 */
 	bufIn.kptr =3D bufOut.kptr =3D NULL;
+	bufIn.len =3D bufOut.len =3D 0;
=20
 	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc =3D=3D NULL)) {
@@ -2108,11 +2111,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	psge =3D (char *) (((int *) mf) + karg.dataSgeOffset);
 	flagsLength =3D 0;
=20
-	/* bufIn and bufOut are used for user to kernel space transfers
-	 */
-	bufIn.kptr =3D bufOut.kptr =3D NULL;
-	bufIn.len =3D bufOut.len =3D 0;
-
 	if (karg.dataOutSize > 0)
 		sgSize ++;
=20
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
drivers-char-nozomic-__devexit_p-usage-build-fix.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-net.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
mpt-fusion-shut-up-uninitialized-variable.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
i386-cpuid_count-fix-argument-signedness-warnings.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-g=
racefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-fo=
r-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
