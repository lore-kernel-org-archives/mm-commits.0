Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6D4C77B73
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 20:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjEBUPd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 16:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjEBUPc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 16:15:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E2F2D5E
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 13:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891936288D
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 20:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8711C433D2;
        Tue,  2 May 2023 20:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683058509;
        bh=e7TIGmpzjP2fekhsuoYZimJOeBXeCQRscKrFVHczCmA=;
        h=Date:To:From:Subject:From;
        b=d4EtvogfRpI2AhP2wnTqFhVzIqtuJaUAnSBzPGPyzvkfSLCKKpe3vdl4Y8z6gpZr6
         vIpwzmAqCDAynpdi1a6fXRRmNLnKzfszHxvF/sbzRnZeNMAgE2Wvp1nlYGbh18j5iR
         wTpZxzMGlk7yId2y69hZ6x3D4H1siDtWsgSTvk98=
Date:   Tue, 02 May 2023 13:15:09 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        senozhatsky@chromium.org, rostedt@goodmis.org,
        roman.gushchin@linux.dev, pmladek@suse.com, muchun.song@linux.dev,
        mhocko@suse.com, mhocko@kernel.org, hannes@cmpxchg.org,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch added to mm-unstable branch
Message-Id: <20230502201509.B8711C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: use seq_buf_do_printk() with mem_cgroup_print_oom_meminfo()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: use seq_buf_do_printk() with mem_cgroup_print_oom_meminfo()
Date: Fri, 28 Apr 2023 13:24:05 +0000

Currently, we format all the memcg stats into a buffer in
mem_cgroup_print_oom_meminfo() and use pr_info() to dump it to the logs. 
However, this buffer is large in size.  Although it is currently working
as intended, ther is a dependency between the memcg stats buffer and the
printk record size limit.

If we add more stats in the future and the buffer becomes larger than the
printk record size limit, or if the prink record size limit is reduced,
the logs may be truncated.

It is safer to use seq_buf_do_printk(), which will automatically break up
the buffer at line breaks and issue small printk() calls.

Refactor the code to move the seq_buf from memory_stat_format() to its
callers, and use seq_buf_do_printk() to print the seq_buf in
mem_cgroup_print_oom_meminfo().

Link: https://lkml.kernel.org/r/20230428132406.2540811-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c~memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo
+++ a/mm/memcontrol.c
@@ -1580,13 +1580,10 @@ static inline unsigned long memcg_page_s
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
-static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
+static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
-	struct seq_buf s;
 	int i;
 
-	seq_buf_init(&s, buf, bufsize);
-
 	/*
 	 * Provide statistics on the state of the memory subsystem as
 	 * well as cumulative event counters that show past behavior.
@@ -1603,21 +1600,21 @@ static void memory_stat_format(struct me
 		u64 size;
 
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
-		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
+		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
 			size += memcg_page_state_output(memcg,
 							NR_SLAB_RECLAIMABLE_B);
-			seq_buf_printf(&s, "slab %llu\n", size);
+			seq_buf_printf(s, "slab %llu\n", size);
 		}
 	}
 
 	/* Accumulated memory events */
-	seq_buf_printf(&s, "pgscan %lu\n",
+	seq_buf_printf(s, "pgscan %lu\n",
 		       memcg_events(memcg, PGSCAN_KSWAPD) +
 		       memcg_events(memcg, PGSCAN_DIRECT) +
 		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
-	seq_buf_printf(&s, "pgsteal %lu\n",
+	seq_buf_printf(s, "pgsteal %lu\n",
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
 		       memcg_events(memcg, PGSTEAL_DIRECT) +
 		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
@@ -1627,13 +1624,13 @@ static void memory_stat_format(struct me
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
 
-		seq_buf_printf(&s, "%s %lu\n",
+		seq_buf_printf(s, "%s %lu\n",
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
 
 	/* The above should easily fit into one page */
-	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
+	WARN_ON_ONCE(seq_buf_has_overflowed(s));
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -1671,6 +1668,7 @@ void mem_cgroup_print_oom_meminfo(struct
 {
 	/* Use static buffer, for the caller is holding oom_lock. */
 	static char buf[PAGE_SIZE];
+	struct seq_buf s;
 
 	lockdep_assert_held(&oom_lock);
 
@@ -1693,8 +1691,9 @@ void mem_cgroup_print_oom_meminfo(struct
 	pr_info("Memory cgroup stats for ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
 	pr_cont(":");
-	memory_stat_format(memcg, buf, sizeof(buf));
-	pr_info("%s", buf);
+	seq_buf_init(&s, buf, sizeof(buf));
+	memory_stat_format(memcg, &s);
+	seq_buf_do_printk(&s, KERN_INFO);
 }
 
 /*
@@ -6635,10 +6634,12 @@ static int memory_stat_show(struct seq_f
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct seq_buf s;
 
 	if (!buf)
 		return -ENOMEM;
-	memory_stat_format(memcg, buf, PAGE_SIZE);
+	seq_buf_init(&s, buf, PAGE_SIZE);
+	memory_stat_format(memcg, &s);
 	seq_puts(m, buf);
 	kfree(buf);
 	return 0;
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch
memcg-dump-memorystat-during-cgroup-oom-for-v1.patch

