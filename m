From: akpm@linux-foundation.org
Subject: - fix-missing-numa_zonelist_order-sysctl.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:49 -0700
Message-ID: <200708140502.l7E52n0B032004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762423AbXHNFDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Fix missing numa_zonelist_order sysctl
has been removed from the -mm tree.  Its filename was
     fix-missing-numa_zonelist_order-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix missing numa_zonelist_order sysctl
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Misplaced #endif is hiding the numa_zonelist_order sysctl when !SECURITY.

[But, maybe reordering the zonelists is not such a good idea
when ZONE_MOVABLE is populated?]

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~fix-missing-numa_zonelist_order-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~fix-missing-numa_zonelist_order-sysctl
+++ a/kernel/sysctl.c
@@ -1023,6 +1023,7 @@ static ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
+#endif
 #ifdef CONFIG_NUMA
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1034,7 +1035,6 @@ static ctl_table vm_table[] = {
 		.strategy	= &sysctl_string,
 	},
 #endif
-#endif
 #if defined(CONFIG_X86_32) || \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

document-linux-memory-policy-v3.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
