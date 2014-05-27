From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-double-kmem_cache_destroy-in-dlm_init.patch
 removed from -mm tree
Date: Tue, 27 May 2014 13:22:25 -0700
Message-ID: <5384f401.Heu95hNTCgJx9s8g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaE0UWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-fix-double-kmem_cache_destroy-in-dlm_init.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:22:25 -0700


The patch titled
     Subject: ocfs2: fix double kmem_cache_destroy in dlm_init
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-double-kmem_cache_destroy-in-dlm_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix double kmem_cache_destroy in dlm_init

In dlm_init, if create dlm_lockname_cache failed in
dlm_init_master_caches, it will destroy dlm_lockres_cache which created
before twice.  And this will cause system die when loading modules.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-fix-double-kmem_cache_destroy-in-dlm_init fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-fix-double-kmem_cache_destroy-in-dlm_init
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -472,11 +472,15 @@ bail:
 
 void dlm_destroy_master_caches(void)
 {
-	if (dlm_lockname_cache)
+	if (dlm_lockname_cache) {
 		kmem_cache_destroy(dlm_lockname_cache);
+		dlm_lockname_cache = NULL;
+	}
 
-	if (dlm_lockres_cache)
+	if (dlm_lockres_cache) {
 		kmem_cache_destroy(dlm_lockres_cache);
+		dlm_lockres_cache = NULL;
+	}
 }
 
 static void dlm_lockres_release(struct kref *kref)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-limit-printk-when-journal-is-aborted.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch

