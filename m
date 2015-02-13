From: akpm@linux-foundation.org
Subject: [merged] cgroup-release-css-id-after-css_free.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:20:17 -0800
Message-ID: <54de5c81.POQmwzbyBRWL/Cly%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbbBMUUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: release css->id after css_free
has been removed from the -mm tree.  Its filename was
     cgroup-release-css-id-after-css_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: cgroup: release css->id after css_free

Currently, we release css->id in css_release_work_fn, right before calling
css_free callback, so that when css_free is called, the id may have
already been reused for a new cgroup.

I am going to use css->id to create unique names for per memcg kmem
caches.  Since kmem caches are destroyed only on css_free, I need css->id
to be freed after css_free was called to avoid name clashes.  This patch
therefore moves css->id removal to css_free_work_fn.  To prevent
css_from_id from returning a pointer to a stale css, it makes
css_release_work_fn replace the css ptr at css_idr:css->id with NULL.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~cgroup-release-css-id-after-css_free kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-release-css-id-after-css_free
+++ a/kernel/cgroup.c
@@ -4373,16 +4373,20 @@ static void css_free_work_fn(struct work
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
 	percpu_ref_exit(&css->refcnt);
 
-	if (css->ss) {
+	if (ss) {
 		/* css free path */
+		int id = css->id;
+
 		if (css->parent)
 			css_put(css->parent);
 
-		css->ss->css_free(css);
+		ss->css_free(css);
+		cgroup_idr_remove(&ss->css_idr, id);
 		cgroup_put(cgrp);
 	} else {
 		/* cgroup free path */
@@ -4434,7 +4438,7 @@ static void css_release_work_fn(struct w
 
 	if (ss) {
 		/* css release path */
-		cgroup_idr_remove(&ss->css_idr, css->id);
+		cgroup_idr_replace(&ss->css_idr, NULL, css->id);
 		if (ss->css_released)
 			ss->css_released(css);
 	} else {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

