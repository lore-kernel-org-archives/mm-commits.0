From: akpm@linux-foundation.org
Subject: [folded-merged]
 bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2.patch removed from -mm tree
Date: Wed, 15 Nov 2017 16:47:08 -0800
Message-ID: <5a0ce00c.SaH0JQL3bLveE8Bh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753923AbdKPArK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:47:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, andi@firstfloor.org, a.sahrawat@samsung.com, mmarek@suse.cz, pankaj.m@samsung.com, v.narang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2
has been removed from the -mm tree.  Its filename was
     bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2.patch

This patch was dropped because it was folded into bloat-o-meter-provide-3-different-arguments-for-data-function-and-all.patch

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2

v1 -> v2
1) Incorporated missed changes between 4.1 and latest version.
2) Removed extra noise of "#####" after each section print.
3) Removed extra parentheses from if and else caluse.

Link: http://lkml.kernel.org/r/1506569402-24787-1-git-send-email-maninder1.s@samsung.com
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: <pankaj.m@samsung.com>
Cc: <a.sahrawat@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |   51 +++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff -puN scripts/bloat-o-meter~bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2 scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2
+++ a/scripts/bloat-o-meter
@@ -13,7 +13,7 @@ from signal import signal, SIGPIPE, SIG_
 signal(SIGPIPE, SIG_DFL)
 
 if len(sys.argv) < 3:
-    sys.stderr.write("usage: %s [option] file1 file2 \n" % sys.argv[0])
+    sys.stderr.write("usage: %s [option] file1 file2\n" % sys.argv[0])
     sys.stderr.write("The options are:\n")
     sys.stderr.write("-c	cateogrize output based on symbole type\n")
     sys.stderr.write("-d	Show delta of Data Section\n")
@@ -22,23 +22,24 @@ if len(sys.argv) < 3:
 
 re_NUMBER = re.compile(r'\.[0-9]+')
 
-def getsizes(file, format) :
-    func_sym = {}
-    for l in os.popen("nm --size-sort " + file).readlines():
-        size, type, name = l[:-1].split()
-        if type in format:
-            # strip generated symbols
-            if name.startswith("__mod_"): continue
-            if name.startswith("SyS_"): continue
-            if name.startswith("compat_SyS_"): continue
-            if name == "linux_banner": continue
-            # statics and some other optimizations adds random .NUMBER
-            name = re_NUMBER.sub('', name)
-            func_sym[name] = func_sym.get(name, 0) + int(size, 16)
-    return func_sym
+def getsizes(file, format):
+    sym = {}
+    with os.popen("nm --size-sort " + file) as f:
+        for line in f:
+            size, type, name = line.split()
+            if type in format:
+                # strip generated symbols
+                if name.startswith("__mod_"): continue
+                if name.startswith("SyS_"): continue
+                if name.startswith("compat_SyS_"): continue
+                if name == "linux_banner": continue
+                # statics and some other optimizations adds random .NUMBER
+                name = re_NUMBER.sub('', name)
+                sym[name] = sym.get(name, 0) + int(size, 16)
+    return sym
 
 def calc(oldfile, newfile, format):
-    old = getsizes(oldfile , format)
+    old = getsizes(oldfile, format)
     new = getsizes(newfile, format)
     grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
     delta, common = [], {}
@@ -79,27 +80,19 @@ def print_result(symboltype, symbolforma
     print("add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
           (add, remove, grow, shrink, up, -down, up-down))
     print("%-40s %7s %7s %+7s" % (symboltype, "old", "new", "delta"))
-
     for d, n in delta:
-        if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
+        if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
 
     print("Total: Before=%d, After=%d, chg %+.2f%%" % \
-          (otot, ntot, (ntot - otot)*100.0/otot))
+        (otot, ntot, (ntot - otot)*100.0/otot))
 
-if(sys.argv[1] == "-c"):
+if sys.argv[1] == "-c":
     print_result("Function", "tT", 3)
-    print("##########################################################")
-
     print_result("Data", "dDbB", 3)
-    print("##########################################################")
-
     print_result("RO Data", "rR", 3)
-
-elif(sys.argv[1] == "-d"):
+elif sys.argv[1] == "-d":
     print_result("Data", "dDbBrR", 3)
-
-elif(sys.argv[1] == "-t"):
+elif sys.argv[1] == "-t":
     print_result("Function", "tT", 3)
