From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-repair-rb_first-and-rb_last.patch
 removed from -mm tree
Date: Fri, 08 May 2020 15:32:37 -0700
Message-ID: <20200508223237.lXk7uF2Q3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgEHWcj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 18:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aymeric.agon@yandex.com, dianders@chromium.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, kbingham@kernel.org, liuyun01@kylinos.cn, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, swboyd@chromium.org


The patch titled
     Subject: scripts/gdb: repair rb_first() and rb_last()
has been removed from the -mm tree.  Its filename was
     scripts-gdb-repair-rb_first-and-rb_last.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aymeric Agon-Rambosson <aymeric.agon@yandex.com>
Subject: scripts/gdb: repair rb_first() and rb_last()

The current implementations of the rb_first() and rb_last() gdb functions
have a variable that references itself in its instanciation, which causes
the function to throw an error if a specific condition on the argument is
met.  The original author rather intended to reference the argument and
made a typo.  Referring the argument instead makes the function work as
intended.

Link: http://lkml.kernel.org/r/20200427051029.354840-1-aymeric.agon@yandex.com
Signed-off-by: Aymeric Agon-Rambosson <aymeric.agon@yandex.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jackie Liu <liuyun01@kylinos.cn>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/rbtree.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/rbtree.py~scripts-gdb-repair-rb_first-and-rb_last
+++ a/scripts/gdb/linux/rbtree.py
@@ -12,7 +12,7 @@ rb_node_type = utils.CachedType("struct
 
 def rb_first(root):
     if root.type == rb_root_type.get_type():
-        node = node.address.cast(rb_root_type.get_type().pointer())
+        node = root.address.cast(rb_root_type.get_type().pointer())
     elif root.type != rb_root_type.get_type().pointer():
         raise gdb.GdbError("Must be struct rb_root not {}".format(root.type))
 
@@ -28,7 +28,7 @@ def rb_first(root):
 
 def rb_last(root):
     if root.type == rb_root_type.get_type():
-        node = node.address.cast(rb_root_type.get_type().pointer())
+        node = root.address.cast(rb_root_type.get_type().pointer())
     elif root.type != rb_root_type.get_type().pointer():
         raise gdb.GdbError("Must be struct rb_root not {}".format(root.type))
 
_

Patches currently in -mm which might be from aymeric.agon@yandex.com are
