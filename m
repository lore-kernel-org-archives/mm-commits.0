From: akpm@linux-foundation.org
Subject: [merged] cgroup-introduce-coalesce-css_get-and-css_put.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:10 -0400
Message-ID: <201003150658.o2F6whS5016477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934967Ab0COG66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: introduce coalesce css_get() and css_put()
has been removed from the -mm tree.  Its filename was
     cgroup-introduce-coalesce-css_get-and-css_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: introduce coalesce css_get() and css_put()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Current css_get() and css_put() increment/decrement css->refcnt one by
one.

This patch add a new function __css_get(), which takes "count" as a arg
and increment the css->refcnt by "count".  And this patch also add a new
arg("count") to __css_put() and change the function to decrement the
css->refcnt by "count".

These coalesce version of __css_get()/__css_put() will be used to improve
performance of memcg's moving charge feature later, where instead of
calling css_get()/css_put() repeatedly, these new functions will be used.

No change is needed for current users of css_get()/css_put().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   12 +++++++++---
 kernel/cgroup.c        |    5 +++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-introduce-coalesce-css_get-and-css_put include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-introduce-coalesce-css_get-and-css_put
+++ a/include/linux/cgroup.h
@@ -76,6 +76,12 @@ enum {
 	CSS_REMOVED, /* This CSS is dead */
 };
 
+/* Caller must verify that the css is not for root cgroup */
+static inline void __css_get(struct cgroup_subsys_state *css, int count)
+{
+	atomic_add(count, &css->refcnt);
+}
+
 /*
  * Call css_get() to hold a reference on the css; it can be used
  * for a reference obtained via:
@@ -87,7 +93,7 @@ static inline void css_get(struct cgroup
 {
 	/* We don't need to reference count the root state */
 	if (!test_bit(CSS_ROOT, &css->flags))
-		atomic_inc(&css->refcnt);
+		__css_get(css, 1);
 }
 
 static inline bool css_is_removed(struct cgroup_subsys_state *css)
@@ -118,11 +124,11 @@ static inline bool css_tryget(struct cgr
  * css_get() or css_tryget()
  */
 
-extern void __css_put(struct cgroup_subsys_state *css);
+extern void __css_put(struct cgroup_subsys_state *css, int count);
 static inline void css_put(struct cgroup_subsys_state *css)
 {
 	if (!test_bit(CSS_ROOT, &css->flags))
-		__css_put(css);
+		__css_put(css, 1);
 }
 
 /* bits in struct cgroup flags field */
diff -puN kernel/cgroup.c~cgroup-introduce-coalesce-css_get-and-css_put kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-introduce-coalesce-css_get-and-css_put
+++ a/kernel/cgroup.c
@@ -3746,12 +3746,13 @@ static void check_for_release(struct cgr
 	}
 }
 
-void __css_put(struct cgroup_subsys_state *css)
+/* Caller must verify that the css is not for root cgroup */
+void __css_put(struct cgroup_subsys_state *css, int count)
 {
 	struct cgroup *cgrp = css->cgroup;
 	int val;
 	rcu_read_lock();
-	val = atomic_dec_return(&css->refcnt);
+	val = atomic_sub_return(count, &css->refcnt);
 	if (val == 1) {
 		if (notify_on_release(cgrp)) {
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch

