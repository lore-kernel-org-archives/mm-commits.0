From: akpm@linux-foundation.org
Subject: + scripts-bloat-o-meter-dont-use-readlines.patch added to -mm
 tree
Date: Fri, 18 Nov 2016 15:57:54 -0800
Message-ID: <582f9582.fKBJikVhwfJtWs7g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbcKRX5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: don't use readlines()
has been added to the -mm tree.  Its filename is
     scripts-bloat-o-meter-dont-use-readlines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-bloat-o-meter-dont-use-readlines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-bloat-o-meter-dont-use-readlines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
scripts-bloat-o-meter-dont-use-readlines.patch
scripts-bloat-o-meter-compile-number-regex.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch
proc-just-list_del-struct-pde_opener.patch
proc-fix-type-of-struct-pde_opener-closing-field.patch
proc-kmalloc-struct-pde_opener.patch
proc-tweak-comments-about-2-stage-open-and-everything.patch
coredump-clarify-unsafe-core_pattern-warning.patch

