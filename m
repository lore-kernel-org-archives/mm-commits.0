From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 131/155] mm/compaction: really limit
 compact_unevictable_allowed to 0 and 1
Date: Wed, 01 Apr 2020 21:10:38 -0700
Message-ID: <20200402041038.4pSgW4I-9%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:41 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, yzaikin@google.com

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
