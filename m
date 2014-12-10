From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-ds1374-add-watchdog-support-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:22:46 -0800
Message-ID: <5488d5c6.p1Fkz8GJGtIwG29M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaLJXWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, dan.carpenter@oracle.com, san@rosetechnology.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ds1374-add-watchdog-support-fix
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-add-watchdog-support-fix.patch

This patch was dropped because it was folded into rtc-ds1374-add-watchd=
og-support.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-ds1374-add-watchdog-support-fix

don't forget mutex_unlock() in ds1374_wdt_open() error path

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Soeren Andersen <san@rosetechnology.dk>
Cc: S=F8ren Andersen <san@rosetechnology.dk>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-ds1374-add-watchdog-support-fix drive=
rs/rtc/Kconfig
diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support-fix =
drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support-fix
+++ a/drivers/rtc/rtc-ds1374.c
@@ -458,8 +458,10 @@ static int ds1374_wdt_open(struct inode
=20
 	if (MINOR(inode->i_rdev) =3D=3D WATCHDOG_MINOR) {
 		mutex_lock(&ds1374->mutex);
-		if (test_and_set_bit(0, &wdt_is_open))
+		if (test_and_set_bit(0, &wdt_is_open)) {
+			mutex_unlock(&ds1374->mutex);
 			return -EBUSY;
+		}
 		/*
 		 *      Activate
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patc=
h
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
fs-proc-use-a-rb-tree-for-the-directory-entries.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=3Dn-to-disable-defaults-if-init=3D-fail=
s.patch
rtc-omap-add-support-for-pmic_power_en.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support.patch
rtc-ds1374-add-watchdog-support.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
