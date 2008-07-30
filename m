From: akpm@linux-foundation.org
Subject: - cgroup-fix-possible-memory-leak.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:05 -0700
Message-ID: <200807301914.m6UJE53F010883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbYG3TcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: fix possible memory leak
has been removed from the -mm tree.  Its filename was
     cgroup-fix-possible-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix possible memory leak
From: Li Zefan <lizf@cn.fujitsu.com>

There's a leak if copy_from_user() returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroup-fix-possible-memory-leak kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-possible-memory-leak
+++ a/kernel/cgroup.c
@@ -1424,14 +1424,17 @@ static ssize_t cgroup_write_string(struc
 		if (buffer == NULL)
 			return -ENOMEM;
 	}
-	if (nbytes && copy_from_user(buffer, userbuf, nbytes))
-		return -EFAULT;
+	if (nbytes && copy_from_user(buffer, userbuf, nbytes)) {
+		retval = -EFAULT;
+		goto out;
+	}
 
 	buffer[nbytes] = 0;     /* nul-terminate */
 	strstrip(buffer);
 	retval = cft->write_string(cgrp, cft, buffer);
 	if (!retval)
 		retval = nbytes;
+out:
 	if (buffer != local_buffer)
 		kfree(buffer);
 	return retval;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

