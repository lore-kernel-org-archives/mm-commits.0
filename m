From: akpm@linux-foundation.org
Subject: [merged] cgroups-add-data-field-to-struct-cgroup_scanner.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:58 -0700
Message-ID: <200904061934.n36JYwGM011836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756903AbZDFThs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: add 'data' field to struct cgroup_scanner
has been removed from the -mm tree.  Its filename was
     cgroups-add-data-field-to-struct-cgroup_scanner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add 'data' field to struct cgroup_scanner
From: Li Zefan <lizf@cn.fujitsu.com>

We need to pass some data to test_task() or process_task() in some cases. 
Will be used later.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/cgroup.h~cgroups-add-data-field-to-struct-cgroup_scanner include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-data-field-to-struct-cgroup_scanner
+++ a/include/linux/cgroup.h
@@ -337,6 +337,7 @@ struct cgroup_scanner {
 	void (*process_task)(struct task_struct *p,
 			struct cgroup_scanner *scan);
 	struct ptr_heap *heap;
+	void *data;
 };
 
 /*
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch

