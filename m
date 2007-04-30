From: akpm@linux-foundation.org
Subject: - move-die-notifier-handling-to-common-code-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:48:24 -0700
Message-ID: <200704301948.l3UJmOVV013349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031581AbXD3TyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, ak@suse.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     move die notifier handling to common code fix vmalloc_sync_all in nommu
has been removed from the -mm tree.  Its filename was
     move-die-notifier-handling-to-common-code-fix.patch

This patch was dropped because it was folded into move-die-notifier-handling-to-common-code.patch

------------------------------------------------------
Subject: move die notifier handling to common code fix vmalloc_sync_all in nommu
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/nommu.c~move-die-notifier-handling-to-common-code-fix mm/nommu.c
--- a/mm/nommu.c~move-die-notifier-handling-to-common-code-fix
+++ a/mm/nommu.c
@@ -262,6 +262,14 @@ void vunmap(void *addr)
 }
 
 /*
+ * Implement a stub for vmalloc_sync_all() if the architecture chose not to
+ * have one.
+ */
+void  __attribute__((weak)) vmalloc_sync_all(void)
+{
+}
+
+/*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
  *  like trying to un-brk an area that has already been mapped
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
move-die-notifier-handling-to-common-code.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
