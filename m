From: akpm@linux-foundation.org
Subject: [patch 24/96] scripts/gdb: add lx-fdtdump command
Date: Wed, 12 Jul 2017 14:34:13 -0700
Message-ID: <20170712213413.LI0cSAjZH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVeT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jason.wessel@windriver.com, kbingham@kernel.org, mm-commits@vger.kernel.org, peter.griffin@linaro.org, torvalds@linux-foundation.org

From: Peter Griffin <peter.griffin@linaro.org>
Subject: scripts/gdb: add lx-fdtdump command

lx-fdtdump dumps the flattened device tree passed to the kernel from the
bootloader to the filename specified as the command argument.  If no
argument is provided it defaults to fdtdump.dtb.  This then allows further
post processing on the machine running GDB.  The fdt header is also also
printed in the GDB console.  For example:

(gdb) lx-fdtdump
fdt_magic:         0xD00DFEED
fdt_totalsize:     0xC108
off_dt_struct:     0x38
off_dt_strings:    0x3804
off_mem_rsvmap:    0x28
version:           17
last_comp_version: 16
Dumped fdt to fdtdump.dtb

>fdtdump fdtdump.dtb | less

This command is useful as the bootloader can often re-write parts of the
device tree, and this can sometimes cause the kernel to not boot.

Link: http://lkml.kernel.org/r/1481280065-5336-2-git-send-email-kbingham@kernel.org
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kieran Bingham <kbingham@kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    7 ++
 scripts/gdb/linux/proc.py         |   73 ++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff -puN scripts/gdb/linux/constants.py.in~scripts-gdb-add-lx-fdtdump-command scripts/gdb/linux/constants.py.in
--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-add-lx-fdtdump-command
+++ a/scripts/gdb/linux/constants.py.in
@@ -14,6 +14,7 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/of_fdt.h>
 
 /* We need to stringify expanded macros so that they can be parsed */
 
@@ -50,3 +51,9 @@ LX_VALUE(MNT_NOEXEC)
 LX_VALUE(MNT_NOATIME)
 LX_VALUE(MNT_NODIRATIME)
 LX_VALUE(MNT_RELATIME)
+
+/* linux/of_fdt.h> */
+LX_VALUE(OF_DT_HEADER)
+
+/* Kernel Configs */
+LX_CONFIG(CONFIG_OF)
diff -puN scripts/gdb/linux/proc.py~scripts-gdb-add-lx-fdtdump-command scripts/gdb/linux/proc.py
--- a/scripts/gdb/linux/proc.py~scripts-gdb-add-lx-fdtdump-command
+++ a/scripts/gdb/linux/proc.py
@@ -16,6 +16,7 @@ from linux import constants
 from linux import utils
 from linux import tasks
 from linux import lists
+from struct import *
 
 
 class LxCmdLine(gdb.Command):
@@ -195,3 +196,75 @@ values of that process namespace"""
                         info_opts(MNT_INFO, m_flags)))
 
 LxMounts()
+
+
+class LxFdtDump(gdb.Command):
+    """Output Flattened Device Tree header and dump FDT blob to the filename
+       specified as the command argument. Equivalent to
+       'cat /proc/fdt > fdtdump.dtb' on a running target"""
+
+    def __init__(self):
+        super(LxFdtDump, self).__init__("lx-fdtdump", gdb.COMMAND_DATA,
+                                        gdb.COMPLETE_FILENAME)
+
+    def fdthdr_to_cpu(self, fdt_header):
+
+        fdt_header_be = ">IIIIIII"
+        fdt_header_le = "<IIIIIII"
+
+        if utils.get_target_endianness() == 1:
+            output_fmt = fdt_header_le
+        else:
+            output_fmt = fdt_header_be
+
+        return unpack(output_fmt, pack(fdt_header_be,
+                                       fdt_header['magic'],
+                                       fdt_header['totalsize'],
+                                       fdt_header['off_dt_struct'],
+                                       fdt_header['off_dt_strings'],
+                                       fdt_header['off_mem_rsvmap'],
+                                       fdt_header['version'],
+                                       fdt_header['last_comp_version']))
+
+    def invoke(self, arg, from_tty):
+
+        if not constants.LX_CONFIG_OF:
+            raise gdb.GdbError("Kernel not compiled with CONFIG_OF\n")
+
+        if len(arg) == 0:
+            filename = "fdtdump.dtb"
+        else:
+            filename = arg
+
+        py_fdt_header_ptr = gdb.parse_and_eval(
+            "(const struct fdt_header *) initial_boot_params")
+        py_fdt_header = py_fdt_header_ptr.dereference()
+
+        fdt_header = self.fdthdr_to_cpu(py_fdt_header)
+
+        if fdt_header[0] != constants.LX_OF_DT_HEADER:
+            raise gdb.GdbError("No flattened device tree magic found\n")
+
+        gdb.write("fdt_magic:         0x{:02X}\n".format(fdt_header[0]))
+        gdb.write("fdt_totalsize:     0x{:02X}\n".format(fdt_header[1]))
+        gdb.write("off_dt_struct:     0x{:02X}\n".format(fdt_header[2]))
+        gdb.write("off_dt_strings:    0x{:02X}\n".format(fdt_header[3]))
+        gdb.write("off_mem_rsvmap:    0x{:02X}\n".format(fdt_header[4]))
+        gdb.write("version:           {}\n".format(fdt_header[5]))
+        gdb.write("last_comp_version: {}\n".format(fdt_header[6]))
+
+        inf = gdb.inferiors()[0]
+        fdt_buf = utils.read_memoryview(inf, py_fdt_header_ptr,
+                                        fdt_header[1]).tobytes()
+
+        try:
+            f = open(filename, 'wb')
+        except:
+            raise gdb.GdbError("Could not open file to dump fdt")
+
+        f.write(fdt_buf)
+        f.close()
+
+        gdb.write("Dumped fdt blob to " + filename + "\n")
+
+LxFdtDump()
_
