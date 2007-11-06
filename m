From: akpm@linux-foundation.org
Subject: - virtio-virtcons-fix-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:23 -0800
Message-ID: <200711060552.lA65qNb0007297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbXKFFzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     virtio/virtcons: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     virtio-virtcons-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: virtio/virtcons: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Make virtcons_probe() __devinit.
Fixes this section warning:

WARNING: vmlinux.o(.text+0x14c10b): Section mismatch: reference to .init.text:hvc_alloc (between 'virtcons_probe' and 'ac_register_board')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/virtio_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/virtio_console.c~virtio-virtcons-fix-section-mismatch-warning drivers/char/virtio_console.c
--- a/drivers/char/virtio_console.c~virtio-virtcons-fix-section-mismatch-warning
+++ a/drivers/char/virtio_console.c
@@ -141,7 +141,7 @@ int __init virtio_cons_early_init(int (*
  * never remove the console device we never need this pointer again.
  *
  * Finally we put our input buffer in the input queue, ready to receive. */
-static int virtcons_probe(struct virtio_device *dev)
+static int __devinit virtcons_probe(struct virtio_device *dev)
 {
 	int err;
 	struct hvc_struct *hvc;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
hostap-fix-section-mismatch-warning.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
