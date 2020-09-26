Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D09C4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 117592087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087438;
	bh=TdJbZWzTxWsmb01ZRanSH1Dpy/DWe3BzxXoTtlybNXc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ymvVMmxUDL8EgThkDMD87YBGgWksi7WEnFdW0PrSL7MSBoQd108UEt82qOphA2EBt
	 vXDApSEOH60zWqU+Qnpy5rtyb6k1tWZtEO0YK9pzOxu/rw6CdULK29ASOB8bsEqMv3
	 2hQUI0EcDGKpndT72DtgCDm1QEjDtLD91TnC+7yU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgIZCah (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZCah (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:30:37 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4158206D4;
        Sat, 26 Sep 2020 02:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087437;
        bh=TdJbZWzTxWsmb01ZRanSH1Dpy/DWe3BzxXoTtlybNXc=;
        h=Date:From:To:Subject:From;
        b=BU8A+ycAU189SU2nWhenrM6LVhz3lDN4gk8tvOFEcTnDWLvWFZYrtDaz9ivvYUWO7
         mGVhr/oo7s+ZTEWodGdT+v3NWfaL5L0naXpQvYvKH9f9n9XubAYAnEcGNP4CWvTGJV
         oUxTHLveQu/yRIrSAUTobZk9++MTPR4VN1E593pM=
Date:   Fri, 25 Sep 2020 19:30:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com,
        hannes@cmpxchg.org, sh_def@163.com
Subject:  + mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch
 added to -mm tree
Message-ID: <20200926023036.4OiPW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some comments in page_alloc.c and mempolicy.c
has been added to the -mm tree.  Its filename is
     mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3720,7 +3720,7 @@ static inline unsigned int current_alloc
 
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
- * a page.
+ * pages.
  */
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
@@ -3734,7 +3734,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
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
mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

