From: akpm@linux-foundation.org
Subject: [patch 04/15] scripts/bloat-o-meter: fix SIGPIPE
Date: Thu, 10 Nov 2016 10:46:13 -0800
Message-ID: <5824c075.VGd9z90qALda2MXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755770AbcKJSqP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, mpm@selenic.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: scripts/bloat-o-meter: fix SIGPIPE

Fix piping output to a program which quickly exits (read: head -n1)

	$ ./scripts/bloat-o-meter ../vmlinux-000 ../obj/vmlinux | head -n1
	add/remove: 0/0 grow/shrink: 9/60 up/down: 124/-305 (-181)
	close failed in file object destructor:
	sys.excepthook is missing
	lost sys.stderr

Link: http://lkml.kernel.org/r/20161028204618.GA29923@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-fix-sigpipe scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-fix-sigpipe
+++ a/scripts/bloat-o-meter
@@ -8,6 +8,9 @@
 # of the GNU General Public License, incorporated herein by reference.
 
 import sys, os, re
+from signal import signal, SIGPIPE, SIG_DFL
+
+signal(SIGPIPE, SIG_DFL)
 
 if len(sys.argv) != 3:
     sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
_
