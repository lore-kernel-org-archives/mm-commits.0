From: akpm@linux-foundation.org
Subject: [merged] memory_accessor-new-interface-for-reading-writing-persistent-memory.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:15 -0700
Message-ID: <200904061933.n36JXFLP011058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757520AbZDFTgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@deeprootsystems.com, dbrownell@users.sourceforge.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     memory_accessor: new interface for reading/writing persistent memory
has been removed from the -mm tree.  Its filename was
     memory_accessor-new-interface-for-reading-writing-persistent-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_accessor: new interface for reading/writing persistent memory
From: Kevin Hilman <khilman@deeprootsystems.com>

Add an interface by which other kernel code can read/write persistent
memory such as I2C or SPI EEPROMs, or devices which provide NVRAM.  Use
cases include storage of board-specific configuration data like Ethernet
addresses and sensor calibrations.

Original idea, review and improvement suggestions by David Brownell.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/memory.h~memory_accessor-new-interface-for-reading-writing-persistent-memory include/linux/memory.h
--- a/include/linux/memory.h~memory_accessor-new-interface-for-reading-writing-persistent-memory
+++ a/include/linux/memory.h
@@ -99,4 +99,15 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+/*
+ * 'struct memory_accessor' is a generic interface to provide
+ * in-kernel access to persistent memory such as i2c or SPI EEPROMs
+ */
+struct memory_accessor {
+	ssize_t (*read)(struct memory_accessor *, char *buf, off_t offset,
+			size_t count);
+	ssize_t (*write)(struct memory_accessor *, const char *buf,
+			 off_t offset, size_t count);
+};
+
 #endif /* _LINUX_MEMORY_H_ */
_

Patches currently in -mm which might be from khilman@deeprootsystems.com are

origin.patch
linux-next.patch

