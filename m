Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611FDC4708F
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403C561005
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhEaVn3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232227AbhEaVn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:43:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D8496101C;
        Mon, 31 May 2021 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622497306;
        bh=JjonEVJt0CceejJfTD/9El8H002xfTCFoOoDTnzW2Wc=;
        h=Date:From:To:Subject:From;
        b=UVaghbjBXnJCv9hRZc4UclA40TAygeEAzCNgjRDusSDavKZZEZ9zVUR8dzurjeMyU
         BRrvroI6T6YBCCRZWfaQq4x3o2rX/X37jkYWAZ5EV9AG7GyB/DnEKER7VEZKa9XXgN
         qEo2GIi/x+ZeqxxG1cDTWWaRUm3jxxGEYJ5UOX2w=
Date:   Mon, 31 May 2021 14:41:45 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and?=
 =?US-ASCII?Q?-set=5Fmempolicy.patch?= added to -mm tree
Message-ID: <20210531214145.fqmy1Z3bn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy
has been added to the -mm tree.  Its filename is
     mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy

Currently the kernel_mbind() and kernel_set_mempolicy() do almost the same
operation for parameter sanity check.

Add a helper function to unify the code to reduce the redundancy, and make
it easier for changing the pre-processing code in future.

[thanks to David Rientjes for suggesting using helper function instead of
macro]

Link: https://lkml.kernel.org/r/1622469956-82897-4-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy
+++ a/mm/mempolicy.c
@@ -1444,26 +1444,37 @@ static int copy_nodes_to_user(unsigned l
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
 
+static inline int sanitize_mpol_flags(int *mode, unsigned short *flags)
+{
+	*flags = *mode & MPOL_MODE_FLAGS;
+	*mode &= ~MPOL_MODE_FLAGS;
+	if ((unsigned int)(*mode) >= MPOL_MAX)
+		return -EINVAL;
+	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
+		return -EINVAL;
+
+	return 0;
+}
+
 static long kernel_mbind(unsigned long start, unsigned long len,
 			 unsigned long mode, const unsigned long __user *nmask,
 			 unsigned long maxnode, unsigned int flags)
 {
+	unsigned short mode_flags;
 	nodemask_t nodes;
+	int lmode = mode;
 	int err;
-	unsigned short mode_flags;
 
 	start = untagged_addr(start);
-	mode_flags = mode & MPOL_MODE_FLAGS;
-	mode &= ~MPOL_MODE_FLAGS;
-	if (mode >= MPOL_MAX)
-		return -EINVAL;
-	if ((mode_flags & MPOL_F_STATIC_NODES) &&
-	    (mode_flags & MPOL_F_RELATIVE_NODES))
-		return -EINVAL;
+	err = sanitize_mpol_flags(&lmode, &mode_flags);
+	if (err)
+		return err;
+
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_mbind(start, len, mode, mode_flags, &nodes, flags);
+
+	return do_mbind(start, len, lmode, mode_flags, &nodes, flags);
 }
 
 SYSCALL_DEFINE6(mbind, unsigned long, start, unsigned long, len,
@@ -1477,20 +1488,20 @@ SYSCALL_DEFINE6(mbind, unsigned long, st
 static long kernel_set_mempolicy(int mode, const unsigned long __user *nmask,
 				 unsigned long maxnode)
 {
-	int err;
+	unsigned short mode_flags;
 	nodemask_t nodes;
-	unsigned short flags;
+	int lmode = mode;
+	int err;
+
+	err = sanitize_mpol_flags(&lmode, &mode_flags);
+	if (err)
+		return err;
 
-	flags = mode & MPOL_MODE_FLAGS;
-	mode &= ~MPOL_MODE_FLAGS;
-	if ((unsigned int)mode >= MPOL_MAX)
-		return -EINVAL;
-	if ((flags & MPOL_F_STATIC_NODES) && (flags & MPOL_F_RELATIVE_NODES))
-		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_set_mempolicy(mode, flags, &nodes);
+
+	return do_set_mempolicy(lmode, mode_flags, &nodes);
 }
 
 SYSCALL_DEFINE3(set_mempolicy, int, mode, const unsigned long __user *, nmask,
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch

