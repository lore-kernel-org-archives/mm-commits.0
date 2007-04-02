From: akpm@linux-foundation.org
Subject: - cpusets-add-mems-to-basic-usage-documentation.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:03:41 -0700
Message-ID: <200704022303.l32N3fhA011908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51962 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966051AbXDBXDu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     CPUSETS: add mems to basic usage documentation
has been removed from the -mm tree.  Its filename was
     cpusets-add-mems-to-basic-usage-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPUSETS: add mems to basic usage documentation
From: Simon Horman <horms@verge.net.au>

It seems that there must be at least one node in mems and at least one CPU
in cpus in order to be able to assign tasks to a cpuset.  This makes sense.
 And I think it would also make sense to include a mems setting in the
basic usage section of the documentation.

I also wonder if something logged to dmsg, explaining why a write failed,
would be a good enhancement.  I ended up having rummage arround in cpuset.c
in order to work out why my configuration was failing.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Documentation/cpusets.txt~cpusets-add-mems-to-basic-usage-documentation Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpusets-add-mems-to-basic-usage-documentation
+++ a/Documentation/cpusets.txt
@@ -557,6 +557,9 @@ Set some flags:
 Add some cpus:
 # /bin/echo 0-7 > cpus
 
+Add some mems:
+# /bin/echo 0-7 > mems
+
 Now attach your shell to this cpuset:
 # /bin/echo $$ > tasks
 
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
git-net.patch
git-scsi-misc.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
kdump-kexec-calculate-note-size-at-compile-time-update.patch
