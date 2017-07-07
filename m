From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-lx-dmesg-use-explicit-encoding=utf8-errors=replace.patch added
 to -mm tree
Date: Fri, 07 Jul 2017 12:32:54 -0700
Message-ID: <595fe1e6.qYPl8suqLmqWelwH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdGGTcz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leonard.crestez@nxp.com, jan.kiszka@siemens.com, jason.wessel@windriver.com, kieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace
has been added to the -mm tree.  Its filename is
     scripts-gdb-lx-dmesg-use-explicit-encoding=utf8-errors=replace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-lx-dmesg-use-explicit-encoding%3Dutf8-errors%3Dreplace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-lx-dmesg-use-explicit-encoding%3Dutf8-errors%3Dreplace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace

Use errors=replace because it is never desirable for lx-dmesg to fail on
string decoding errors, not even if the log buffer is corrupt and we show
incorrect info.

The kernel will sometimes print utf8, for example the copyright symbol
from jffs2.  In order to make this work specify 'utf8' everywhere because
python2 otherwise defaults to 'ascii'.

In theory the second errors='replace' is not be required because
everything that can be decoded as utf8 should also be encodable back to
utf8.  But it's better to be extra safe here.  It's worth noting that this
is definitely not true for encoding='ascii', unknown characters are
replaced with U+FFFD REPLACEMENT CHARACTER and they fail to encode back to
ascii.

Link: http://lkml.kernel.org/r/acee067f3345954ed41efb77b80eebdc038619c6.1498481469.git.leonard.crestez@nxp.com
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-lx-dmesg-use-explicit-encoding=utf8-errors=replace scripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-lx-dmesg-use-explicit-encoding=utf8-errors=replace
+++ a/scripts/gdb/linux/dmesg.py
@@ -12,6 +12,7 @@
 #
 
 import gdb
+import sys
 
 from linux import utils
 
@@ -52,13 +53,19 @@ class LxDmesg(gdb.Command):
                 continue
 
             text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
-            text = log_buf[pos + 16:pos + 16 + text_len].decode()
+            text = log_buf[pos + 16:pos + 16 + text_len].decode(
+                encoding='utf8', errors='replace')
             time_stamp = utils.read_u64(log_buf[pos:pos + 8])
 
             for line in text.splitlines():
-                gdb.write("[{time:12.6f}] {line}\n".format(
+                msg = u"[{time:12.6f}] {line}\n".format(
                     time=time_stamp / 1000000000.0,
-                    line=line))
+                    line=line)
+                # With python2 gdb.write will attempt to convert unicode to
+                # ascii and might fail so pass an utf8-encoded str instead.
+                if sys.hexversion < 0x03000000:
+                    msg = msg.encode(encoding='utf8', errors='replace')
+                gdb.write(msg)
 
             pos += length
 
_

Patches currently in -mm which might be from leonard.crestez@nxp.com are

scripts-gdb-lx-dmesg-cast-log_buf-to-void-for-addr-fetch.patch
scripts-gdb-lx-dmesg-use-explicit-encoding=utf8-errors=replace.patch

