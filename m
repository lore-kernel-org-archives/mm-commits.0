From: akpm@linux-foundation.org
Subject: + scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch added
 to -mm tree
Date: Tue, 10 May 2016 12:34:26 -0700
Message-ID: <573237c2.Q+F/STrzEwxO5Yk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcEJTe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: provide a dentry_name VFS path helper
has been added to the -mm tree.  Its filename is
     scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-provide-linux-constants.patch
scripts-gdb-provide-kernel-list-item-generators.patch
scripts-gdb-convert-modules-usage-to-lists-functions.patch
scripts-gdb-provide-exception-catching-parser.patch
scripts-gdb-support-config_modules-gracefully.patch
scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch
scripts-gdb-add-io-resource-readers.patch
scripts-gdb-add-mount-point-list-command.patch
scripts-gdb-add-cpu-iterators.patch
scripts-gdb-add-a-radix-tree-parser.patch
scripts-gdb-add-documentation-example-for-radix-tree.patch
scripts-gdb-add-lx_thread_info_by_pid-helper.patch

