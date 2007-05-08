From: akpm@linux-foundation.org
Subject: - allow-oom_adj-of-saintly-processes.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:02 -0700
Message-ID: <200705080002.l48022GX008817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967307AbXEHACh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpritikin@pobox.com, andrea@novell.com, mm-commits@vger.kernel.org


The patch titled
     allow oom_adj of saintly processes
has been removed from the -mm tree.  Its filename was
     allow-oom_adj-of-saintly-processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: allow oom_adj of saintly processes
From: Joshua N Pritikin <jpritikin@pobox.com>

If the badness of a process is zero then oom_adj>0 has no effect.  This
patch makes sure that the oom_adj shift actually increases badness points
appropriately.

Signed-off-by: Joshua N. Pritikin <jpritikin@pobox.com>
Cc: Andrea Arcangeli <andrea@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~allow-oom_adj-of-saintly-processes mm/oom_kill.c
--- a/mm/oom_kill.c~allow-oom_adj-of-saintly-processes
+++ a/mm/oom_kill.c
@@ -147,9 +147,11 @@ unsigned long badness(struct task_struct
 	 * Adjust the score by oomkilladj.
 	 */
 	if (p->oomkilladj) {
-		if (p->oomkilladj > 0)
+		if (p->oomkilladj > 0) {
+			if (!points)
+				points = 1;
 			points <<= p->oomkilladj;
-		else
+		} else
 			points >>= -(p->oomkilladj);
 	}
 
_

Patches currently in -mm which might be from jpritikin@pobox.com are

origin.patch
