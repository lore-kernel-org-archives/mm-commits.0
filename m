Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D72C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 02:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjK2Cl4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 21:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjK2Clz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 21:41:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816AB1988
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 18:42:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCABC433C9;
        Wed, 29 Nov 2023 02:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701225721;
        bh=6HAD9XRfXc9ZY7OeDiVq7xwtgHeCYlsEHnCR7u6xWnw=;
        h=Date:To:From:Subject:From;
        b=x69mT5wQyctWQF5wzWX+XH2o0/ddWHMb3VxgkbS0/cgggiPEyXey3AodgAo/u2oQA
         S75+Jc7AkqsBZNApNAuM/DpUT1wqrUawMf72ilaB9xSQvxXjdRcOxAI/HK1gSrodDo
         H9Qsiivwk3ffrv4RsUmLRJXSFirklzra0PBy+sMg=
Date:   Tue, 28 Nov 2023 18:42:00 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-add-a-new-function-to-traverse-online-only-memcg-hierarchy.patch added to mm-unstable branch
Message-Id: <20231129024201.1CCABC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: add a new function to traverse online-only memcg hierarchy
has been added to the -mm mm-unstable branch.  Its filename is
     memcontrol-add-a-new-function-to-traverse-online-only-memcg-hierarchy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-add-a-new-function-to-traverse-online-only-memcg-hierarchy.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: memcontrol: add a new function to traverse online-only memcg hierarchy
Date: Mon, 27 Nov 2023 15:45:56 -0800

The new zswap writeback scheme requires an online-only memcg hierarchy
traversal. Add this functionality via the new mem_cgroup_iter_online()
function - the old mem_cgroup_iter() is a special case of this new
function.

Link: https://lkml.kernel.org/r/20231127234600.2971029-3-nphamcs@gmail.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++++++++++++
 mm/memcontrol.c            |   29 +++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 4 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-add-a-new-function-to-traverse-online-only-memcg-hierarchy
+++ a/include/linux/memcontrol.h
@@ -833,6 +833,10 @@ static inline void mem_cgroup_put(struct
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *,
 				   struct mem_cgroup *,
 				   struct mem_cgroup_reclaim_cookie *);
+struct mem_cgroup *mem_cgroup_iter_online(struct mem_cgroup *root,
+				   struct mem_cgroup *prev,
+				   struct mem_cgroup_reclaim_cookie *reclaim,
+				   bool online);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
@@ -1385,6 +1389,15 @@ mem_cgroup_iter(struct mem_cgroup *root,
 {
 	return NULL;
 }
+
+static inline struct mem_cgroup *
+mem_cgroup_iter_online(struct mem_cgroup *root,
+		struct mem_cgroup *prev,
+		struct mem_cgroup_reclaim_cookie *reclaim,
+		bool online)
+{
+	return NULL;
+}
 
 static inline void mem_cgroup_iter_break(struct mem_cgroup *root,
 					 struct mem_cgroup *prev)
--- a/mm/memcontrol.c~memcontrol-add-a-new-function-to-traverse-online-only-memcg-hierarchy
+++ a/mm/memcontrol.c
@@ -1111,10 +1111,11 @@ again:
 }
 
 /**
- * mem_cgroup_iter - iterate over memory cgroup hierarchy
+ * mem_cgroup_iter_online - iterate over memory cgroup hierarchy
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
  * @reclaim: cookie for shared reclaim walks, NULL for full walks
+ * @online: whether to skip offline memcgs
  *
  * Returns references to children of the hierarchy below @root, or
  * @root itself, or %NULL after a full round-trip.
@@ -1123,13 +1124,16 @@ again:
  * invocations for reference counting, or use mem_cgroup_iter_break()
  * to cancel a hierarchy walk before the round-trip is complete.
  *
+ * Caller can skip offline memcgs by passing true for @online.
+ *
  * Reclaimers can specify a node in @reclaim to divide up the memcgs
  * in the hierarchy among all concurrent reclaimers operating on the
  * same node.
  */
-struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
+struct mem_cgroup *mem_cgroup_iter_online(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
-				   struct mem_cgroup_reclaim_cookie *reclaim)
+				   struct mem_cgroup_reclaim_cookie *reclaim,
+				   bool online)
 {
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
@@ -1199,7 +1203,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 * is provided by the caller, so we know it's alive
 		 * and kicking, and don't take an extra reference.
 		 */
-		if (css == &root->css || css_tryget(css)) {
+		if (css == &root->css || (!online && css_tryget(css)) ||
+				css_tryget_online(css)) {
 			memcg = mem_cgroup_from_css(css);
 			break;
 		}
@@ -1229,6 +1234,22 @@ out_unlock:
 }
 
 /**
+ * mem_cgroup_iter - iterate over memory cgroup hierarchy
+ * @root: hierarchy root
+ * @prev: previously returned memcg, NULL on first invocation
+ * @reclaim: cookie for shared reclaim walks, NULL for full walks
+ *
+ * Perform an iteration on the memory cgroup hierarchy without skipping
+ * offline memcgs.
+ */
+struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
+				   struct mem_cgroup *prev,
+				   struct mem_cgroup_reclaim_cookie *reclaim)
+{
+	return mem_cgroup_iter_online(root, prev, reclaim, false);
+}
+
+/**
  * mem_cgroup_iter_break - abort a hierarchy walk prematurely
  * @root: hierarchy root
  * @prev: last visited hierarchy member as returned by mem_cgroup_iter()
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-add-a-new-function-to-traverse-online-only-memcg-hierarchy.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

