From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-get_target_endianness-helper.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:03 -0800
Message-ID: <54e4eb83.RbCOOvf7ln2ZJMn9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRToE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add get_target_endianness helper
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-get_target_endianness-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add get_target_endianness helper

Parse the target endianness from the output of "show endian" and cache the
result to return it via the new helper get_target_endiannes.  We will need
it for reading integers from buffers that contain target memory.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-add-get_target_endianness-helper scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-add-get_target_endianness-helper
+++ a/scripts/gdb/linux/utils.py
@@ -67,3 +67,21 @@ Note that TYPE and ELEMENT have to be qu
                             elementname.string())
 
 ContainerOf()
+
+
+BIG_ENDIAN = 0
+LITTLE_ENDIAN = 1
+target_endianness = None
+
+
+def get_target_endianness():
+    global target_endianness
+    if target_endianness is None:
+        endian = gdb.execute("show endian", to_string=True)
+        if "little endian" in endian:
+            target_endianness = LITTLE_ENDIAN
+        elif "big endian" in endian:
+            target_endianness = BIG_ENDIAN
+        else:
+            raise gdb.GdgError("unknown endianness '{0}'".format(endian))
+    return target_endianness
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

