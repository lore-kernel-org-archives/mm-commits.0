Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08070C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 23:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B323C20796
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 23:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601681108;
	bh=9XULaon/DQ3YI0FIXpL3o11PjebmQ3SlFJ1eKz89hSw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=j5G3tIk1x+8lP+mWsThDQu07SZ7T18M/PUYk0PLLFSV46tIuOsSEyZUovyGWy/+dB
	 GdvcVWC7bx/vrL8XsqLUjmySV/hbYlc/ZfxojKYk++9rY9QCnMwvKFDEvhWIie+/0X
	 EH2W7Bp3Ah1P6+kP2Yjcw6eytydbKhafwjFTzbBw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgJBXZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 19:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBXZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 19:25:07 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B64206FA;
        Fri,  2 Oct 2020 23:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601681106;
        bh=9XULaon/DQ3YI0FIXpL3o11PjebmQ3SlFJ1eKz89hSw=;
        h=Date:From:To:Subject:From;
        b=Y7GCwro7er5wyBytDCsdhfyLJmR1fR6s9LScN1VSca5yaIrPdu+KnN7x9T8PY0G3A
         p+RzyH7ZSddmWiVAKc3Umi4VaqvChkNpGuu6ULCgJGS0I4KYO1QVBhgcaztf/01Ka4
         V+8IwwLvw3D2aLp/mTG73fGpeawuzY3psvBlyA8U=
Date:   Fri, 02 Oct 2020 16:25:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com,
        hannes@cmpxchg.org, sh_def@163.com
Subject:  [to-be-updated]
 mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch removed from -mm
 tree
Message-ID: <20201002232505.dGqZB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some comments in page_alloc.c and mempolicy.c
has been removed from the -mm tree.  Its filename was
     mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm: fix some comments in page_alloc.c and mempolicy.c

1. The cpuset.c has been moved from kernel/cpuset.c to
   kernel/cgroup/cpuset.c long time ago, but the comment is stale, so we
   update it.

2. get_page_from_freelist() may alloc many pages according to order,
   we may use pages for better.

Link: https://lkml.kernel.org/r/20200925160650.GA42847@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    2 +-
 mm/mempolicy.c         |    2 +-
 mm/page_alloc.c        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cgroup/cpuset.c~mm-fix-some-comments-in-page_allocc-and-mempolicyc
+++ a/kernel/cgroup/cpuset.c
@@ -1,5 +1,5 @@
 /*
- *  kernel/cpuset.c
+ *  kernel/cgroup/cpuset.c
  *
  *  Processor and Memory placement constraints for sets of tasks.
  *
--- a/mm/mempolicy.c~mm-fix-some-comments-in-page_allocc-and-mempolicyc
+++ a/mm/mempolicy.c
@@ -2291,7 +2291,7 @@ int vma_dup_policy(struct vm_area_struct
  * rebinds the mempolicy its copying by calling mpol_rebind_policy()
  * with the mems_allowed returned by cpuset_mems_allowed().  This
  * keeps mempolicies cpuset relative after its cpuset moves.  See
- * further kernel/cpuset.c update_nodemask().
+ * further kernel/cgroup/cpuset.c update_nodemask().
  *
  * current's mempolicy may be rebinded by the other task(the task that changes
  * cpuset's mems), so we needn't do rebind work for current task.
--- a/mm/page_alloc.c~mm-fix-some-comments-in-page_allocc-and-mempolicyc
+++ a/mm/page_alloc.c
@@ -3734,7 +3734,7 @@ static inline unsigned int current_alloc
 
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
- * a page.
+ * pages.
  */
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
@@ -3748,7 +3748,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
+	 * See also __cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
_

Patches currently in -mm which might be from sh_def@163.com are

mmkmemleak-testc-move-kmemleak-testc-to-samples-dir.patch
mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch
mm-vmallocc-fix-the-comment-of-find_vm_area.patch
mm-vmscan-fix-comments-for-isolate_lru_page.patch
mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch

