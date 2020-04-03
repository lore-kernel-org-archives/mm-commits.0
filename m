From: akpm@linux-foundation.org
Subject: [merged]
 really-limit-compact_unevictable_allowed-to-0-and-1.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:40:09 -0700
Message-ID: <20200403204009.hZ3RxEz1F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUkL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz, yzaikin@google.com


The patch titled
     Subject: mm/compaction: really limit compact_unevictable_allowed to 0 and 1
has been removed from the -mm tree.  Its filename was
     really-limit-compact_unevictable_allowed-to-0-and-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/compaction: really limit compact_unevictable_allowed to 0 and 1

The proc file `compact_unevictable_allowed' should allow 0 and 1 only, the
`extra*' attribues have been set properly but without
proc_dointvec_minmax() as the `proc_handler' the limit will not be
enforced.

Use proc_dointvec_minmax() as the `proc_handler' to enfoce the valid
specified range.

Link: http://lkml.kernel.org/r/20200303202054.gsosv7fsx2ma3cic@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sysctl.c~really-limit-compact_unevictable_allowed-to-0-and-1
+++ a/kernel/sysctl.c
@@ -1467,7 +1467,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_compact_unevictable_allowed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
_

Patches currently in -mm which might be from bigeasy@linutronix.de are
