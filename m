From: akpm@linux-foundation.org
Subject: + memory_accessor-new-interface-for-reading-writing-persistent-memory.patch added to -mm tree
Date: Mon, 30 Mar 2009 13:40:04 -0700
Message-ID: <200903302040.n2UKe4bS011153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720AbZC3Un2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 16:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@deeprootsystems.com, dbrownell@users.sourceforge.net, khali@linux-fr.org


The patch titled
     memory_accessor: new interface for reading/writing persistent memory
has been added to the -mm tree.  Its filename is
     memory_accessor-new-interface-for-reading-writing-persistent-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -105,4 +105,15 @@ enum mem_add_context { BOOT, HOTPLUG };
  */
 extern struct mutex text_mutex;
 
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
memory_accessor-new-interface-for-reading-writing-persistent-memory.patch
memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom.patch
memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms.patch

