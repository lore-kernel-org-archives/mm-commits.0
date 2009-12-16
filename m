From: akpm@linux-foundation.org
Subject: [merged] gru-fix-bug-in-module-unload.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:25 -0800
Message-ID: <200912162040.nBGKeP1e013636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965015AbZLPUk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix bug in module unload
has been removed from the -mm tree.  Its filename was
     gru-fix-bug-in-module-unload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix bug in module unload
From: Jack Steiner <steiner@sgi.com>

Fix bug in module unload.  Previous code was not correctly deleting the
files in /proc.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruprocfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-fix-bug-in-module-unload drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-fix-bug-in-module-unload
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -351,7 +351,7 @@ static void delete_proc_files(void)
 		for (p = proc_files; p->name; p++)
 			if (p->entry)
 				remove_proc_entry(p->name, proc_gru);
-		remove_proc_entry("gru", NULL);
+		remove_proc_entry("gru", proc_gru->parent);
 	}
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

