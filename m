From: akpm@linux-foundation.org
Subject: + fix-bloat-o-meter-for-ppc64.patch added to -mm tree
Date: Fri, 14 Dec 2007 15:46:07 -0800
Message-ID: <200712142346.lBENk75F021996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbXLNXrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Dec 2007 18:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ntl@pobox.com, mpm@selenic.com


The patch titled
     fix bloat-o-meter for ppc64
has been added to the -mm tree.  Its filename is
     fix-bloat-o-meter-for-ppc64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix bloat-o-meter for ppc64
From: Nathan Lynch <ntl@pobox.com>

bloat-o-meter assumes that a '.' anywhere in a symbol's name means that it
is static and prepends 'static.' to the first part of the symbol name,
discarding the portion of the name that follows the '.'.  However, the
names of function entry points begin with '.' in the ppc64 ABI.  This
causes all function text size changes to be accounted to a single 'static.'
entry in the output when comparing ppc64 kernels.

Change getsizes() to ignore the first character of the symbol name when
searching for '.'.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/bloat-o-meter~fix-bloat-o-meter-for-ppc64 scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~fix-bloat-o-meter-for-ppc64
+++ a/scripts/bloat-o-meter
@@ -18,7 +18,8 @@ def getsizes(file):
     for l in os.popen("nm --size-sort " + file).readlines():
         size, type, name = l[:-1].split()
         if type in "tTdDbB":
-            if "." in name: name = "static." + name.split(".")[0]
+            # function names begin with '.' on 64-bit powerpc
+            if "." in name[1:]: name = "static." + name.split(".")[0]
             sym[name] = sym.get(name, 0) + int(size, 16)
     return sym
 
_

Patches currently in -mm which might be from ntl@pobox.com are

fix-bloat-o-meter-for-ppc64.patch
git-powerpc.patch
