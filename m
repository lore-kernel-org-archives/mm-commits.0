Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F17C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjDRXmZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjDRXlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EDBD313
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FD2F62EE4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96C0C433EF;
        Tue, 18 Apr 2023 23:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861227;
        bh=A91bSvunEK/dmIWNNJIbbvP5WcOXzYjJO0/mq8/01N4=;
        h=Date:To:From:Subject:From;
        b=WJG0OdCyrRqKsUiF/7SLVwNzDhkhL86NUk1x9bwrnk882zCpBdkXcmqlB+wo410Ju
         RutoNf8EzZpU/KWAyxEeibw86PRqvC42LL28UYylDMwwibd8dBsSFalCJnTA8O9fJO
         oH57dqmRrE5a0aomhTQeoaoeAheM/wXDCKK9A/A4=
Date:   Tue, 18 Apr 2023 16:40:27 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        pmladek@suse.com, kbingham@kernel.org, john.ogness@linutronix.de,
        jan.kiszka@siemens.com, antonio.borneo@foss.st.com,
        development@efficientek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers.patch removed from -mm tree
Message-Id: <20230418234027.B96C0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: create linux/vfs.py for VFS related GDB helpers
has been removed from the -mm tree.  Its filename was
     scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Glenn Washburn <development@efficientek.com>
Subject: scripts/gdb: create linux/vfs.py for VFS related GDB helpers
Date: Tue, 28 Feb 2023 18:53:34 -0600

Patch series "GDB VFS utils".

I've created a couple GDB convenience functions that I found useful when
debugging some VFS issues and figure others might find them useful.  For
instance, they are useful in setting conditional breakpoints on VFS
functions where you only care if the dentry path is a certain value.  I
took the opportunity to create a new "vfs" python module to give VFS
related utilities a home.


This patch (of 2):

This will allow for more VFS specific GDB helpers to be collected in one
place.  Move utils.dentry_name into the vfs modules.  Also a local
variable in proc.py was changed from vfs to mnt to prevent a naming
collision with the new vfs module.

[akpm@linux-foundation.org: add SPDX-License-Identifier]
Link: https://lkml.kernel.org/r/cover.1677631565.git.development@efficientek.com
Link: https://lkml.kernel.org/r/7bba4c065a8c2c47f1fc5b03a7278005b04db251.1677631565.git.development@efficientek.com
Signed-off-by: Glenn Washburn <development@efficientek.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py  |   16 +++++++++-------
 scripts/gdb/linux/utils.py |    8 --------
 scripts/gdb/linux/vfs.py   |   22 ++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 4 files changed, 32 insertions(+), 15 deletions(-)

--- a/scripts/gdb/linux/proc.py~scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers
+++ a/scripts/gdb/linux/proc.py
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 #
 # gdb helper commands and functions for Linux kernel debugging
 #
@@ -16,6 +17,7 @@ from linux import constants
 from linux import utils
 from linux import tasks
 from linux import lists
+from linux import vfs
 from struct import *
 
 
@@ -170,16 +172,16 @@ values of that process namespace"""
         gdb.write("{:^18} {:^15} {:>9} {} {} options\n".format(
                   "mount", "super_block", "devname", "pathname", "fstype"))
 
-        for vfs in lists.list_for_each_entry(namespace['list'],
+        for mnt in lists.list_for_each_entry(namespace['list'],
                                              mount_ptr_type, "mnt_list"):
-            devname = vfs['mnt_devname'].string()
+            devname = mnt['mnt_devname'].string()
             devname = devname if devname else "none"
 
             pathname = ""
-            parent = vfs
+            parent = mnt
             while True:
                 mntpoint = parent['mnt_mountpoint']
-                pathname = utils.dentry_name(mntpoint) + pathname
+                pathname = vfs.dentry_name(mntpoint) + pathname
                 if (parent == parent['mnt_parent']):
                     break
                 parent = parent['mnt_parent']
@@ -187,14 +189,14 @@ values of that process namespace"""
             if (pathname == ""):
                 pathname = "/"
 
-            superblock = vfs['mnt']['mnt_sb']
+            superblock = mnt['mnt']['mnt_sb']
             fstype = superblock['s_type']['name'].string()
             s_flags = int(superblock['s_flags'])
-            m_flags = int(vfs['mnt']['mnt_flags'])
+            m_flags = int(mnt['mnt']['mnt_flags'])
             rd = "ro" if (s_flags & constants.LX_SB_RDONLY) else "rw"
 
             gdb.write("{} {} {} {} {} {}{}{} 0 0\n".format(
-                      vfs.format_string(), superblock.format_string(), devname,
+                      mnt.format_string(), superblock.format_string(), devname,
                       pathname, fstype, rd, info_opts(FS_INFO, s_flags),
                       info_opts(MNT_INFO, m_flags)))
 
--- a/scripts/gdb/linux/utils.py~scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers
+++ a/scripts/gdb/linux/utils.py
@@ -196,11 +196,3 @@ def gdb_eval_or_none(expresssion):
         return gdb.parse_and_eval(expresssion)
     except gdb.error:
         return None
-
-
-def dentry_name(d):
-    parent = d['d_parent']
-    if parent == d or parent == 0:
-        return ""
-    p = dentry_name(d['d_parent']) + "/"
-    return p + d['d_iname'].string()
--- /dev/null
+++ a/scripts/gdb/linux/vfs.py
@@ -0,0 +1,22 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  VFS tools
+#
+# Copyright (c) 2023 Glenn Washburn
+# Copyright (c) 2016 Linaro Ltd
+#
+# Authors:
+#  Glenn Washburn <development@efficientek.com>
+#  Kieran Bingham <kieran.bingham@linaro.org>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+
+def dentry_name(d):
+    parent = d['d_parent']
+    if parent == d or parent == 0:
+        return ""
+    p = dentry_name(d['d_parent']) + "/"
+    return p + d['d_iname'].string()
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -40,6 +40,7 @@ else:
     import linux.clk
     import linux.genpd
     import linux.device
+    import linux.vfs
     import linux.mm
     import linux.radixtree
     import linux.interrupts
_

Patches currently in -mm which might be from development@efficientek.com are


