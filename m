Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2B9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiCYWnX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiCYWnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764E209A41
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 272EAB82A34
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB000C340ED;
        Fri, 25 Mar 2022 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248096;
        bh=FXCsVnbHdxjQERTa7IiNLSG1Hd/pCJYp2lnoR14VtLQ=;
        h=Date:To:From:Subject:From;
        b=esZNGjIAK09BmshEr8V6cN68/vUG1uIHJiqUcg2xfsc2aCaZ75AVnnBxhO0WycIPJ
         0GjjJ7et1CIU8dsMEFtPi0h2Wlf+8H+SISRVfJsFDxURiqT6NmO9cF+Vq9OkFm5HyD
         ZJarzTy4aC5Rh0VEGPmWgHdGZKGvvk5v7iWpMN0w=
Date:   Fri, 25 Mar 2022 15:41:36 -0700
To:     mm-commits@vger.kernel.org, longman@redhat.com, aquini@redhat.com,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_ownerc-record-tgid.patch removed from -mm tree
Message-Id: <20220325224136.CB000C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: record tgid
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-record-tgid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/page_owner.c: record tgid

In a single-threaded process, the pid in kernel task_struct is the same as
the tgid, which can mark the process of page allocation.  But in a
multithreaded process, only the task_struct of the thread leader has the
same pid as tgid, and the pids of other threads are different from tgid. 
Therefore, tgid is recorded to provide effective information for debugging
and data statistics of multithreaded programs.

This can also be achieved by observing the task name (executable file
name) for a specific process.  However, when the same program is started
multiple times, the task name is the same and the tgid is different. 
Therefore, in the debugging of multi-threaded programs, combined with the
task name and tgid, more accurate runtime information of a certain run of
the program can be obtained.

Link: https://lkml.kernel.org/r/20220219180450.2399-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Waiman Long <longman@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/page_owner.c~mm-page_ownerc-record-tgid
+++ a/mm/page_owner.c
@@ -31,6 +31,7 @@ struct page_owner {
 	u64 free_ts_nsec;
 	char comm[TASK_COMM_LEN];
 	pid_t pid;
+	pid_t tgid;
 };
 
 static bool page_owner_enabled = false;
@@ -165,6 +166,7 @@ static inline void __set_page_owner_hand
 		page_owner->gfp_mask = gfp_mask;
 		page_owner->last_migrate_reason = -1;
 		page_owner->pid = current->pid;
+		page_owner->tgid = current->tgid;
 		page_owner->ts_nsec = local_clock();
 		strlcpy(page_owner->comm, current->comm,
 			sizeof(page_owner->comm));
@@ -233,6 +235,7 @@ void __folio_copy_owner(struct folio *ne
 		old_page_owner->last_migrate_reason;
 	new_page_owner->handle = old_page_owner->handle;
 	new_page_owner->pid = old_page_owner->pid;
+	new_page_owner->tgid = old_page_owner->tgid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
 	strcpy(new_page_owner->comm, old_page_owner->comm);
@@ -383,11 +386,11 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d (%s), ts %llu ns, free_ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
-			page_owner->comm, page_owner->ts_nsec,
-			page_owner->free_ts_nsec);
+			page_owner->tgid, page_owner->comm,
+			page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
@@ -454,10 +457,10 @@ void __dump_page_owner(const struct page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
-		 page_owner->pid, page_owner->comm, page_owner->ts_nsec,
-		 page_owner->free_ts_nsec);
+		 page_owner->pid, page_owner->tgid, page_owner->comm,
+		 page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -669,3 +672,4 @@ static int __init pageowner_init(void)
 	return 0;
 }
 late_initcall(pageowner_init)
+
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


