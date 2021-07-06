Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E99C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8EA61C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhGFTVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhGFTVm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F9461C91;
        Tue,  6 Jul 2021 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599143;
        bh=/ifDslNHHDGMB2mm85pogZdJhGyO4Jupy4+TT4xV/PE=;
        h=Date:From:To:Subject:From;
        b=i/y2SCIDwftafkTsc2cQsVJDzwg66f7IoHAn4xPTF4hMLoZAIDxO1PHiM2pInd0yF
         V/LN79vYd26B2uqzynJHIraO/xjGa/yDCAmiNFebDkVI3rPig2oSJZvGd0vq0QqGdB
         9IKgrEWU5RQBNwVRr9nt2lbEAygjxTydDZhmvgUs=
Date:   Tue, 06 Jul 2021 12:19:02 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rientjes@google.com, vbabka@suse.cz,
        ying.huang@intel.com
Subject:  [merged]
 =?US-ASCII?Q?mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and?=
 =?US-ASCII?Q?-set=5Fmempolicy.patch?= removed from -mm tree
Message-ID: <20210706191902.we3J5RSZI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy

Currently the kernel_mbind() and kernel_set_mempolicy() do almost the same
operation for parameter sanity check.

Add a helper function to unify the code to reduce the redundancy, and make
it easier for changing the sanity check code in future.

[thanks to David Rientjes for suggesting using helper function instead of
macro].

[feng.tang@intel.com: add comment]
  Link: https://lkml.kernel.org/r/1622560492-1294-4-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/1622469956-82897-4-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

 mm/mempolicy.c |   48 +++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy
+++ a/mm/mempolicy.c
@@ -1441,26 +1441,38 @@ static int copy_nodes_to_user(unsigned l
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
 
+/* Basic parameter sanity check used by both mbind() and set_mempolicy() */
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
@@ -1474,20 +1486,20 @@ SYSCALL_DEFINE6(mbind, unsigned long, st
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


