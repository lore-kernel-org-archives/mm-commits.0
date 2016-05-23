From: akpm@linux-foundation.org
Subject: [patch 50/84] scripts/gdb: provide kernel list item generators
Date: Mon, 23 May 2016 16:24:42 -0700
Message-ID: <5743913a.EvZkwY3SSpthCeOb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com, jeffm@suse.com

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
