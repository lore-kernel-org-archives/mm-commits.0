Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFD2C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F6121531
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599958010;
	bh=4NZQB87Q81MMcF5bSs29Q+5Zj20wqhP1AlyvEX61g/Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1sbaT8aaEvpT1YDEkgnvHxM4zj+d8LLtl1T/BGk4+33f23Yc16pA8m3O8OcBB0jEm
	 XZ7jN5QORN5M750CBWUJfvvBeRcTVsQMxOnZEGWAexkzrgSS/Yn2zn6aMwYUSVCY5b
	 d0n8mgLf3ynvD9Anq6VDJlSAfElS2DuhITPj9kfw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgIMAqt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgIMAqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:46:46 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D609121531;
        Sun, 13 Sep 2020 00:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599958006;
        bh=4NZQB87Q81MMcF5bSs29Q+5Zj20wqhP1AlyvEX61g/Q=;
        h=Date:From:To:Subject:From;
        b=CfYZo58dWvoY62CB8Ab2q/akJNkS+6XVDABJiYDh319a1Lb+4I8WFZmcclnAa6RJ3
         i4ClVTCxYTq6Jn9PZbjnl/Vy/cX/caf+uYtxxcpeg+/ZyjebSgUfwMFgolt2EjmqiW
         aeJBqRw9RNTxIDrEeNDzFsOdfhJV3dDUS11hzz24=
Date:   Sat, 12 Sep 2020 17:46:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        songmuchun@bytedance.com
Subject:  +
 =?us-ascii?Q?mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memo?=
 =?us-ascii?Q?ry=5Fstat=5Fformat.patch?= added to -mm tree
Message-ID: <20200913004645.a63iH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix out-of-bounds on the buf returned by memory_stat_format
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix out-of-bounds on the buf returned by memory_stat_format

The memory_stat_format() returns a format string, but the return buf may
not including the trailing '\0', so the users may read the buf out of
bounds.

Link: https://lkml.kernel.org/r/20200912155100.25578-1-songmuchun@bytedance.com
Fixes: c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup OOM")
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
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch
mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

