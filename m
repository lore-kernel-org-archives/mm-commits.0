From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-lx-dmesg-cast-log_buf-to-void-for-addr-fetch.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:40:55 -0700
Message-ID: <20170713204055.kijRyTqx6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59050 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdGMUk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, jason.wessel@windriver.com, kieran@ksquared.org.uk, leonard.crestez@nxp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch
has been removed from the -mm tree.  Its filename was
     scripts-gdb-lx-dmesg-cast-log_buf-to-void-for-addr-fetch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch

In some cases it is possible for the str() conversion here to throw
encoding errors because log_buf might not point to valid ascii.  For
example:

(gdb) python print str(gdb.parse_and_eval("log_buf"))
Traceback (most recent call last):
  File "<string>", line 1, in <module>
UnicodeEncodeError: 'ascii' codec can't encode character u'\u0303' in
	position 24: ordinal not in range(128)

Avoid this by explicitly casting to (void *) inside the gdb expression.

Link: http://lkml.kernel.org/r/ba6f85dbb02ca980ebd0e2399b0649423399b565.1498481469.git.leonard.crestez@nxp.com
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-lx-dmesg-cast-log_buf-to-void-for-addr-fetch scripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-lx-dmesg-cast-log_buf-to-void-for-addr-fetch
+++ a/scripts/gdb/linux/dmesg.py
@@ -24,7 +24,7 @@ class LxDmesg(gdb.Command):
 
     def invoke(self, arg, from_tty):
         log_buf_addr = int(str(gdb.parse_and_eval(
-            "'printk.c'::log_buf")).split()[0], 16)
+            "(void *)'printk.c'::log_buf")).split()[0], 16)
         log_first_idx = int(gdb.parse_and_eval("'printk.c'::log_first_idx"))
         log_next_idx = int(gdb.parse_and_eval("'printk.c'::log_next_idx"))
         log_buf_len = int(gdb.parse_and_eval("'printk.c'::log_buf_len"))
_

Patches currently in -mm which might be from leonard.crestez@nxp.com are


