Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B282C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiG3BJe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiG3BI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1DB86C16
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB779B82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7AAC433D7;
        Sat, 30 Jul 2022 01:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143320;
        bh=EbhuxDiQ8WgYa4LE5OEDflurMBo+XCM6V3vaUTDhxpY=;
        h=Date:To:From:Subject:From;
        b=vgdP5Lzi7QZ2ODC3lbn3ha7T0OSpEeXfzaKHOi1Hv0VTXjtmGG4JQqqqgGV0+hYgK
         kfaoQtippApKMSNMqSdaRx7ibpWM4WHYBJxcr9VHNBXD1Lk40BUDC1PZyle9y5xzkY
         swLjHq9a39a2mldRqoF2Wz+dMsLLNCjgSYYIPBFA=
Date:   Fri, 29 Jul 2022 18:08:40 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+2d2aeadc6ce1e1f11d45@syzkaller.appspotmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-fix-potential-oom_lock-recursion-deadlock.patch removed from -mm tree
Message-Id: <20220730010840.8A7AAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: fix potential oom_lock recursion deadlock
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-potential-oom_lock-recursion-deadlock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: memcontrol: fix potential oom_lock recursion deadlock
Date: Fri, 22 Jul 2022 19:45:39 +0900

syzbot is reporting GFP_KERNEL allocation with oom_lock held when
reporting memcg OOM [1].  If this allocation triggers the global OOM
situation then the system can livelock because the GFP_KERNEL
allocation with oom_lock held cannot trigger the global OOM killer
because __alloc_pages_may_oom() fails to hold oom_lock.

Fix this problem by removing the allocation from memory_stat_format()
completely, and pass static buffer when calling from memcg OOM path.

Note that the caller holding filesystem lock was the trigger for syzbot
to report this locking dependency.  Doing GFP_KERNEL allocation with
filesystem lock held can deadlock the system even without involving OOM
situation.

Link: https://syzkaller.appspot.com/bug?extid=2d2aeadc6ce1e1f11d45 [1]
Link: https://lkml.kernel.org/r/86afb39f-8c65-bec2-6cfc-c5e3cd600c0b@I-love.SAKURA.ne.jp
Fixes: c8713d0b23123759 ("mm: memcontrol: dump memory.stat during cgroup OOM")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+2d2aeadc6ce1e1f11d45@syzkaller.appspotmail.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-potential-oom_lock-recursion-deadlock
+++ a/mm/memcontrol.c
@@ -1490,14 +1490,12 @@ static const unsigned int memcg_vm_event
 #endif
 };
 
-static char *memory_stat_format(struct mem_cgroup *memcg)
+static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 {
 	struct seq_buf s;
 	int i;
 
-	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
-	if (!s.buffer)
-		return NULL;
+	seq_buf_init(&s, buf, bufsize);
 
 	/*
 	 * Provide statistics on the state of the memory subsystem as
@@ -1539,8 +1537,6 @@ static char *memory_stat_format(struct m
 
 	/* The above should easily fit into one page */
 	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
-
-	return s.buffer;
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -1576,7 +1572,10 @@ void mem_cgroup_print_oom_context(struct
  */
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 {
-	char *buf;
+	/* Use static buffer, for the caller is holding oom_lock. */
+	static char buf[PAGE_SIZE];
+
+	lockdep_assert_held(&oom_lock);
 
 	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
 		K((u64)page_counter_read(&memcg->memory)),
@@ -1597,11 +1596,8 @@ void mem_cgroup_print_oom_meminfo(struct
 	pr_info("Memory cgroup stats for ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
 	pr_cont(":");
-	buf = memory_stat_format(memcg);
-	if (!buf)
-		return;
+	memory_stat_format(memcg, buf, sizeof(buf));
 	pr_info("%s", buf);
-	kfree(buf);
 }
 
 /*
@@ -6405,11 +6401,11 @@ static int memory_events_local_show(stru
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-	char *buf;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
-	buf = memory_stat_format(memcg);
 	if (!buf)
 		return -ENOMEM;
+	memory_stat_format(memcg, buf, PAGE_SIZE);
 	seq_puts(m, buf);
 	kfree(buf);
 	return 0;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


