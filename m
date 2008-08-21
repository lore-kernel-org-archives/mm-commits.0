From: akpm@linux-foundation.org
Subject: + cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:55:09 -0700
Message-ID: <200808212055.m7LKtAlH025450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023AbYHUUz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
has been added to the -mm tree.  Its filename is
     cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
From: Lai Jiangshan <laijs@cn.fujitsu.com>

put_css_set_taskexit may be called when find_css_set is called on other
cpu.  And the race will occur:

put_css_set_taskexit side                    find_css_set side

                                        |
atomic_dec_and_test(&kref->refcount)    |
    /* kref->refcount = 0 */            |
....................................................................
                                        |  read_lock(&css_set_lock)
                                        |  find_existing_css_set
                                        |  get_css_set
                                        |  read_unlock(&css_set_lock);
....................................................................
__release_css_set                       |
....................................................................
                                        | /* use a released css_set */
                                        |

[put_css_set is the same. But in the current code, all put_css_set are
put into cgroup mutex critical region as the same as find_css_set.]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set
+++ a/kernel/cgroup.c
@@ -241,7 +241,6 @@ static void unlink_css_set(struct css_se
 	struct cg_cgroup_link *link;
 	struct cg_cgroup_link *saved_link;
 
-	write_lock(&css_set_lock);
 	hlist_del(&cg->hlist);
 	css_set_count--;
 
@@ -251,8 +250,6 @@ static void unlink_css_set(struct css_se
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
-
-	write_unlock(&css_set_lock);
 }
 
 static void __release_css_set(struct kref *k, int taskexit)
@@ -260,7 +257,13 @@ static void __release_css_set(struct kre
 	int i;
 	struct css_set *cg = container_of(k, struct css_set, ref);
 
+	write_lock(&css_set_lock);
+	if (atomic_read(&k->refcount) > 0) {
+		write_unlock(&css_set_lock);
+		return;
+	}
 	unlink_css_set(cg);
+	write_unlock(&css_set_lock);
 
 	rcu_read_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
@@ -410,6 +413,20 @@ static struct css_set *find_css_set(
 	 * the desired set */
 	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
+	/*
+	 * put_css_set[_taskexit]() may race with find_css_set(), in that
+	 * find_css_set() got the css_set after put_css_set() had released it.
+	 *
+	 * We should put the whole put_css_set[_taskexit]() into css_set_lock's
+	 * write_lock critical setion to avoid this race. But it will increase
+	 * overhead for do_exit().
+	 *
+	 * So we do not avoid this race but put it under control:
+	 * __release_css_set() will re-check the refcount
+	 * with css_set_lock held.
+	 *
+	 * This race may trigger the warnning in kref_get().
+	 */
 	if (res)
 		get_css_set(res);
 	read_unlock(&css_set_lock);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch

