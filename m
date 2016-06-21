From: akpm@linux-foundation.org
Subject: + cgroup-fix-idr-leak-for-the-first-cgroup-root.patch added to
 -mm tree
Date: Tue, 21 Jun 2016 16:28:52 -0700
Message-ID: <5769cdb4.F89uQ+NsOKeke4DA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbcFUXa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: fix idr leak for the first cgroup root
has been added to the -mm tree.  Its filename is
     cgroup-fix-idr-leak-for-the-first-cgroup-root.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cgroup-fix-idr-leak-for-the-first-cgroup-root.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1158,18 +1158,12 @@ static void cgroup_exit_root_id(struct c
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
