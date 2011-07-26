From: akpm@linux-foundation.org
Subject: [folded] ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:59:05 -0700
Message-ID: <201107262259.p6QMx5Fw014742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab1GZW7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com, stevie.trujillo@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ramoops-use-module-parameters-instead-of-platform-data-if-not-avai=
lable-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ramoops-use-module-parameters-instead-of-platform-data-if-not-avai=
lable-checkpatch-fixes.patch

This patch was dropped because it was folded into ramoops-use-module-pa=
rameters-instead-of-platform-data-if-not-available.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ramoops-use-module-parameters-instead-of-platform-data-if-not-=
available-checkpatch-fixes
=46rom: Andrew Morton <akpm@linux-foundation.org>

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF=
-8
#10:=20
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
      ^

ERROR: that open brace { should be on the previous line
#81: FILE: drivers/char/ramoops.c:182:
+	if (ret =3D=3D -ENODEV)
+	{

ERROR: trailing whitespace
#83: FILE: drivers/char/ramoops.c:184:
+^I^I/* $

ERROR: trailing whitespace
#97: FILE: drivers/char/ramoops.c:198:
+^I^Iif (IS_ERR(dummy)) $

ERROR: trailing whitespace
#102: FILE: drivers/char/ramoops.c:203:
+^I$

total: 5 errors, 0 warnings, 87 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatc=
h or
      scripts/cleanfile

=2E/patches/ramoops-use-module-parameters-instead-of-platform-data-if-n=
ot-available.patch has style problems, please review.  If any of these =
errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-use-module-parameters-instead-=
of-platform-data-if-not-available-checkpatch-fixes drivers/char/ramoops=
=2Ec
--- a/drivers/char/ramoops.c~ramoops-use-module-parameters-instead-of-p=
latform-data-if-not-available-checkpatch-fixes
+++ a/drivers/char/ramoops.c
@@ -179,10 +179,9 @@ static int __init ramoops_init(void)
 {
 	int ret;
 	ret =3D platform_driver_probe(&ramoops_driver, ramoops_probe);
-	if (ret =3D=3D -ENODEV)
-	{
+	if (ret =3D=3D -ENODEV) {
 		/*
-		 * if we didn't find a platform device, we use module parameters
+		 * If we didn't find a platform device, we use module parameters
 		 * building platform data on the fly.
 		 */
 		dummy_data =3D kzalloc(sizeof(struct ramoops_platform_data),
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available=
=2Epatch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
