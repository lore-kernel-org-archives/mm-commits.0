From: akpm@linux-foundation.org
Subject: - ps3-vuart-fix-error-path-locking.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:16 -0800
Message-ID: <200801072138.m07LcuXi013514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYAGVjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, geoffrey.levand@am.sony.com, mm-commits@vger.kernel.org


The patch titled
     ps3: vuart: fix error path locking
has been removed from the -mm tree.  Its filename was
     ps3-vuart-fix-error-path-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ps3: vuart: fix error path locking
From: Daniel Walker <dwalker@mvista.com>

This stray down would cause a permanent sleep which doesn't seem correct. 
The other uses of this semaphore appear fairly mutex like it's even
initialized with init_MUTEX() ..  So here a patch for removing this one
down().

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3-vuart.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/ps3/ps3-vuart.c~ps3-vuart-fix-error-path-locking drivers/ps3/ps3-vuart.c
--- a/drivers/ps3/ps3-vuart.c~ps3-vuart-fix-error-path-locking
+++ a/drivers/ps3/ps3-vuart.c
@@ -1074,7 +1074,6 @@ static int ps3_vuart_probe(struct ps3_sy
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: drv->probe failed\n",
 			__func__, __LINE__);
-		down(&vuart_bus_priv.probe_mutex);
 		goto fail_probe;
 	}
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
prism54-remove-questionable-down_interruptible-usage.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
docs-convert-kref-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
