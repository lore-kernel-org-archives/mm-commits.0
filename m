From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 08/15] scripts/gdb: repair rb_first() and
 rb_last()
Date: Thu, 07 May 2020 18:36:03 -0700
Message-ID: <20200508013603.V_dO-bgar%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgEHBgE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:36:04 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aymeric.agon@yandex.com, dianders@chromium.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, kbingham@kernel.org, linux-mm@kvack.org, liuyun01@kylinos.cn, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, swboyd@chromium.org, torvalds@linux-foundation.org

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
