From: akpm@linux-foundation.org
Subject: [merged] scripts-bloat-o-meter-fix-sigpipe.patch removed from -mm tree
Date: Mon, 14 Nov 2016 12:02:41 -0800
Message-ID: <582a1861.giZCWW7YoEVLb+yI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935195AbcKNUCm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:02:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: fix SIGPIPE
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-fix-sigpipe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kbuild-simpler-generation-of-assembly-constants.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch
proc-just-list_del-struct-pde_opener.patch
proc-fix-type-of-struct-pde_opener-closing-field.patch
proc-kmalloc-struct-pde_opener.patch
proc-tweak-comments-about-2-stage-open-and-everything.patch
coredump-clarify-unsafe-core_pattern-warning.patch

