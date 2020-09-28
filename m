Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D1FC4727C
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 958A621531
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601327678;
	bh=se3X6NKLh8AArP6MU96k5kHgo80p2Jh4i8BLOkO3Sok=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gnYyu9IuzA0x1XPCHFzXQn8dAsj+VhWEhNhOSH3EFnTihulHdNJ+6UD8sthPum0sF
	 xTCUz6M+a4m4Df9ZKS+aDvdO/H57uMB+UPCCTr0EYfRnKOoyUJOoQdxq+q2yOlWIah
	 saKqDtPtXzrSC8JODhxefzYaTnxzfAGqBpTF25h8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgI1VOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgI1VOi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 17:14:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6043208FE;
        Mon, 28 Sep 2020 21:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327676;
        bh=se3X6NKLh8AArP6MU96k5kHgo80p2Jh4i8BLOkO3Sok=;
        h=Date:From:To:Subject:From;
        b=rjvoFaoNXwwPdYjfwMyk/SZi0n6h3eJQaOUCpU0hXdOA9f8u9go+Xue2M1LzVZpOy
         D4TROE6ftuD3I6XVD6NZMo9J6EdoL9j7DLoUPA2VM1WBc4YbHWFU/OE8tlbt1P/3kK
         qP9EqQktkPfiZ7wLs03V6gWWfVajkaAYV34HZYfg=
Date:   Mon, 28 Sep 2020 14:14:35 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, lizefan@huawei.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch removed from
 -mm tree
Message-ID: <20200928211435.OT7vifDAj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix missing suffix of workingset_restore
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix missing suffix of workingset_restore

We forget to add the suffix to the workingset_restore string, so fix it. 
And also update the documentation of cgroup-v2.rst.

Link: https://lkml.kernel.org/r/20200916100030.71698-1-songmuchun@bytedance.com
Fixes: 170b04b7ae49 ("mm/workingset: prepare the workingset detection infrastructure for anon LRU")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   25 +++++++++++++++-------
 mm/memcontrol.c                         |    4 +--
 2 files changed, 20 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-fix-missing-suffix-of-workingset_restore
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1324,15 +1324,26 @@ PAGE_SIZE multiple when read back.
 	  pgmajfault
 		Number of major page faults incurred
 
-	  workingset_refault
-		Number of refaults of previously evicted pages
+	  workingset_refault_anon
+		Number of refaults of previously evicted anonymous pages.
 
-	  workingset_activate
-		Number of refaulted pages that were immediately activated
+	  workingset_refault_file
+		Number of refaults of previously evicted file pages.
 
-	  workingset_restore
-		Number of restored pages which have been detected as an active
-		workingset before they got reclaimed.
+	  workingset_activate_anon
+		Number of refaulted anonymous pages that were immediately
+		activated.
+
+	  workingset_activate_file
+		Number of refaulted file pages that were immediately activated.
+
+	  workingset_restore_anon
+		Number of restored anonymous pages which have been detected as
+		an active workingset before they got reclaimed.
+
+	  workingset_restore_file
+		Number of restored file pages which have been detected as an
+		active workingset before they got reclaimed.
 
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
--- a/mm/memcontrol.c~mm-memcontrol-fix-missing-suffix-of-workingset_restore
+++ a/mm/memcontrol.c
@@ -1538,9 +1538,9 @@ static char *memory_stat_format(struct m
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_ANON));
 	seq_buf_printf(&s, "workingset_activate_file %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_FILE));
-	seq_buf_printf(&s, "workingset_restore %lu\n",
+	seq_buf_printf(&s, "workingset_restore_anon %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_RESTORE_ANON));
-	seq_buf_printf(&s, "workingset_restore %lu\n",
+	seq_buf_printf(&s, "workingset_restore_file %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_RESTORE_FILE));
 	seq_buf_printf(&s, "workingset_nodereclaim %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_NODERECLAIM));
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

