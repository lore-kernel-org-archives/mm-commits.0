From: akpm@linux-foundation.org
Subject: [merged] hwlat-depend-on-ring_buffer.patch removed from -mm tree
Date: Mon, 29 Jun 2009 11:54:42 -0700
Message-ID: <200906291854.n5TIsga7000569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbZF2Sze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 14:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jcm@jonmasters.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hwlat: depend on RING_BUFFER
has been removed from the -mm tree.  Its filename was
     hwlat-depend-on-ring_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwlat: depend on RING_BUFFER
From: Randy Dunlap <randy.dunlap@oracle.com>

hwlat_detector.c:(.text+0x8d906): undefined reference to `ring_buffer_reset'
hwlat_detector.c:(.text+0x8d98c): undefined reference to `ring_buffer_free'
hwlat_detector.c:(.text+0x8dd16): undefined reference to `__ring_buffer_alloc'
hwlat_detector.c:(.text+0x8df15): undefined reference to `ring_buffer_free'
hwlat_detector.c:(.text+0x8e100): undefined reference to `ring_buffer_write'
hwlat_detector.c:(.text+0x8e239): undefined reference to `ring_buffer_consume'
hwlat_detector.c:(.text+0x8e2ac): undefined reference to `ring_buffer_event_data'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jon Masters <jcm@jonmasters.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~hwlat-depend-on-ring_buffer drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~hwlat-depend-on-ring_buffer
+++ a/drivers/misc/Kconfig
@@ -79,6 +79,7 @@ config IBM_ASM
 config HWLAT_DETECTOR
 	tristate "Testing module to detect hardware-induced latencies"
 	depends on DEBUG_FS
+	depends on RING_BUFFER
 	default m
 	---help---
 	  A simple hardware latency detector. Use this module to detect
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch

