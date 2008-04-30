From: akpm@linux-foundation.org
Subject: - cgroup-api-files-drop-mem_cgroup_force_empty.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:25 -0700
Message-ID: <200804300542.m3U5gPBU029144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760842AbYD3GM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: drop mem_cgroup_force_empty()
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-drop-mem_cgroup_force_empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: drop mem_cgroup_force_empty()
From: Paul Menage <menage@google.com>

This function isn't needed - a NULL pointer in the cftype read function will
result in the same EINVAL response to userspace.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/memcontrol.c~cgroup-api-files-drop-mem_cgroup_force_empty mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-api-files-drop-mem_cgroup_force_empty
+++ a/mm/memcontrol.c
@@ -880,17 +880,6 @@ static ssize_t mem_force_empty_write(str
 	return ret;
 }
 
-/*
- * Note: This should be removed if cgroup supports write-only file.
- */
-static ssize_t mem_force_empty_read(struct cgroup *cont,
-				struct cftype *cft,
-				struct file *file, char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
-{
-	return -EINVAL;
-}
