From: akpm@linux-foundation.org
Subject: - cgroup-use-read-lock-to-guard-find_existing_css_set.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:00 -0700
Message-ID: <200807252258.m6PMw0xI003243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbYGYW6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: use read lock to guard find_existing_css_set()
has been removed from the -mm tree.  Its filename was
     cgroup-use-read-lock-to-guard-find_existing_css_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: use read lock to guard find_existing_css_set()
From: Li Zefan <lizf@cn.fujitsu.com>

The function does not modify anything (except the temporary css template), so
it's sufficient to hold read lock.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroup-use-read-lock-to-guard-find_existing_css_set kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-use-read-lock-to-guard-find_existing_css_set
+++ a/kernel/cgroup.c
@@ -415,11 +415,11 @@ static struct css_set *find_css_set(
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
-	write_lock(&css_set_lock);
+	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
 	if (res)
 		get_css_set(res);
-	write_unlock(&css_set_lock);
+	read_unlock(&css_set_lock);
 
 	if (res)
 		return res;
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
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

