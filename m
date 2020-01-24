From: akpm@linux-foundation.org
Subject: + proc-convert-everything-to-struct-proc_ops-fix-2.patch
 added to -mm tree
Date: Thu, 23 Jan 2020 17:29:51 -0800
Message-ID: <20200124012951.31ecUGMc8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728799AbgAXB3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 20:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: proc-convert-everything-to-struct-proc_ops-fix-2
has been added to the -mm tree.  Its filename is
     proc-convert-everything-to-struct-proc_ops-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-everything-to-struct-proc_ops-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-everything-to-struct-proc_ops-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: proc-convert-everything-to-struct-proc_ops-fix-2

fix kernel/sched/psi.c

Link: http://lkml.kernel.org/r/20200122180545.36222f50@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/psi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/psi.c~proc-convert-everything-to-struct-proc_ops-fix-2
+++ a/kernel/sched/psi.c
@@ -1283,8 +1283,8 @@ static int __init psi_proc_init(void)
 	if (psi_enable) {
 		proc_mkdir("pressure", NULL);
 		proc_create("pressure/io", 0, NULL, &psi_io_proc_ops);
-		proc_create("pressure/memory", 0, NUL, &psi_memory_proc_ops);
-		proc_create("pressure/cpu", 0, NULL &psi_cpu_proc_ops);
+		proc_create("pressure/memory", 0, NULL, &psi_memory_proc_ops);
+		proc_create("pressure/cpu", 0, NULL, &psi_cpu_proc_ops);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

proc-convert-everything-to-struct-proc_ops-fix-2.patch
