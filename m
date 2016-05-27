From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:44:08 -0700
Message-ID: <57489578.aQAO+PmO9+ObxaPs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbcE0SoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: provide a dentry_name VFS path helper
has been removed from the -mm tree.  Its filename was
     scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: provide a dentry_name VFS path helper

Walk the VFS entries, pre-pending the iname strings to generate a full
VFS path name from a dentry.

Link: http://lkml.kernel.org/r/4328fdb2d15ba7f1b21ad21c2eecc38d9cfc4d13.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-provide-a-dentry_name-vfs-path-helper scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-provide-a-dentry_name-vfs-path-helper
+++ a/scripts/gdb/linux/utils.py
@@ -161,3 +161,11 @@ def gdb_eval_or_none(expresssion):
         return gdb.parse_and_eval(expresssion)
     except:
         return None
+
+
+def dentry_name(d):
+    parent = d['d_parent']
+    if parent == d or parent == 0:
+        return ""
+    p = dentry_name(d['d_parent']) + "/"
+    return p + d['d_iname'].string()
_

Patches currently in -mm which might be from kieran.bingham@linaro.org are


