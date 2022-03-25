Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93D0C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357130AbiCYBKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345473AbiCYBKo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A97B45ACA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C53B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69BDC340EE;
        Fri, 25 Mar 2022 01:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170548;
        bh=kClGRpQzIW+kEtb6ko5q3Tw/xoRFTPCFuWhBghh0l+I=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=AX1yc5Q58rEGRSlK8bZyZLs31VUFZxgHKPm5uhqbDo9lT3hJ+C1tvgeUYF98S0fMw
         bhRYlxgQh7C/Te+wKNG3YThmR2j77owhCmzjMeC+C3iPky9CGKemgnzWanFnbXUk+X
         RY9w8GY1ODkgsCWUcvcWEpgYcW4UsCFX87HjQOXQ=
Date:   Thu, 24 Mar 2022 18:09:08 -0700
To:     vdavydov.dev@gmail.com, senozhatsky@chromium.org,
        rppt@linux.ibm.com, rostedt@goodmis.org, roman.gushchin@linux.dev,
        rientjes@google.com, pmladek@suse.com, mhocko@kernel.org,
        linux@rasmusvillemoes.dk, ira.weiny@intel.com, hannes@cmpxchg.org,
        guro@fb.com, aquini@redhat.com, andriy.shevchenko@linux.intel.com,
        longman@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 011/114] mm/page_owner: print memcg information
Message-Id: <20220325010908.C69BDC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/page_owner: print memcg information

It was found that a number of offline memcgs were not freed because they
were pinned by some charged pages that were present.  Even "echo 1 >
/proc/sys/vm/drop_caches" wasn't able to free those pages.  These offline
but not freed memcgs tend to increase in number over time with the side
effect that percpu memory consumption as shown in /proc/meminfo also
increases over time.

In order to find out more information about those pages that pin offline
memcgs, the page_owner feature is extended to print memory cgroup
information especially whether the cgroup is offline or not.  RCU read
lock is taken when memcg is being accessed to make sure that it won't be
freed.

Link: https://lkml.kernel.org/r/20220202203036.744010-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/mm/page_owner.c~mm-page_owner-print-memcg-information
+++ a/mm/page_owner.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
 #include <linux/seq_file.h>
+#include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
 #include "internal.h"
@@ -325,6 +326,45 @@ void pagetypeinfo_showmixedcount_print(s
 	seq_putc(m, '\n');
 }
 
+/*
+ * Looking for memcg information and print it out
+ */
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+#ifdef CONFIG_MEMCG
+	unsigned long memcg_data;
+	struct mem_cgroup *memcg;
+	bool online;
+	char name[80];
+
+	rcu_read_lock();
+	memcg_data = READ_ONCE(page->memcg_data);
+	if (!memcg_data)
+		goto out_unlock;
+
+	if (memcg_data & MEMCG_DATA_OBJCGS)
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Slab cache page\n");
+
+	memcg = page_memcg_check(page);
+	if (!memcg)
+		goto out_unlock;
+
+	online = (memcg->css.flags & CSS_ONLINE);
+	cgroup_name(memcg->css.cgroup, name, sizeof(name));
+	ret += scnprintf(kbuf + ret, count - ret,
+			"Charged %sto %smemcg %s\n",
+			PageMemcgKmem(page) ? "(via objcg) " : "",
+			online ? "" : "offline ",
+			name);
+out_unlock:
+	rcu_read_unlock();
+#endif /* CONFIG_MEMCG */
+
+	return ret;
+}
+
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
@@ -365,6 +405,8 @@ print_page_owner(char __user *buf, size_
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
+	ret = print_page_owner_memcg(kbuf, count, ret, page);
+
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
 		goto err;
_
