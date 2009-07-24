From: akpm@linux-foundation.org
Subject: + cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch added to -mm tree
Date: Fri, 24 Jul 2009 14:18:27 -0700
Message-ID: <200907242118.n6OLIR0u006806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbZGXVTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 17:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     cgroups: make unlock sequence in cgroup_get_sb consistent
has been added to the -mm tree.  Its filename is
     cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch

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
Subject: cgroups: make unlock sequence in cgroup_get_sb consistent
From: Xiaotian Feng <dfeng@redhat.com>

Make the last unlock sequence consistent with previous unlock sequeue.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent
+++ a/kernel/cgroup.c
@@ -1155,8 +1155,8 @@ static int cgroup_get_sb(struct file_sys
 		BUG_ON(root->number_of_cgroups != 1);
 
 		cgroup_populate_dir(root_cgrp);
-		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
+		mutex_unlock(&inode->i_mutex);
 	}
 
 	simple_set_mnt(mnt, sb);
_

Patches currently in -mm which might be from dfeng@redhat.com are

linux-next.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch

