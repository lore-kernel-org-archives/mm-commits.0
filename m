From: akpm@linux-foundation.org
Subject: + scripts-gdb-fix-pep8-compliance.patch added to -mm tree
Date: Fri, 22 May 2015 12:32:40 -0700
Message-ID: <555f8458.aWfMGRJIa8St715V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbbEVTcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thiebaud@weksteen.fr, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix PEP8 compliance
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-pep8-compliance.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-pep8-compl=
iance.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-pep8-compl=
iance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Subject: scripts/gdb: fix PEP8 compliance

Signed-off-by: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py   |    1 -
 scripts/gdb/linux/symbols.py |    9 ++++-----
 scripts/gdb/linux/tasks.py   |    2 ++
 scripts/gdb/linux/utils.py   |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-fix-pep8-compliance sc=
ripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-fix-pep8-compliance
+++ a/scripts/gdb/linux/dmesg.py
@@ -12,7 +12,6 @@
 #
=20
 import gdb
-import string
=20
 from linux import utils
=20
diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-fix-pep8-compliance =
scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-fix-pep8-compliance
+++ a/scripts/gdb/linux/symbols.py
@@ -14,9 +14,8 @@
 import gdb
 import os
 import re
-import string
=20
-from linux import modules, utils
+from linux import modules
=20
=20
 if hasattr(gdb, 'Breakpoint'):
@@ -97,7 +96,7 @@ lx-symbols command."""
             return ""
         attrs =3D sect_attrs['attrs']
         section_name_to_address =3D {
-            attrs[n]['name'].string() : attrs[n]['address']
+            attrs[n]['name'].string(): attrs[n]['address']
             for n in range(int(sect_attrs['nsections']))}
         args =3D []
         for section_name in [".data", ".data..read_mostly", ".rodata",=
 ".bss"]:
@@ -124,7 +123,7 @@ lx-symbols command."""
                 addr=3Dmodule_addr,
                 sections=3Dself._section_arguments(module))
             gdb.execute(cmdline, to_string=3DTrue)
-            if not module_name in self.loaded_modules:
+            if module_name not in self.loaded_modules:
                 self.loaded_modules.append(module_name)
         else:
             gdb.write("no module object found for '{0}'\n".format(modu=
le_name))
@@ -164,7 +163,7 @@ lx-symbols command."""
         self.load_all_symbols()
=20
         if hasattr(gdb, 'Breakpoint'):
-            if not self.breakpoint is None:
+            if self.breakpoint is not None:
                 self.breakpoint.delete()
                 self.breakpoint =3D None
             self.breakpoint =3D LoadModuleBreakpoint(
diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-fix-pep8-compliance sc=
ripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-fix-pep8-compliance
+++ a/scripts/gdb/linux/tasks.py
@@ -18,6 +18,7 @@ from linux import utils
=20
 task_type =3D utils.CachedType("struct task_struct")
=20
+
 def task_lists():
     global task_type
     task_ptr_type =3D task_type.get_type().pointer()
@@ -38,6 +39,7 @@ def task_lists():
         if t =3D=3D init_task:
             return
=20
+
 def get_task_by_pid(pid):
     for task in task_lists():
         if int(task['pid']) =3D=3D pid:
diff -puN scripts/gdb/linux/utils.py~scripts-gdb-fix-pep8-compliance sc=
ripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-pep8-compliance
+++ a/scripts/gdb/linux/utils.py
@@ -151,6 +151,6 @@ def get_gdbserver_type():
             gdbserver_type =3D GDBSERVER_QEMU
         elif probe_kgdb():
             gdbserver_type =3D GDBSERVER_KGDB
-        if not gdbserver_type is None and hasattr(gdb, 'events'):
+        if gdbserver_type is not None and hasattr(gdb, 'events'):
             gdb.events.exited.connect(exit_handler)
     return gdbserver_type
_

Patches currently in -mm which might be from thiebaud@weksteen.fr are

scripts-gdb-add-command-to-check-list-consistency.patch
scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter.patc=
h
scripts-gdb-enable-completion-for-lx-list-check-parameter.patch
scripts-gdb-fix-typo-in-exception-name.patch
scripts-gdb-fix-pep8-compliance.patch
scripts-gdb-add-ps-command.patch
scripts-gdb-remove-useless-global-instruction.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
