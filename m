From: akpm@linux-foundation.org
Subject: [merged] proc-less-lock-unlock-in-remove_proc_entry.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:41 -0800
Message-ID: <201101132011.p0DKBM1V030168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933735Ab1AMUUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: less LOCK/UNLOCK in remove_proc_entry()
has been removed from the -mm tree.  Its filename was
     proc-less-lock-unlock-in-remove_proc_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: less LOCK/UNLOCK in remove_proc_entry()
From: Alexey Dobriyan <adobriyan@gmail.com>

For the common case where a proc entry is being removed and nobody is in
the process of using it, save a LOCK/UNLOCK pair.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/generic.c~proc-less-lock-unlock-in-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~proc-less-lock-unlock-in-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -826,12 +826,9 @@ void remove_proc_entry(const char *name,
 
 		wait_for_completion(de->pde_unload_completion);
 
-		goto continue_removing;
+		spin_lock(&de->pde_unload_lock);
 	}
-	spin_unlock(&de->pde_unload_lock);
 
-continue_removing:
-	spin_lock(&de->pde_unload_lock);
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

