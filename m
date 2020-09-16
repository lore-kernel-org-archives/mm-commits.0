Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4E7C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FE0A221EE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600297193;
	bh=GDtyJvrz0jJmWbFIsVQTxDzuqpTLQCwWe1J3Dza4Nws=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xzU9SIjgyJxaTVfNkg6RN8T+aAL9QqSDf37m84pPxGU5w9TfAZc5YhmEoX9R4zvl5
	 Z7sMDUdkBpYKXHhYD1wdPLYBZtwdM60TEVLxVTsIPFGcjO2ZziYVigZ8GhqLuZFtxT
	 1C/8CcYPaHBHtEb3i5hr+vlVs/ZBLon8KS+9Hfug=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIPW7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPW7v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:59:51 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021232083B;
        Wed, 16 Sep 2020 22:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600297191;
        bh=GDtyJvrz0jJmWbFIsVQTxDzuqpTLQCwWe1J3Dza4Nws=;
        h=Date:From:To:Subject:From;
        b=SDIEFv+6od31SxtZuL95bj6AZrkq+/wULLcpvzq6NBPmHl+lXKaQxNudrdCD4yjl5
         E8H1verx2IRh9SJQnFZI5lJKZpH0uAfXyifw32ad3Vxu5QUGOVrbxRdHFigwKXd+E7
         B0mvsD1k2n6uIBHjkiKYlLn9e3lpkeOthLis95kI=
Date:   Wed, 16 Sep 2020 15:59:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        songmuchun@bytedance.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memo?=
 =?us-ascii?Q?ry=5Fstat=5Fformat.patch?= removed from -mm tree
Message-ID: <20200916225950.mdOKd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix out-of-bounds on the buf returned by memory_stat_format
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix out-of-bounds on the buf returned by memory_stat_format

The memory_stat_format() returns a format string, but the return buf may
not including the trailing '\0', so the users may read the buf out of
bounds.

Link: https://lkml.kernel.org/r/20200912155100.25578-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format
+++ a/mm/memcontrol.c
@@ -1456,12 +1456,13 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
-static char *memory_stat_format(struct mem_cgroup *memcg)
+static const char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
 	int i;
 
-	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
+	/* Reserve a byte for the trailing null */
+	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE - 1);
 	if (!s.buffer)
 		return NULL;
 
@@ -1570,7 +1571,8 @@ static char *memory_stat_format(struct m
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	/* The above should easily fit into one page */
-	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
+	if (WARN_ON_ONCE(seq_buf_putc(&s, '\0')))
+		s.buffer[PAGE_SIZE - 1] = '\0';
 
 	return s.buffer;
 }
@@ -1608,7 +1610,7 @@ void mem_cgroup_print_oom_context(struct
  */
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 {
-	char *buf;
+	const char *buf;
 
 	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
 		K((u64)page_counter_read(&memcg->memory)),
@@ -6373,7 +6375,7 @@ static int memory_events_local_show(stru
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-	char *buf;
+	const char *buf;
 
 	buf = memory_stat_format(memcg);
 	if (!buf)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch
mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

