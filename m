Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C05C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiBVEHo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:07:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiBVEHm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:07:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752DD6C90D
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3CF615AF
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E5DC340E8;
        Tue, 22 Feb 2022 04:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502770;
        bh=pZzKT4oaObeee0FGdGqqpbjZZnmgjbPKGmjaGH7TdTc=;
        h=Date:To:From:Subject:From;
        b=mdj7yg/V2q5yToqgvpVv37OaJOAF++RoXZurpjadfy4K3N3E5t4H4YkY44/xucz6W
         rNWCw8etnj1ss6117/T0M6XdFvDVzcXPuDyP5X2BMAydl06Z/uu5mg9dIQk6ke7wZK
         R8WeWcN729hdKnK/9dsFkuBYOZISZqbnWP4MWXv8=
Date:   Mon, 21 Feb 2022 20:06:10 -0800
To:     mm-commits@vger.kernel.org, longman@redhat.com, aquini@redhat.com,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ownerc-record-tgid.patch added to -mm tree
Message-Id: <20220222040610.B3E5DC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: record tgid
has been added to the -mm tree.  Its filename is
     mm-page_ownerc-record-tgid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_ownerc-record-tgid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ownerc-record-tgid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch
mm-page_ownerc-record-tgid.patch

