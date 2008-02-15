From: akpm@linux-foundation.org
Subject: - hvc_rtas_init-must-be-__init.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:17:23 -0500
Message-ID: <200802150720.m1F7Kj7l025851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbYBOH2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hvc_rtas_init() must be __init
has been removed from the -mm tree.  Its filename was
     hvc_rtas_init-must-be-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hvc_rtas_init() must be __init
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x2fbca8): Section mismatch in reference from the function .hvc_rtas_init() to the function .devinit.text:.hvc_alloc()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_rtas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hvc_rtas.c~hvc_rtas_init-must-be-__init drivers/char/hvc_rtas.c
--- a/drivers/char/hvc_rtas.c~hvc_rtas_init-must-be-__init
+++ a/drivers/char/hvc_rtas.c
@@ -76,7 +76,7 @@ static struct hv_ops hvc_rtas_get_put_op
 	.put_chars = hvc_rtas_write_console,
 };
 
-static int hvc_rtas_init(void)
+static int __init hvc_rtas_init(void)
 {
 	struct hvc_struct *hp;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-net.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
sparc-fix-build.patch
reiser4.patch
