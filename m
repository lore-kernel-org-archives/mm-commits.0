Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77446C2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4920022CF7
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgLOX7o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729688AbgLOXZn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:43 -0500
Date:   Tue, 15 Dec 2020 15:18:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074308;
        bh=qQytjrD6qPHcvs1K5Z7EZNmLTg1zd3egLVS2KwAlSwQ=;
        h=From:To:Subject:From;
        b=yC3J/l8F0ZEwyKxvdOIpALJZjSu/+5rKLIXRlWFdNOqrR+4K7XUxEA+9QEtM4kv80
         FE1WAlfg4YnWD/ophnso7pP5boFSuC98DduulK7J+oXaCfze7sJZm+AaoYOoXRAX/l
         +M7pbW++087cfWllMJtu58K900Qfj0pkw6PECpoM=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, tj@kernel.org
Subject:  [merged]
 docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
 removed from -mm tree
Message-ID: <20201215231828.AepRQfRmg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: cgroup-v1: reflect the deprecation of the non-hierarchical mode
has been removed from the -mm tree.  Its filename was
     docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: docs: cgroup-v1: reflect the deprecation of the non-hierarchical mode

Update cgroup v1 docs after the deprecation of the non-hierarchical mode
of the memory controller.

Link: https://lkml.kernel.org/r/20201110220800.929549-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memcg_test.rst |    8 --
 Documentation/admin-guide/cgroup-v1/memory.rst     |   42 +++--------
 2 files changed, 17 insertions(+), 33 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst~docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode
+++ a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -219,13 +219,11 @@ Under below explanation, we assume CONFI
 
 	This is an easy way to test page migration, too.
 
-9.5 mkdir/rmdir
----------------
+9.5 nested cgroups
+------------------
 
-	When using hierarchy, mkdir/rmdir test should be done.
-	Use tests like the following::
+	Use tests like the following for testing nested cgroups::
 
-		echo 1 >/opt/cgroup/01/memory/use_hierarchy
 		mkdir /opt/cgroup/01/child_a
 		mkdir /opt/cgroup/01/child_b
 
--- a/Documentation/admin-guide/cgroup-v1/memory.rst~docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -77,6 +77,8 @@ Brief summary of control files.
  memory.soft_limit_in_bytes	     set/show soft limit of memory usage
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.force_empty		     trigger forced page reclaim
  memory.pressure_level		     set memory pressure notifications
  memory.swappiness		     set/show swappiness parameter of vmscan
@@ -495,16 +497,13 @@ cgroup might have some charge associated
 tasks have migrated away from it. (because we charge against pages, not
 against tasks.)
 
-We move the stats to root (if use_hierarchy==0) or parent (if
-use_hierarchy==1), and no change on the charge except uncharging
+We move the stats to parent, and no change on the charge except uncharging
 from the child.
 
 Charges recorded in swap information is not updated at removal of cgroup.
 Recorded information is discarded and a cgroup which uses swap (swapcache)
 will be charged as a new owner of it.
 
-About use_hierarchy, see Section 6.
-
 5. Misc. interfaces
 ===================
 
@@ -527,8 +526,6 @@ About use_hierarchy, see Section 6.
   write will still return success. In this case, it is expected that
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
-  About use_hierarchy, see Section 6.
-
 5.2 stat file
 -------------
 
@@ -675,32 +672,21 @@ hierarchy::
 		      d   e
 
 In the diagram above, with hierarchical accounting enabled, all memory
-usage of e, is accounted to its ancestors up until the root (i.e, c and root),
-that has memory.use_hierarchy enabled. If one of the ancestors goes over its
-limit, the reclaim algorithm reclaims from the tasks in the ancestor and the
-children of the ancestor.
-
-6.1 Enabling hierarchical accounting and reclaim
-------------------------------------------------
+usage of e, is accounted to its ancestors up until the root (i.e, c and root).
+If one of the ancestors goes over its limit, the reclaim algorithm reclaims
+from the tasks in the ancestor and the children of the ancestor.
+
+6.1 Hierarchical accounting and reclaim
+---------------------------------------
+
+Hierarchical accounting is enabled by default. Disabling the hierarchical
+accounting is deprecated. An attempt to do it will result in a failure
+and a warning printed to dmesg.
 
-A memory cgroup by default disables the hierarchy feature. Support
-can be enabled by writing 1 to memory.use_hierarchy file of the root cgroup::
+For compatibility reasons writing 1 to memory.use_hierarchy will always pass::
 
 	# echo 1 > memory.use_hierarchy
 
-The feature can be disabled by::
-
-	# echo 0 > memory.use_hierarchy
-
-NOTE1:
-       Enabling/disabling will fail if either the cgroup already has other
-       cgroups created below it, or if the parent cgroup has use_hierarchy
-       enabled.
-
-NOTE2:
-       When panic_on_oom is set to "2", the whole system will panic in
-       case of an OOM event in any cgroup.
-
 7. Soft limits
 ==============
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

