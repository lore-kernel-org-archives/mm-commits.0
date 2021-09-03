Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDDEC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C640610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhICVCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350431AbhICVCP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8287960EE3;
        Fri,  3 Sep 2021 21:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702875;
        bh=7C2sS2+VR2n9x+6Te1knfdiFH11R1xLgQw76DcL82fc=;
        h=Date:From:To:Subject:From;
        b=i6lxI5Obs9H2V8tt82naLg088xv8UPyMTmTsSGJGXGsvgxQTxrwf80lGQ8f8hIMUU
         ECVz6rG+ZEUHZPvPXGtAcbVwBY7yzVB+5slWswTnx2FFaM/oh7RQS7qHj4BINXtegR
         7I4V+Fnb9XSApWMb5b+7fW4O8s8zcwJwY5C6pBvQ=
Date:   Fri, 03 Sep 2021 14:01:14 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  [merged]
 mm-mempolicy-advertise-new-mpol_preferred_many.patch removed from -mm tree
Message-ID: <20210903210114.gXYkPq84q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: advertise new MPOL_PREFERRED_MANY
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-advertise-new-mpol_preferred_many.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/mempolicy: advertise new MPOL_PREFERRED_MANY

Adds a new mode to the existing mempolicy modes, MPOL_PREFERRED_MANY.

MPOL_PREFERRED_MANY will be adequately documented in the internal
admin-guide with this patch.  Eventually, the man pages for mbind(2),
get_mempolicy(2), set_mempolicy(2) and numactl(8) will also have text
about this mode.  Those shall contain the canonical reference.

NUMA systems continue to become more prevalent.  New technologies like
PMEM make finer grain control over memory access patterns increasingly
desirable.  MPOL_PREFERRED_MANY allows userspace to specify a set of nodes
that will be tried first when performing allocations.  If those
allocations fail, all remaining nodes will be tried.  It's a straight
forward API which solves many of the presumptive needs of system
administrators wanting to optimize workloads on such machines.  The mode
will work either per VMA, or per thread.

[Michal Hocko: refine kernel doc for MPOL_PREFERRED_MANY]
Link: https://lore.kernel.org/r/20200630212517.308045-13-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1627970362-61305-5-git-send-email-feng.tang@intel.com
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numa_memory_policy.rst |   15 +++++++---
 mm/mempolicy.c                                      |    7 ----
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/numa_memory_policy.rst~mm-mempolicy-advertise-new-mpol_preferred_many
+++ a/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -245,6 +245,13 @@ MPOL_INTERLEAVED
 	address range or file.  During system boot up, the temporary
 	interleaved system default policy works in this mode.
 
+MPOL_PREFERRED_MANY
+	This mode specifices that the allocation should be preferrably
+	satisfied from the nodemask specified in the policy. If there is
+	a memory pressure on all nodes in the nodemask, the allocation
+	can fall back to all existing numa nodes. This is effectively
+	MPOL_PREFERRED allowed for a mask rather than a single node.
+
 NUMA memory policy supports the following optional mode flags:
 
 MPOL_F_STATIC_NODES
@@ -253,10 +260,10 @@ MPOL_F_STATIC_NODES
 	nodes changes after the memory policy has been defined.
 
 	Without this flag, any time a mempolicy is rebound because of a
-	change in the set of allowed nodes, the node (Preferred) or
-	nodemask (Bind, Interleave) is remapped to the new set of
-	allowed nodes.  This may result in nodes being used that were
-	previously undesired.
+        change in the set of allowed nodes, the preferred nodemask (Preferred
+        Many), preferred node (Preferred) or nodemask (Bind, Interleave) is
+        remapped to the new set of allowed nodes.  This may result in nodes
+        being used that were previously undesired.
 
 	With this flag, if the user-specified nodes overlap with the
 	nodes allowed by the task's cpuset, then the memory policy is
--- a/mm/mempolicy.c~mm-mempolicy-advertise-new-mpol_preferred_many
+++ a/mm/mempolicy.c
@@ -1463,12 +1463,7 @@ static inline int sanitize_mpol_flags(in
 	*flags = *mode & MPOL_MODE_FLAGS;
 	*mode &= ~MPOL_MODE_FLAGS;
 
-	/*
-	 * The check should be 'mode >= MPOL_MAX', but as 'prefer_many'
-	 * is not fully implemented, don't permit it to be used for now,
-	 * and the logic will be restored in following patch
-	 */
-	if ((unsigned int)(*mode) >=  MPOL_PREFERRED_MANY)
+	if ((unsigned int)(*mode) >=  MPOL_MAX)
 		return -EINVAL;
 	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
 		return -EINVAL;
_

Patches currently in -mm which might be from ben.widawsky@intel.com are


