From: akpm@linux-foundation.org
Subject: + scripts-gdb-repair-rb_first-and-rb_last.patch added to
 -mm tree
Date: Mon, 27 Apr 2020 13:10:43 -0700
Message-ID: <20200427201043.y4OL2k0N_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgD0UKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 16:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aymeric.agon@yandex.com, dianders@chromium.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, kbingham@kernel.org, liuyun01@kylinos.cn, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, swboyd@chromium.org


The patch titled
     Subject: scripts/gdb: repair rb_first() and rb_last()
has been added to the -mm tree.  Its filename is
     scripts-gdb-repair-rb_first-and-rb_last.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-repair-rb_first-and-rb_last.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-repair-rb_first-and-rb_last.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
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

scripts-gdb-repair-rb_first-and-rb_last.patch
