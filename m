From: akpm@linux-foundation.org
Subject: + scripts-gdb-fix-lx-lsmod-refcnt.patch added to -mm tree
Date: Thu, 21 May 2015 14:15:59 -0700
Message-ID: <555e4b0f.R9Wfonx2F8a6DD3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbbEUVQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 17:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrien+dev@schischi.me, jan.kiszka@siemens.com, pktoss@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-lsmod refcnt
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-lx-lsmod-refcnt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-lx-lsmod-refcnt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-lx-lsmod-refcnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adrien Schildknecht <adrien+dev@schischi.me>
Subject: scripts/gdb: fix lx-lsmod refcnt

Commit 2f35c41f58a9 ("module: Replace module_ref with atomic_t refcnt")
changes the way refcnt is handled but did not update the gdb script to use
the new variable.

Since refcnt is not per-cpu anymore, we can directly read its value.

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Pantelis Koukousoulas <pktoss@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-fix-lx-lsmod-refcnt scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-fix-lx-lsmod-refcnt
+++ a/scripts/gdb/linux/modules.py
@@ -73,18 +73,11 @@ class LxLsmod(gdb.Command):
                 "        " if utils.get_long_type().sizeof == 8 else ""))
 
         for module in module_list():
-            ref = 0
-            module_refptr = module['refptr']
-            for cpu in cpus.cpu_list("cpu_possible_mask"):
-                refptr = cpus.per_cpu(module_refptr, cpu)
-                ref += refptr['incs']
-                ref -= refptr['decs']
