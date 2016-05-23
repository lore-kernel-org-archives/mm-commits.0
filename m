From: akpm@linux-foundation.org
Subject: [patch 54/84] scripts/gdb: provide a dentry_name VFS path helper
Date: Mon, 23 May 2016 16:24:53 -0700
Message-ID: <57439145.c+qV9K7VbPlH2UOk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com

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
