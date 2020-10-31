Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB5FC388F9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3BD9206ED
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604173457;
	bh=PF7HHs6s5uHupb8wo0etUxavP7wbxvmT5P/N1awWRcg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ni9FbXX6+yRyGnaGzAS+l2L2sS+M33YWJT7bW2TRAbZ0H9Bz4LSN/H0petkVPoT+9
	 NBEU9fuCG7nDD0NHf+mlKYpNP7wMTCoBjH3FX8ssPHiDoVM6/oRqAPG/EBdD6l/53A
	 GBMqurBIOjg94iYKLsjcNVO0Jj3IVSznzBVq6wto=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgJaToR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJaToR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 15:44:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD37A206E3;
        Sat, 31 Oct 2020 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173456;
        bh=PF7HHs6s5uHupb8wo0etUxavP7wbxvmT5P/N1awWRcg=;
        h=Date:From:To:Subject:From;
        b=WSsB3zkZyMC/Fyt7AHMoIcI8tqxdLzdYn6BVGxtdXB6rFgDqWDbALG9R+eygILIqw
         mFb+430UYf8ZixUU0l7xZQwZrEtGulP84aWWPC+WPeUbrqJCaquFxFfNI3bYkwuDsg
         6AUy5FUo4m8d3boFj4CXARYX4EvksvMq2v77pw4g=
Date:   Sat, 31 Oct 2020 12:44:16 -0700
From:   akpm@linux-foundation.org
To:     mhocko@kernel.org, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  +
 mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch added
 to -mm tree
Message-ID: <20201031194416.HxKzaee5T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: change comment and rename is_dump_unreclaim_slabs()
has been added to the -mm tree.  Its filename is
     mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch

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
Subject: mm/oom_kill: change comment and rename is_dump_unreclaim_slabs()

Change the comment of is_dump_unreclaim_slabs(), it just check whether
nr_unreclaimable slabs amount is greater than user memory, and explain why
we dump unreclaim slabs.

Rename it to should_dump_unreclaim_slab() maybe better.

Link: https://lkml.kernel.org/r/20201030182704.GA53949@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs
+++ a/mm/oom_kill.c
@@ -170,11 +170,13 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
-/*
- * Print out unreclaimble slabs info when unreclaimable slabs amount is greater
- * than all user memory (LRU pages)
- */
-static bool is_dump_unreclaim_slabs(void)
+/**
+ * Check whether unreclaimable slab amount is greater than
+ * all user memory(LRU pages).
+ * dump_unreclaimable_slab() could help in the case that
+ * oom due to too much unreclaimable slab used by kernel.
+*/
+static bool should_dump_unreclaim_slab(void)
 {
 	unsigned long nr_lru;
 
@@ -463,7 +465,7 @@ static void dump_header(struct oom_contr
 		mem_cgroup_print_oom_meminfo(oc->memcg);
 	else {
 		show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask);
-		if (is_dump_unreclaim_slabs())
+		if (should_dump_unreclaim_slab())
 			dump_unreclaimable_slab();
 	}
 	if (sysctl_oom_dump_tasks)
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch

