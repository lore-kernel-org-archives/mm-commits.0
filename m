From: akpm@linux-foundation.org
Subject: + vma-fix-typo-vma-pg_off-to-vma-vm_pgoff.patch added to -mm tree
Date: Tue, 07 Apr 2009 21:21:32 -0700
Message-ID: <200904080421.n384LWWV021058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbZDHEXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2009 00:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iwamatsu.nobuhiro@renesas.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     nommu: fix typo vma->pg_off to vma->vm_pgoff
has been added to the -mm tree.  Its filename is
     vma-fix-typo-vma-pg_off-to-vma-vm_pgoff.patch

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
Subject: nommu: fix typo vma->pg_off to vma->vm_pgoff
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>

6260a4b0521a41189b2c2a8119096c1e21dbdf2c ("/proc/pid/maps: don't show
pgoff of pure ANON VMAs" had a typo.

fs/proc/task_nommu.c:138: error: 'struct vm_area_struct' has no member named 'pg_off'
distcc[21484] ERROR: compile fs/proc/task_nommu.c on sprygo/32 failed

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_nommu.c~vma-fix-typo-vma-pg_off-to-vma-vm_pgoff fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~vma-fix-typo-vma-pg_off-to-vma-vm_pgoff
+++ a/fs/proc/task_nommu.c
@@ -135,7 +135,7 @@ static int nommu_vma_show(struct seq_fil
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
-		pgoff = (loff_t)vma->pg_off << PAGE_SHIFT;
+		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}
 
 	seq_printf(m,
_

Patches currently in -mm which might be from iwamatsu.nobuhiro@renesas.com are

origin.patch
vma-fix-typo-vma-pg_off-to-vma-vm_pgoff.patch

