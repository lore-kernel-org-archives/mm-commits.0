From: akpm@linux-foundation.org
Subject: [merged] scripts-bloat-o-meter-fix-python3-syntax-error.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:14 -0800
Message-ID: <56997332.xa0PKHyytLZqZcya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbcAOWbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: fix python3 syntax error
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-fix-python3-syntax-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: scripts/bloat-o-meter: fix python3 syntax error

In Python3+ print is a function so the old syntax is not correct anymore:

:$ ./scripts/bloat-o-meter vmlinux.o vmlinux.o.old
:  File "./scripts/bloat-o-meter", line 61
:    print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
:                                                                   ^
:SyntaxError: invalid syntax

Fix by calling print as a function.

Tested on python 2.7.11, 3.5.1

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-fix-python3-syntax-error scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-fix-python3-syntax-error
+++ a/scripts/bloat-o-meter
@@ -58,8 +58,8 @@ for name in common:
 delta.sort()
 delta.reverse()
 
-print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
-      (add, remove, grow, shrink, up, -down, up-down)
-print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
+print("add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
+      (add, remove, grow, shrink, up, -down, up-down))
+print("%-40s %7s %7s %+7s" % ("function", "old", "new", "delta"))
 for d, n in delta:
-    if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
+    if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are


