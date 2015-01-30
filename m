From: akpm@linux-foundation.org
Subject: + scripts-gdb-port-to-python3-gdb77.patch added to -mm tree
Date: Fri, 30 Jan 2015 15:36:59 -0800
Message-ID: <54cc159b.0ZQAAGA9kynPnz1W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761709AbbA3XhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:37:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pktoss@gmail.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jan.kiszka@siemens.com, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: port to python3 / gdb7.7
has been added to the -mm tree.  Its filename is
     scripts-gdb-port-to-python3-gdb77.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-port-to-python3-gdb77.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-port-to-python3-gdb77.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pantelis Koukousoulas <pktoss@gmail.com>
Subject: scripts/gdb: port to python3 / gdb7.7

I tried to use these scripts in an ubuntu 14.04 host (gdb 7.7 compiled
against python 3.3) but there were several errors.

I believe this patch fixes these issues so that the commands now work (I
tested lx-symbols, lx-dmesg, lx-lsmod).

Main issues that needed to be resolved:

  * In python 2 iterators have a "next()" method. In python 3 it is
    __next__() instead (so let's just add both).

  * In older python versions there was an implicit conversion
    in object.__format__() (used when an object is in string.format())
    where it was converting the object to str first and then
    calling str's __format__(). This has now been removed so
    we must explicitly convert to str the objects for which
    we need to keep this behavior.

  * In dmesg.py: in python 3 log_buf is now a "memoryview" object
    which needs to be converted to a string in order to use string
    methods like "splitlines()". Luckily memoryview exists in
    python 2.7.6 as well, so we can convert log_buf to memoryview
    and use the same code in both python 2 and python 3.

This version of the patch has now been tested with gdb 7.7 and both python
3.4 and python 2.7.6 (I think asking for at least python 2.7.6 is a
reasonable requirement instead of complicating the code with version
checks etc).

Signed-off-by: Pantelis Koukousoulas <pktoss@gmail.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py    |    5 ++++-
 scripts/gdb/linux/dmesg.py   |    3 ++-
 scripts/gdb/linux/modules.py |    9 ++++++---
 scripts/gdb/linux/symbols.py |    4 ++--
 scripts/gdb/linux/tasks.py   |    4 +++-
 scripts/gdb/linux/utils.py   |    2 +-
 6 files changed, 18 insertions(+), 9 deletions(-)

diff -puN scripts/gdb/linux/cpus.py~scripts-gdb-port-to-python3-gdb77 scripts/gdb/linux/cpus.py
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-port-to-python3-gdb77
+++ a/scripts/gdb/linux/cpus.py
@@ -82,7 +82,7 @@ class CpuList():
     def __iter__(self):
         return self
 
-    def next(self):
+    def __next__(self):
         while self.bits == 0:
             self.entry += 1
             if self.entry == self.num_entries:
@@ -103,6 +103,9 @@ class CpuList():
 
         return cpu
 
+    def next(self):
+        return self.__next__()
+
 
 class PerCpu(gdb.Function):
     """Return per-cpu variable.
diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-port-to-python3-gdb77 scripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-port-to-python3-gdb77
+++ a/scripts/gdb/linux/dmesg.py
@@ -51,9 +51,10 @@ class LxDmesg(gdb.Command):
                 continue
 
             text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
+            text = log_buf[pos + 16:pos + 16 + text_len]
             time_stamp = utils.read_u64(log_buf[pos:pos + 8])
 
-            for line in log_buf[pos + 16:pos + 16 + text_len].splitlines():
+            for line in memoryview(text).tobytes().splitlines():
                 gdb.write("[{time:12.6f}] {line}\n".format(
                     time=time_stamp / 1000000000.0,
                     line=line))
diff -puN scripts/gdb/linux/modules.py~scripts-gdb-port-to-python3-gdb77 scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-port-to-python3-gdb77
+++ a/scripts/gdb/linux/modules.py
@@ -30,7 +30,7 @@ class ModuleList:
     def __iter__(self):
         return self
 
-    def next(self):
+    def __next__(self):
         entry = self.curr_entry
         if entry != self.end_of_list:
             self.curr_entry = entry['next']
@@ -38,6 +38,9 @@ class ModuleList:
         else:
             raise StopIteration
 
+    def next(self):
+        return self.__next__()
+
 
 def find_module_by_name(name):
     for module in ModuleList():
@@ -91,8 +94,8 @@ class LxLsmod(gdb.Command):
             gdb.write("{address} {name:<19} {size:>8}  {ref}".format(
                 address=str(module['module_core']).split()[0],
                 name=module['name'].string(),
-                size=module['core_size'],
-                ref=ref))
+                size=str(module['core_size']),
+                ref=str(ref)))
 
             source_list = module['source_list']
             t = self._module_use_type.get_type().pointer()
diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-port-to-python3-gdb77 scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-port-to-python3-gdb77
+++ a/scripts/gdb/linux/symbols.py
@@ -73,7 +73,7 @@ lx-symbols command."""
 
     def _get_module_file(self, module_name):
         module_pattern = ".*/{0}\.ko$".format(
-            string.replace(module_name, "_", r"[_\-]"))
+            module_name.replace("_", r"[_\-]"))
         for name in self.module_files:
             if re.match(module_pattern, name) and os.path.exists(name):
                 return name
@@ -87,7 +87,7 @@ lx-symbols command."""
         attrs = sect_attrs['attrs']
         section_name_to_address = {
             attrs[n]['name'].string() : attrs[n]['address']
-            for n in range(sect_attrs['nsections'])}
+            for n in range(int(sect_attrs['nsections']))}
         args = []
         for section_name in [".data", ".data..read_mostly", ".rodata", ".bss"]:
             address = section_name_to_address.get(section_name)
diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-port-to-python3-gdb77 scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-port-to-python3-gdb77
+++ a/scripts/gdb/linux/tasks.py
@@ -30,7 +30,7 @@ class TaskList:
     def __iter__(self):
         return self
 
-    def next(self):
+    def __next__(self):
         t = self.curr_task
         if not t or t == self.curr_group:
             self.curr_group = \
@@ -45,6 +45,8 @@ class TaskList:
                                    self.task_ptr_type, "thread_group")
         return t
 
+    def next(self):
+        return self.__next__()
 
 def get_task_by_pid(pid):
     for task in TaskList():
diff -puN scripts/gdb/linux/utils.py~scripts-gdb-port-to-python3-gdb77 scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-port-to-python3-gdb77
+++ a/scripts/gdb/linux/utils.py
@@ -83,7 +83,7 @@ def get_target_endianness():
         elif "big endian" in endian:
             target_endianness = BIG_ENDIAN
         else:
-            raise gdb.GdgError("unknown endianness '{0}'".format(endian))
+            raise gdb.GdgError("unknown endianness '{0}'".format(str(endian)))
     return target_endianness
 
 
_

Patches currently in -mm which might be from pktoss@gmail.com are

scripts-gdb-port-to-python3-gdb77.patch

