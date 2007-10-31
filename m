From: akpm@linux-foundation.org
Subject: - arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended.patch removed from -mm tree
Date: Wed, 31 Oct 2007 16:21:58 -0700
Message-ID: <200710312321.l9VNLwRx001915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727AbXJaXWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 19:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, jes@trained-monkey.org, rja@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64/sn/kernel/mca.c: undo lock when sn_oemdata can't be extended
has been removed from the -mm tree.  Its filename was
     arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/ia64/sn/kernel/mca.c: undo lock when sn_oemdata can't be extended
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/mca.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/sn/kernel/mca.c~arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended arch/ia64/sn/kernel/mca.c
--- a/arch/ia64/sn/kernel/mca.c~arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended
+++ a/arch/ia64/sn/kernel/mca.c
@@ -98,6 +98,7 @@ sn_platform_plat_specific_err_print(cons
 	while (*sn_oemdata_size > sn_oemdata_bufsize) {
 		u8 *newbuf = vmalloc(*sn_oemdata_size);
 		if (!newbuf) {
+			mutex_unlock(&sn_oemdata_mutex);
 			printk(KERN_ERR "%s: unable to extend sn_oemdata\n",
 			       __FUNCTION__);
 			return 1;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
i4l-errors-with-assignments-in-if.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
git-watchdog.patch
cris-gpio-undo-locks-before-returning.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
