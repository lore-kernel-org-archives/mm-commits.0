From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-read_u16-32-64-helpers.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:44:05 -0800
Message-ID: <54e4eb85.WamhpwzfA+48XuZC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRToG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add read_u16/32/64 helpers
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-read_u16-32-64-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add read_u16/32/64 helpers

Add helpers for reading integers from target memory buffers.  Required
when caching the memory access is more efficient than reading individual
values via gdb.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-add-read_u16-32-64-helpers scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-add-read_u16-32-64-helpers
+++ a/scripts/gdb/linux/utils.py
@@ -85,3 +85,24 @@ def get_target_endianness():
         else:
             raise gdb.GdgError("unknown endianness '{0}'".format(endian))
     return target_endianness
+
+
+def read_u16(buffer):
+    if get_target_endianness() == LITTLE_ENDIAN:
+        return ord(buffer[0]) + (ord(buffer[1]) << 8)
+    else:
+        return ord(buffer[1]) + (ord(buffer[0]) << 8)
+
+
+def read_u32(buffer):
+    if get_target_endianness() == LITTLE_ENDIAN:
+        return read_u16(buffer[0:2]) + (read_u16(buffer[2:4]) << 16)
+    else:
+        return read_u16(buffer[2:4]) + (read_u16(buffer[0:2]) << 16)
+
+
+def read_u64(buffer):
+    if get_target_endianness() == LITTLE_ENDIAN:
+        return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
+    else:
+        return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

