From: akpm@linux-foundation.org
Subject: [merged] scripts-bloat-o-meter-dont-use-readlines.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:22:48 -0800
Message-ID: <58519c08.OjwElP1fL3pec5v4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753538AbcLNTWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:22:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: don't use readlines()
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-dont-use-readlines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
coredump-clarify-unsafe-core_pattern-warning.patch

