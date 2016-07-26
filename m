From: akpm@linux-foundation.org
Subject: [patch 124/126] cgroup: fix idr leak for the first cgroup root
Date: Tue, 26 Jul 2016 15:26:58 -0700
Message-ID: <5797e3b2.JRBtLLEpsOMQterh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbcGZW1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: cgroup: fix idr leak for the first cgroup root

The valid cgroup hierarchy ID range includes 0, so we can't filter for
positive numbers when freeing it, or it'll leak the first ID.  No big
deal, just disruptive when reading the code.

The ID is freed during error handling and when the reference count hits
zero, so the double-free test is not necessary; remove it.

Link: http://lkml.kernel.org/r/20160617162359.GB19084@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN kernel/cgroup.c~cgroup-fix-idr-leak-for-the-first-cgroup-root kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-idr-leak-for-the-first-cgroup-root
+++ a/kernel/cgroup.c
@@ -1160,18 +1160,12 @@ static void cgroup_exit_root_id(struct c
 {
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (root->hierarchy_id) {
-		idr_remove(&cgroup_hierarchy_idr, root->hierarchy_id);
-		root->hierarchy_id = 0;
-	}
+	idr_remove(&cgroup_hierarchy_idr, root->hierarchy_id);
 }
 
 static void cgroup_free_root(struct cgroup_root *root)
 {
 	if (root) {
-		/* hierarchy ID should already have been released */
-		WARN_ON_ONCE(root->hierarchy_id);
