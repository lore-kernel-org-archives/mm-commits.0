From: akpm@linux-foundation.org
Subject: +
 really-limit-compact_unevictable_allowed-to-0-and-1.patch added to -mm tree
Date: Tue, 03 Mar 2020 15:56:50 -0800
Message-ID: <20200303235650.sv1fSvvuJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgCCX4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 18:56:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz, yzaikin@google.com


The patch titled
     Subject: mm/compaction: really limit compact_unevictable_allowed to 0 and 1
has been added to the -mm tree.  Its filename is
     really-limit-compact_unevictable_allowed-to-0-and-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/really-limit-compact_unevictable_allowed-to-0-and-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/really-limit-compact_unevictable_allowed-to-0-and-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1484,7 +1484,7 @@ static struct ctl_table vm_table[] = {
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

mm-z3fold-do-not-include-rwlockh-directly.patch
really-limit-compact_unevictable_allowed-to-0-and-1.patch
mm-compaction-disable-compact_unevictable_allowed-on-rt.patch
