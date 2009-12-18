From: akpm@linux-foundation.org
Subject: [merged] kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:04 -0800
Message-ID: <200912182026.nBIKQ4bM016431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932840AbZLRU0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kernel/sysctl.c: fix the incomplete part of sysctl_max_map_count-should-be-non-negative.patch
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sysctl.c: fix the incomplete part of sysctl_max_map_count-should-be-non-negative.patch
From: WANG Cong <amwang@redhat.com>

It is a mistake that we used 'proc_dointvec', it should be
'proc_dointvec_minmax', as in the original patch.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch
+++ a/kernel/sysctl.c
@@ -1131,7 +1131,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #else
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch

