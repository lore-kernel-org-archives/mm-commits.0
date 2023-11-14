Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48589C47DDD
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjKNX24 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjKNX24 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:28:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB77B3
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:28:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBFBC433C8;
        Tue, 14 Nov 2023 23:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700004532;
        bh=hNCfN4K2PKnGFxhMuh1gySuhplugPS6qmvKV9CspB6I=;
        h=Date:To:From:Subject:From;
        b=BVX7of4nxOSQB/Q590sgCVW/0F/92ppwtV4y+TRjxYT9Gx0fLV/tlWuOPSoIiFTGn
         fy6BcYBln5aV1yrAjWXqPI25BhFYacO888R+1p/1wrJPO0Hx9ekKH9lC1jSzVDhMYf
         T5HqzCJDWkHqLr13mgdInJxD3pzVScOqqvR0ZuvU=
Date:   Tue, 14 Nov 2023 15:28:52 -0800
To:     mm-commits@vger.kernel.org, v-songbaohua@oppo.com,
        shikemeng@huaweicloud.com, quic_yingangl@quicinc.com,
        iamjoonsoo.kim@lge.com, audra@redhat.com, 42.hyeyoo@gmail.com,
        21cnbao@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch added to mm-unstable branch
Message-Id: <20231114232852.BFBFBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: record and dump free_pid and free_tgid
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <21cnbao@gmail.com>
Subject: mm/page_owner: record and dump free_pid and free_tgid
Date: Tue, 14 Nov 2023 16:42:02 +1300

While investigating some complex memory allocation and free bugs
especially in multi-processes and multi-threads cases, from time to time,
I feel the free stack isn't sufficient as a page can be freed by processes
or threads other than the one allocating it.  And other processes and
threads which free the page often have the exactly same free stack with
the one allocating the page.  We can't know who free the page only through
the free stack though the current page_owner does tell us the pid and tgid
of the one allocating the page.  This makes the bug investigation often
hard.

So this patch adds free pid and tgid in page_owner, so that we can easily
figure out if the freeing is crossing processes or threads.

Link: https://lkml.kernel.org/r/20231114034202.73098-1-v-songbaohua@oppo.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Audra Mitchell <audra@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kassey Li <quic_yingangl@quicinc.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-record-and-dump-free_pid-and-free_tgid
+++ a/mm/page_owner.c
@@ -32,6 +32,8 @@ struct page_owner {
 	char comm[TASK_COMM_LEN];
 	pid_t pid;
 	pid_t tgid;
+	pid_t free_pid;
+	pid_t free_tgid;
 };
 
 static bool page_owner_enabled __initdata;
@@ -152,6 +154,8 @@ void __reset_page_owner(struct page *pag
 		page_owner = get_page_owner(page_ext);
 		page_owner->free_handle = handle;
 		page_owner->free_ts_nsec = free_ts_nsec;
+		page_owner->free_pid = current->pid;
+		page_owner->free_tgid = current->tgid;
 		page_ext = page_ext_next(page_ext);
 	}
 	page_ext_put(page_ext);
@@ -253,6 +257,8 @@ void __folio_copy_owner(struct folio *ne
 	new_page_owner->handle = old_page_owner->handle;
 	new_page_owner->pid = old_page_owner->pid;
 	new_page_owner->tgid = old_page_owner->tgid;
+	new_page_owner->free_pid = old_page_owner->free_pid;
+	new_page_owner->free_tgid = old_page_owner->free_tgid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
 	strcpy(new_page_owner->comm, old_page_owner->comm);
@@ -495,7 +501,8 @@ void __dump_page_owner(const struct page
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free stack trace:\n");
+		pr_alert("page last free pid %d tgid %d stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid);
 		stack_depot_print(handle);
 	}
 
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch

