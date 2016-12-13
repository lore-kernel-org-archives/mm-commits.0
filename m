From: akpm@linux-foundation.org
Subject: [patch 003/123] scripts/bloat-o-meter: don't use readlines()
Date: Mon, 12 Dec 2016 16:40:45 -0800
Message-ID: <584f438d.e+uZaMnXnmfTBlY2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAkq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: scripts/bloat-o-meter: don't use readlines()

readlines() conses whole list before doing anything which is slower for
big object files.  Use per line iterator.

Speed up is ~2% on "allyesconfig" type of kernel.

	$ perf stat -r 16 taskset -c 15 ./scripts/bloat-o-meter ../vmlinux-000 ../obj/vmlinux >/dev/null
		...
Before:	7.247708646 seconds time elapsed                                          ( +-  0.28% )
After:	7.091202853 seconds time elapsed                                          ( +-  0.15% )

Link: http://lkml.kernel.org/r/20161119004143.GA1200@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-dont-use-readlines scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-dont-use-readlines
+++ a/scripts/bloat-o-meter
@@ -18,17 +18,18 @@ if len(sys.argv) != 3:
 
 def getsizes(file):
     sym = {}
-    for l in os.popen("nm --size-sort " + file).readlines():
-        size, type, name = l[:-1].split()
-        if type in "tTdDbBrR":
-            # strip generated symbols
-            if name.startswith("__mod_"): continue
-            if name.startswith("SyS_"): continue
-            if name.startswith("compat_SyS_"): continue
-            if name == "linux_banner": continue
-            # statics and some other optimizations adds random .NUMBER
-            name = re.sub(r'\.[0-9]+', '', name)
-            sym[name] = sym.get(name, 0) + int(size, 16)
+    with os.popen("nm --size-sort " + file) as f:
+        for line in f:
+            size, type, name = line.split()
+            if type in "tTdDbBrR":
+                # strip generated symbols
+                if name.startswith("__mod_"): continue
+                if name.startswith("SyS_"): continue
+                if name.startswith("compat_SyS_"): continue
+                if name == "linux_banner": continue
+                # statics and some other optimizations adds random .NUMBER
+                name = re.sub(r'\.[0-9]+', '', name)
+                sym[name] = sym.get(name, 0) + int(size, 16)
     return sym
 
 old = getsizes(sys.argv[1])
_
