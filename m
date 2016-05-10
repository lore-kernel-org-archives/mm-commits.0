From: akpm@linux-foundation.org
Subject: + scripts-gdb-decode-bytestream-on-dmesg-for-python3.patch added
 to -mm tree
Date: Tue, 10 May 2016 12:34:46 -0700
Message-ID: <573237d6.QCZdwojIn6c8vDLm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbcEJTer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran@ksquared.org.uk, buzdelabuz2@gmail.com, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: decode bytestream on dmesg for Python3
has been added to the -mm tree.  Its filename is
     scripts-gdb-decode-bytestream-on-dmesg-for-python3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-decode-bytestream-on-dmesg-for-python3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-decode-bytestream-on-dmesg-for-python3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kieran Bingham <kieran@bingham.xyz>
Subject: scripts/gdb: decode bytestream on dmesg for Python3

The recent fixes to lx-dmesg, now allow the command to print
successfully on Python3, however the python interpreter wraps the bytes
for each line with a b'<text>' marker.

To remove this, we need to decode the line, where .decode() will default
to 'UTF-8'

Link: http://lkml.kernel.org/r/d67ccf93f2479c94cb3399262b9b796e0dbefcf2.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Acked-by: Dom Cote <buzdelabuz2@gmail.com>
Tested-by: Dom Cote <buzdelabuz2@gmail.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-decode-bytestream-on-dmesg-for-python3 scripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-decode-bytestream-on-dmesg-for-python3
+++ a/scripts/gdb/linux/dmesg.py
@@ -51,10 +51,10 @@ class LxDmesg(gdb.Command):
                 continue
 
             text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
-            text = log_buf[pos + 16:pos + 16 + text_len]
+            text = log_buf[pos + 16:pos + 16 + text_len].decode()
             time_stamp = utils.read_u64(log_buf[pos:pos + 8])
 
-            for line in memoryview(text).tobytes().splitlines():
+            for line in text.splitlines():
                 gdb.write("[{time:12.6f}] {line}\n".format(
                     time=time_stamp / 1000000000.0,
                     line=line))
_

Patches currently in -mm which might be from kieran@bingham.xyz are

scripts-gdb-decode-bytestream-on-dmesg-for-python3.patch
maintainers-add-co-maintainer-for-scripts-gdb.patch

