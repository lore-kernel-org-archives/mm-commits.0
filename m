From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-convert-everything-to-struct-proc_ops-fix-2.patch removed from -mm
 tree
Date: Mon, 03 Feb 2020 17:12:38 -0800
Message-ID: <20200204011238.0O1_zfMV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgBDBMk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: proc-convert-everything-to-struct-proc_ops-fix-2
has been removed from the -mm tree.  Its filename was
     proc-convert-everything-to-struct-proc_ops-fix-2.patch

This patch was dropped because it was folded into proc-convert-everything-to-struct-proc_ops.patch

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

proc-convert-everything-to-struct-proc_ops.patch
