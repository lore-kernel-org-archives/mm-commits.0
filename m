From: akpm@linux-foundation.org
Subject: + cpusets-add-mems-to-basic-usage-documentation.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:03:31 -0700
Message-ID: <200703302103.l2UL3VaJ005078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52359 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXC3VDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, menage@google.com, pj@sgi.com


The patch titled
     CPUSETS: add mems to basic usage documentation
has been added to the -mm tree.  Its filename is
     cpusets-add-mems-to-basic-usage-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    3 +++
 1 files changed, 3 insertions(+)

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

cpusets-add-mems-to-basic-usage-documentation.patch
git-ia64.patch
git-scsi-misc.patch
