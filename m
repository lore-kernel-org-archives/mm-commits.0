From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-improve-types-abstraction-for-gdb-python-scripts.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:44:24 -0700
Message-ID: <57489588.dSqf+Ev1onICN7ZJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbcE0SoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buzdelabuz2+git@gmail.com, jan.kiszka@siemens.com, kieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: improve types abstraction for gdb python scripts
has been removed from the -mm tree.  Its filename was
     scripts-gdb-improve-types-abstraction-for-gdb-python-scripts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dom Cote <buzdelabuz2+git@gmail.com>
Subject: scripts/gdb: improve types abstraction for gdb python scripts

Change the read_u16 function so it accepts both 'str' and 'byte'
as type for the arguments.

When calling read_memory() from gdb API, depending on if
it was built with 2.7 or 3.X, the format used to return the
data will differ ( 'str' for 2.7, and 'byte' for 3.X ).

Add a function read_memoryview() to be able to get a
'memoryview' object back from read_memory() both with
python 2.7 and 3.X .

Tested with python 3.4 and 2.7
Tested with gdb 7.7

Link: http://lkml.kernel.org/r/73621f564503137a002a639d174e4fb35f73f462.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Dom Cote <buzdelabuz2+git@gmail.com>
Tested-by: Kieran Bingham <kieran@bingham.xyz> (Py2.7,Py3.4,GDB10)
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-improve-types-abstraction-for-gdb-python-scripts scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-improve-types-abstraction-for-gdb-python-scripts
+++ a/scripts/gdb/linux/utils.py
@@ -87,11 +87,24 @@ def get_target_endianness():
     return target_endianness
 
 
+def read_memoryview(inf, start, length):
+    return memoryview(inf.read_memory(start, length))
+
+
 def read_u16(buffer):
+    value = [0, 0]
+
+    if type(buffer[0]) is str:
+        value[0] = ord(buffer[0])
+        value[1] = ord(buffer[1])
+    else:
+        value[0] = buffer[0]
+        value[1] = buffer[1]
+
     if get_target_endianness() == LITTLE_ENDIAN:
-        return ord(buffer[0]) + (ord(buffer[1]) << 8)
+        return value[0] + (value[1] << 8)
     else:
-        return ord(buffer[1]) + (ord(buffer[0]) << 8)
+        return value[1] + (value[0] << 8)
 
 
 def read_u32(buffer):
_

Patches currently in -mm which might be from buzdelabuz2+git@gmail.com are


