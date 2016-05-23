From: akpm@linux-foundation.org
Subject: [patch 56/84] scripts/gdb: add mount point list command
Date: Mon, 23 May 2016 16:24:59 -0700
Message-ID: <5743914b.Uq+QiuL+g0VWn2RH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com

From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: add mount point list command

lx-mounts will identify current mount points based on the 'init_task'
namespace by default, as we do not yet have a kernel thread list
implementation to select the current running thread.

Optionally, a user can specify a PID to list from that process'
namespace

Link: http://lkml.kernel.org/r/e614c7bc32d2350b4ff1627ec761a7148e65bfe6.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |   20 +++++
 scripts/gdb/linux/proc.py         |   99 ++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff -puN scripts/gdb/linux/constants.py.in~scripts-gdb-add-mount-point-list-command scripts/gdb/linux/constants.py.in
--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-add-mount-point-list-command
+++ a/scripts/gdb/linux/constants.py.in
@@ -12,7 +12,11 @@
  *
  */
 
+#include <linux/fs.h>
+#include <linux/mount.h>
+
 /* We need to stringify expanded macros so that they can be parsed */
+
 #define STRING(x) #x
 #define XSTRING(x) STRING(x)
 
@@ -30,3 +34,19 @@
 <!-- end-c-headers -->
 
 import gdb
+
+/* linux/fs.h */
+LX_VALUE(MS_RDONLY)
+LX_VALUE(MS_SYNCHRONOUS)
+LX_VALUE(MS_MANDLOCK)
+LX_VALUE(MS_DIRSYNC)
+LX_VALUE(MS_NOATIME)
+LX_VALUE(MS_NODIRATIME)
+
+/* linux/mount.h */
+LX_VALUE(MNT_NOSUID)
+LX_VALUE(MNT_NODEV)
+LX_VALUE(MNT_NOEXEC)
+LX_VALUE(MNT_NOATIME)
+LX_VALUE(MNT_NODIRATIME)
+LX_VALUE(MNT_RELATIME)
diff -puN scripts/gdb/linux/proc.py~scripts-gdb-add-mount-point-list-command scripts/gdb/linux/proc.py
--- a/scripts/gdb/linux/proc.py~scripts-gdb-add-mount-point-list-command
+++ a/scripts/gdb/linux/proc.py
@@ -12,6 +12,10 @@
 #
 
 import gdb
+from linux import constants
+from linux import utils
+from linux import tasks
+from linux import lists
 
 
 class LxCmdLine(gdb.Command):
@@ -96,3 +100,98 @@ Equivalent to cat /proc/ioports on a run
         return show_lx_resources("ioport_resource")
 
 LxIOPorts()
+
+
+# Mount namespace viewer
+#  /proc/mounts
+
+def info_opts(lst, opt):
+    opts = ""
+    for key, string in lst.items():
+        if opt & key:
+            opts += string
+    return opts
+
+
+FS_INFO = {constants.LX_MS_SYNCHRONOUS: ",sync",
+           constants.LX_MS_MANDLOCK: ",mand",
+           constants.LX_MS_DIRSYNC: ",dirsync",
+           constants.LX_MS_NOATIME: ",noatime",
+           constants.LX_MS_NODIRATIME: ",nodiratime"}
+
+MNT_INFO = {constants.LX_MNT_NOSUID: ",nosuid",
+            constants.LX_MNT_NODEV: ",nodev",
+            constants.LX_MNT_NOEXEC: ",noexec",
+            constants.LX_MNT_NOATIME: ",noatime",
+            constants.LX_MNT_NODIRATIME: ",nodiratime",
+            constants.LX_MNT_RELATIME: ",relatime"}
+
+mount_type = utils.CachedType("struct mount")
+mount_ptr_type = mount_type.get_type().pointer()
+
+
+class LxMounts(gdb.Command):
+    """Report the VFS mounts of the current process namespace.
+
+Equivalent to cat /proc/mounts on a running target
+An integer value can be supplied to display the mount
+values of that process namespace"""
+
+    def __init__(self):
+        super(LxMounts, self).__init__("lx-mounts", gdb.COMMAND_DATA)
+
+    # Equivalent to proc_namespace.c:show_vfsmnt
+    # However, that has the ability to call into s_op functions
+    # whereas we cannot and must make do with the information we can obtain.
+    def invoke(self, arg, from_tty):
+        argv = gdb.string_to_argv(arg)
+        if len(argv) >= 1:
+            try:
+                pid = int(argv[0])
+            except:
+                raise gdb.GdbError("Provide a PID as integer value")
+        else:
+            pid = 1
+
+        task = tasks.get_task_by_pid(pid)
+        if not task:
+            raise gdb.GdbError("Couldn't find a process with PID {}"
+                               .format(pid))
+
+        namespace = task['nsproxy']['mnt_ns']
+        if not namespace:
+            raise gdb.GdbError("No namespace for current process")
+
+        for vfs in lists.list_for_each_entry(namespace['list'],
+                                             mount_ptr_type, "mnt_list"):
+            devname = vfs['mnt_devname'].string()
+            devname = devname if devname else "none"
+
+            pathname = ""
+            parent = vfs
+            while True:
+                mntpoint = parent['mnt_mountpoint']
+                pathname = utils.dentry_name(mntpoint) + pathname
+                if (parent == parent['mnt_parent']):
+                    break
+                parent = parent['mnt_parent']
+
+            if (pathname == ""):
+                pathname = "/"
+
+            superblock = vfs['mnt']['mnt_sb']
+            fstype = superblock['s_type']['name'].string()
+            s_flags = int(superblock['s_flags'])
+            m_flags = int(vfs['mnt']['mnt_flags'])
+            rd = "ro" if (s_flags & constants.LX_MS_RDONLY) else "rw"
+
+            gdb.write(
+                "{} {} {} {}{}{} 0 0\n"
+                .format(devname,
+                        pathname,
+                        fstype,
+                        rd,
+                        info_opts(FS_INFO, s_flags),
+                        info_opts(MNT_INFO, m_flags)))
+
+LxMounts()
_
