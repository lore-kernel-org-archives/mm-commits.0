From: akpm@linux-foundation.org
Subject: [patch 001/131] bloat-o-meter: provide 3 different
 arguments for data, function and All
Date: Wed, 15 Nov 2017 17:31:14 -0800
Message-ID: <20171116013114.AI3hmzgmb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933424AbdKPBbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:31:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.sahrawat@samsung.com, akpm@linux-foundation.org, andi@firstfloor.org, maninder1.s@samsung.com, mm-commits@vger.kernel.org, mmarek@suse.cz, pankaj.m@samsung.com, torvalds@linux-foundation.org, v.narang@samsung.com

From: Maninder Singh <maninder1.s@samsung.com>
Subject: bloat-o-meter: provide 3 different arguments for data, function and All

This patch provides 3 new arguments for bloat-o-meter
1) -c -> for all (showing function and data differently)
2) -d -> data
3) -t -> function

output:-
./scripts/bloat-o-meter  -c "file1" "file2"
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-152 (-152)
Function                                     old     new   delta
main                                         412     260    -152
Total: Before=548, After=396, chg -27.74%
##########################################################
add/remove: 1/0 grow/shrink: 1/0 up/down: 84/0 (84)
Data                                         old     new   delta
arr                                            -      64     +64
backtrace                                     60      80     +20
Total: Before=109, After=193, chg +77.06%
##########################################################
add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-64 (-64)
RO Data                                      old     new   delta
arr                                           64       -     -64
Total: Before=68, After=4, chg -94.12%

[maninder1.s@samsung.com: v1 -> v2]
  Link: http://lkml.kernel.org/r/1506569402-24787-1-git-send-email-maninder1.s@samsung.com
Link: http://lkml.kernel.org/r/1506336313-27187-1-git-send-email-maninder1.s@samsung.com
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: <pankaj.m@samsung.com>
Cc: <a.sahrawat@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |   99 ++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 39 deletions(-)

diff -puN scripts/bloat-o-meter~bloat-o-meter-provide-3-different-arguments-for-data-function-and-all scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~bloat-o-meter-provide-3-different-arguments-for-data-function-and-all
+++ a/scripts/bloat-o-meter
@@ -12,18 +12,22 @@ from signal import signal, SIGPIPE, SIG_
 
 signal(SIGPIPE, SIG_DFL)
 
-if len(sys.argv) != 3:
-    sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
+if len(sys.argv) < 3:
+    sys.stderr.write("usage: %s [option] file1 file2\n" % sys.argv[0])
+    sys.stderr.write("The options are:\n")
+    sys.stderr.write("-c	cateogrize output based on symbole type\n")
+    sys.stderr.write("-d	Show delta of Data Section\n")
+    sys.stderr.write("-t	Show delta of text Section\n")
     sys.exit(-1)
 
 re_NUMBER = re.compile(r'\.[0-9]+')
 
-def getsizes(file):
+def getsizes(file, format):
     sym = {}
     with os.popen("nm --size-sort " + file) as f:
         for line in f:
             size, type, name = line.split()
-            if type in "tTdDbBrR":
+            if type in format:
                 # strip generated symbols
                 if name.startswith("__mod_"): continue
                 if name.startswith("SyS_"): continue
@@ -34,44 +38,61 @@ def getsizes(file):
                 sym[name] = sym.get(name, 0) + int(size, 16)
     return sym
 
-old = getsizes(sys.argv[1])
-new = getsizes(sys.argv[2])
-grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
-delta, common = [], {}
-otot, ntot = 0, 0
-
-for a in old:
-    if a in new:
-        common[a] = 1
-
-for name in old:
-    otot += old[name]
-    if name not in common:
-        remove += 1
-        down += old[name]
-        delta.append((-old[name], name))
-
-for name in new:
-    ntot += new[name]
-    if name not in common:
-        add += 1
-        up += new[name]
-        delta.append((new[name], name))
+def calc(oldfile, newfile, format):
+    old = getsizes(oldfile, format)
+    new = getsizes(newfile, format)
+    grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
+    delta, common = [], {}
+    otot, ntot = 0, 0
+
+    for a in old:
+        if a in new:
+            common[a] = 1
+
+    for name in old:
+        otot += old[name]
+        if name not in common:
+            remove += 1
+            down += old[name]
+            delta.append((-old[name], name))
+
+    for name in new:
+        ntot += new[name]
+        if name not in common:
+            add += 1
+            up += new[name]
+            delta.append((new[name], name))
 
-for name in common:
+    for name in common:
         d = new.get(name, 0) - old.get(name, 0)
         if d>0: grow, up = grow+1, up+d
         if d<0: shrink, down = shrink+1, down-d
         delta.append((d, name))
 
-delta.sort()
-delta.reverse()
-
-print("add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
-      (add, remove, grow, shrink, up, -down, up-down))
-print("%-40s %7s %7s %+7s" % ("function", "old", "new", "delta"))
-for d, n in delta:
-    if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
-
-print("Total: Before=%d, After=%d, chg %+.2f%%" % \
-    (otot, ntot, (ntot - otot)*100.0/otot))
+    delta.sort()
+    delta.reverse()
+    return grow, shrink, add, remove, up, down, delta, old, new, otot, ntot
+
+def print_result(symboltype, symbolformat, argc):
+    grow, shrink, add, remove, up, down, delta, old, new, otot, ntot = \
+    calc(sys.argv[argc - 1], sys.argv[argc], symbolformat)
+
+    print("add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
+          (add, remove, grow, shrink, up, -down, up-down))
+    print("%-40s %7s %7s %+7s" % (symboltype, "old", "new", "delta"))
+    for d, n in delta:
+        if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
+
+    print("Total: Before=%d, After=%d, chg %+.2f%%" % \
+        (otot, ntot, (ntot - otot)*100.0/otot))
+
+if sys.argv[1] == "-c":
+    print_result("Function", "tT", 3)
+    print_result("Data", "dDbB", 3)
+    print_result("RO Data", "rR", 3)
+elif sys.argv[1] == "-d":
+    print_result("Data", "dDbBrR", 3)
+elif sys.argv[1] == "-t":
+    print_result("Function", "tT", 3)
+else:
+    print_result("Function", "tTdDbBrR", 2)
_
