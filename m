From: akpm@linux-foundation.org
Subject: + scripts-bloat-o-meter-fix-sigpipe.patch added to -mm tree
Date: Fri, 28 Oct 2016 15:02:48 -0700
Message-ID: <5813cb08.q2H3DyUXHCYasZct%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756780AbcJ1WCt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 18:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: fix SIGPIPE
has been added to the -mm tree.  Its filename is
     scripts-bloat-o-meter-fix-sigpipe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-bloat-o-meter-fix-sigpipe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-bloat-o-meter-fix-sigpipe.patch

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

Patches currently in -mm which might be from adobriyan@gmail.com are

scripts-bloat-o-meter-fix-sigpipe.patch
kbuild-simpler-generation-of-assembly-constants.patch

