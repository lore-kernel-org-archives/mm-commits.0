From: akpm@linux-foundation.org
Subject: + virtio-virtcons-fix-section-mismatch-warning.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:48:12 -0700
Message-ID: <200711012348.lA1NmCHn021841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbXKAXsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     virtio/virtcons: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     virtio-virtcons-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
rtc-m48t59-fix-section-mismatch-warning.patch
virtio-virtcons-fix-section-mismatch-warning.patch
git-dvb.patch
git-kbuild.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-watchdog.patch
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
