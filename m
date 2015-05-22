From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-command-to-check-list-consistency.patch added
 to -mm tree
Date: Fri, 22 May 2015 12:32:32 -0700
Message-ID: <555f8450.LXiTPyRC09VB943M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbbEVTcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thiebaud@weksteen.fr, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add command to check list consistency
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-command-to-check-list-consistency.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-command-to=
-check-list-consistency.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-command-to=
-check-list-consistency.patch

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
Subject: scripts/gdb: add command to check list consistency

Add a gdb script to verify the consistency of lists.

Signed-off-by: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/lists.py |   89 +++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1=20
 2 files changed, 90 insertions(+)

diff -puN /dev/null scripts/gdb/linux/lists.py
--- /dev/null
+++ a/scripts/gdb/linux/lists.py
@@ -0,0 +1,89 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  list tools
+#
+# Copyright (c) Thiebaud Weksteen, 2015
+#
+# Authors:
+#  Thiebaud Weksteen <thiebaud@weksteen.fr>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from linux import utils
+
+list_head =3D utils.CachedType("struct list_head")
+
+
+def list_check(head):
+    nb =3D 0
+    c =3D head
+    if (c.type !=3D list_head.get_type()):
+        raise gdb.GdbError('The argument should be of type (struct lis=
t_head)')
+    try:
+        gdb.write("Starting with: {}\n".format(c))
+    except gdb.MemoryError:
+        gdb.write('head is not accessible\n')
+        return
+    while True:
+        p =3D c['prev'].dereference()
+        n =3D c['next'].dereference()
+        try:
+            if p['next'] !=3D c.address:
+                gdb.write('prev.next !=3D current: '
+                          'current@{current_addr}=3D{current} '
+                          'prev@{p_addr}=3D{p}\n'.format(
+                              current_addr=3Dc.address,
+                              current=3Dc,
+                              p_addr=3Dp.address,
+                              p=3Dp,
+                          ))
+                return
+        except gdb.MemoryError:
+            gdb.write('prev is not accessible: '
+                      'current@{current_addr}=3D{current}\n'.format(
+                          current_addr=3Dc.address,
+                          current=3Dc
+                      ))
+            return
+        try:
+            if n['prev'] !=3D c.address:
+                gdb.write('next.prev !=3D current: '
+                          'current@{current_addr}=3D{current} '
+                          'next@{n_addr}=3D{n}\n'.format(
+                              current_addr=3Dc.address,
+                              current=3Dc,
+                              n_addr=3Dn.address,
+                              n=3Dn,
+                          ))
+                return
+        except gdb.MemoryError:
+            gdb.write('next is not accessible: '
+                      'current@{current_addr}=3D{current}\n'.format(
+                          current_addr=3Dc.address,
+                          current=3Dc
+                      ))
+            return
+        c =3D n
+        nb +=3D 1
+        if c =3D=3D head:
+            gdb.write("list is consistent: {} node(s)\n".format(nb))
+            return
+
+
+class LxListChk(gdb.Command):
+    """Verify a list consistency"""
+
+    def __init__(self):
+        super(LxListChk, self).__init__("lx-list-check", gdb.COMMAND_D=
ATA)
+
+    def invoke(self, arg, from_tty):
+        argv =3D gdb.string_to_argv(arg)
+        if len(argv) !=3D 1:
+            raise gdb.GdbError("lx-list-check takes one argument")
+        list_check(gdb.parse_and_eval(argv[0]))
+
+LxListChk()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-command-to-check-l=
ist-consistency scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-command-to-check-list-=
consistency
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -28,3 +28,4 @@ else:
     import linux.dmesg
     import linux.tasks
     import linux.cpus
+    import linux.lists
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
