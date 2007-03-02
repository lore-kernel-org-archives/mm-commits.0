From: akpm@linux-foundation.org
Subject: - frv-missing-error-defs.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:00 -0800
Message-ID: <200703020507.l22570Jv000844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42369 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422757AbXCBFHO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Missing error defs
has been removed from the -mm tree.  Its filename was
     frv-missing-error-defs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: Missing error defs
From: David Howells <dhowells@redhat.com>

linux/irq.h uses EINVAL but does not #include linux/errno.h.  This results in
the compiler spitting out errors on some files.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/irq.h~frv-missing-error-defs include/linux/irq.h
--- a/include/linux/irq.h~frv-missing-error-defs
+++ a/include/linux/irq.h
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/irqreturn.h>
+#include <linux/errno.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
