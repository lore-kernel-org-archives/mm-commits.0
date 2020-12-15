Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0987C35296
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD4D222DA9
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgLPAAN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgLOX1P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:15 -0500
Date:   Tue, 15 Dec 2020 15:18:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074311;
        bh=X0JV6/+yULHawB53k5CIbwSKl09SqK1pM4UqHC/cZaY=;
        h=From:To:Subject:From;
        b=jXPcTWL7lX88MemBAWM8Hdoi28Nbjre/26IxgVjEnIDMSRPciWmHRouZMSK4Wzxr7
         /LXbvykdrsKgqRgz+3/GOsGvP/QAZYp6/Oi+s6CHVd9EpW3pHqMRNmj5+ZehwfCslb
         7zjidT9DjRZr8HBtJv+vNlbW0K6/92FRnUBrKtLw=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, tj@kernel.org
Subject:  [merged]
 cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
 removed from -mm tree
Message-ID: <20201215231831.xHVpN-Pj3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove obsoleted broken_hierarchy and warned_broken_hierarchy
has been removed from the -mm tree.  Its filename was
     cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: cgroup: remove obsoleted broken_hierarchy and warned_broken_hierarchy

With the deprecation of the non-hierarchical mode of the memory controller
there are no more examples of broken hierarchies left.

Let's remove the cgroup core code which was supposed to print warnings
about creating of broken hierarchies.

Link: https://lkml.kernel.org/r/20201110220800.929549-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup-defs.h |   15 ---------------
 kernel/cgroup/cgroup.c      |    7 -------
 2 files changed, 22 deletions(-)

--- a/include/linux/cgroup-defs.h~cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy
+++ a/include/linux/cgroup-defs.h
@@ -668,21 +668,6 @@ struct cgroup_subsys {
 	 */
 	bool threaded:1;
 
-	/*
-	 * If %false, this subsystem is properly hierarchical -
-	 * configuration, resource accounting and restriction on a parent
-	 * cgroup cover those of its children.  If %true, hierarchy support
-	 * is broken in some ways - some subsystems ignore hierarchy
-	 * completely while others are only implemented half-way.
-	 *
-	 * It's now disallowed to create nested cgroups if the subsystem is
-	 * broken and cgroup core will emit a warning message on such
-	 * cases.  Eventually, all subsystems will be made properly
-	 * hierarchical and this will go away.
-	 */
-	bool broken_hierarchy:1;
-	bool warned_broken_hierarchy:1;
-
 	/* the following two fields are initialized automtically during boot */
 	int id;
 	const char *name;
--- a/kernel/cgroup/cgroup.c~cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy
+++ a/kernel/cgroup/cgroup.c
@@ -5149,13 +5149,6 @@ static struct cgroup_subsys_state *css_c
 	if (err)
 		goto err_list_del;
 
-	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
-	    cgroup_parent(parent)) {
-		pr_warn("%s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
-			current->comm, current->pid, ss->name);
-		ss->warned_broken_hierarchy = true;
-	}
-
 	return css;
 
 err_list_del:
_

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

