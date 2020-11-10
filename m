Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F21C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D20E207D3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpB9jK0i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbgKJWWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732177AbgKJWWM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 17:22:12 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA9CA206B2;
        Tue, 10 Nov 2020 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605046931;
        bh=yHKc/y+1eNsWOM9Njm073cPZodsAAUb3GhybF983nLs=;
        h=Date:From:To:Subject:From;
        b=QpB9jK0iXtsQvq/UVkNEL0qOeXzGJpAPq4Skc23M2CF95MOUYFCk7s1fRdYaosP56
         Qz+rGslAzxnvrSTnncxcjCjAsJ63wie0hk1VAWCSJKVJhE8NvZFxKXaUKHFVU1GdF4
         3L+c9GYLeE6qTaHZG39xKUbD3tEFwxfewcXOULFM=
Date:   Tue, 10 Nov 2020 14:22:10 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, tj@kernel.org
Subject:  +
 cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
 added to -mm tree
Message-ID: <20201110222210.5tmAlDaxS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove obsoleted broken_hierarchy and warned_broken_hierarchy
has been added to the -mm tree.  Its filename is
     cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

