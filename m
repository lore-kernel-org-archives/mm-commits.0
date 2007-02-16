From: akpm@linux-foundation.org
Subject: - hil-fix-improper-call-of-release_region-v2.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:57 -0800
Message-ID: <200702160802.l1G82vUC023967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58788 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423392AbXBPIDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:03:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, deller@gmx.de, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     HIL: fix improper call of release_region v2
has been removed from the -mm tree.  Its filename was
     hil-fix-improper-call-of-release_region-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HIL: fix improper call of release_region v2
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

Thist patch prevents from improper call of release_region
if the code has been compiled without CONFIG_HP300 support.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Acked-by: Helge Deller <deller@gmx.de>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/hilkbd.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/input/keyboard/hilkbd.c~hil-fix-improper-call-of-release_region-v2 drivers/input/keyboard/hilkbd.c
--- a/drivers/input/keyboard/hilkbd.c~hil-fix-improper-call-of-release_region-v2
+++ a/drivers/input/keyboard/hilkbd.c
@@ -294,8 +294,10 @@ err3:
 	disable_irq(HIL_IRQ);
 	free_irq(HIL_IRQ, hil_dev.dev_id);
 err2:
+#if defined(CONFIG_HP300)
 	release_region(HILBASE + HIL_DATA, 2);
 err1:
+#endif
 	input_free_device(hil_dev.dev);
 	hil_dev.dev = NULL;
 	return err;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-input.patch
