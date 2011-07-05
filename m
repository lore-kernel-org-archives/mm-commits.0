From: akpm@linux-foundation.org
Subject: + procfs-return-enoent-on-opening-a-being-removed-proc-entry.patch added to -mm tree
Date: Tue, 05 Jul 2011 13:38:00 -0700
Message-ID: <201107052038.p65Kc1SM022560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab1GEUij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 16:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ogino.daisuke@jp.fujitsu.com, adobriyan@gmail.com, hch@lst.de, jbarnes@virtuousgeek.org


The patch titled
     procfs: return ENOENT on opening a being-removed proc entry
has been added to the -mm tree.  Its filename is
     procfs-return-enoent-on-opening-a-being-removed-proc-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: return ENOENT on opening a being-removed proc entry
From: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>

Change the return value to ENOENT.  This return value is then returned
when opening the proc entry that have been removed.  For example,
open("/proc/bus/pci/XX/YY") when the corresponding device is being
hot-removed.

Signed-off-by: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~procfs-return-enoent-on-opening-a-being-removed-proc-entry fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-return-enoent-on-opening-a-being-removed-proc-entry
+++ a/fs/proc/inode.c
@@ -321,7 +321,7 @@ static int proc_reg_open(struct inode *i
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
 		kfree(pdeo);
-		return -EINVAL;
+		return -ENOENT;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
_

Patches currently in -mm which might be from ogino.daisuke@jp.fujitsu.com are

procfs-return-enoent-on-opening-a-being-removed-proc-entry.patch

