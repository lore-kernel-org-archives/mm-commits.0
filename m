From: akpm@linux-foundation.org
Subject: + allow-oom_adj-of-saintly-processes.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:12:08 -0800
Message-ID: <200702251312.l1PDCAc8030013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35904 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964955AbXBYNM5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:12:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpritikin@pobox.com, andrea@novell.com


The patch titled
     allow oom_adj of saintly processes
has been added to the -mm tree.  Its filename is
     allow-oom_adj-of-saintly-processes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

allow-oom_adj-of-saintly-processes.patch
