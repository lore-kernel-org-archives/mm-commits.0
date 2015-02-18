From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-is_target_arch-helper.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:14 -0800
Message-ID: <54e4eb8e.ivs6npjIfmEqd12/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbbBRToP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add is_target_arch helper
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-is_target_arch-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add is_target_arch helper

This helper caches to result of "show architecture" and matches the
provided arch (sub-)string against that output.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-add-is_target_arch-helper scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-add-is_target_arch-helper
+++ a/scripts/gdb/linux/utils.py
@@ -106,3 +106,16 @@ def read_u64(buffer):
         return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
     else:
         return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
+
+
+target_arch = None
+
+
+def is_target_arch(arch):
+    if hasattr(gdb.Frame, 'architecture'):
+        return arch in gdb.newest_frame().architecture().name()
+    else:
+        global target_arch
+        if target_arch is None:
+            target_arch = gdb.execute("show architecture", to_string=True)
+        return arch in target_arch
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

