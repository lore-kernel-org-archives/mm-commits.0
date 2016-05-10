From: akpm@linux-foundation.org
Subject: + scripts-gdb-provide-kernel-list-item-generators.patch added to
 -mm tree
Date: Tue, 10 May 2016 12:34:18 -0700
Message-ID: <573237ba.9a68L6Ri+6rd7WmR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcEJTeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: provide kernel list item generators
has been added to the -mm tree.  Its filename is
     scripts-gdb-provide-kernel-list-item-generators.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-provide-kernel-list-item-generators.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-provide-kernel-list-item-generators.patch

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
Subject: scripts/gdb: provide kernel list item generators

Facilitate linked-list items by providing a generator to return
the dereferenced, and type-cast objects from a kernel linked list

Link: http://lkml.kernel.org/r/2b0998564e6e5abe53585d466f87e491331fd2a4.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/lists.py |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN scripts/gdb/linux/lists.py~scripts-gdb-provide-kernel-list-item-generators scripts/gdb/linux/lists.py
--- a/scripts/gdb/linux/lists.py~scripts-gdb-provide-kernel-list-item-generators
+++ a/scripts/gdb/linux/lists.py
@@ -18,6 +18,27 @@ from linux import utils
 list_head = utils.CachedType("struct list_head")
 
 
+def list_for_each(head):
+    if head.type == list_head.get_type().pointer():
+        head = head.dereference()
+    elif head.type != list_head.get_type():
+        raise gdb.GdbError("Must be struct list_head not {}"
+                           .format(head.type))
+
+    node = head['next'].dereference()
+    while node.address != head.address:
+        yield node.address
+        node = node['next'].dereference()
+
+
+def list_for_each_entry(head, gdbtype, member):
+    for node in list_for_each(head):
+        if node.type != list_head.get_type().pointer():
+            raise TypeError("Type {} found. Expected struct list_head *."
+                            .format(node.type))
+        yield utils.container_of(node, gdbtype, member)
+
+
 def list_check(head):
     nb = 0
     if (head.type == list_head.get_type().pointer()):
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

