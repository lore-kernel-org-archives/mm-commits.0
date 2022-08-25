Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2A6C04AA5
	for <mm-commits@archiver.kernel.org>; Thu, 25 Aug 2022 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiHYAeG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 20:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiHYAeE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 20:34:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4BF8E457
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E12CBB826CA
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 00:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7A4C433C1;
        Thu, 25 Aug 2022 00:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661387640;
        bh=rYKC64D1usEYMqZm0/3yzVerbZnKEEw7gIfndcpfC/8=;
        h=Date:To:From:Subject:From;
        b=WBr/8J96FYfubyHgr4O0mFtOuWotpseb6O+9c/g+GFT3SuqVW6SmUfhtcQMD2Fl8Z
         sCn57ETgC2hTvxPqZLr+7etcRNKNv/6SUdcjE896avhKz4q2TVLfr0tHZabf5Afc7H
         X3cX9NmzoFAMtE6Ffa204lGpN5NYhmmlFVChAhP4=
Date:   Wed, 24 Aug 2022 17:33:59 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        soheil@google.com, roman.gushchin@linux.dev, oliver.sang@intel.com,
        mkoutny@suse.com, mhocko@kernel.org, hannes@cmpxchg.org,
        feng.tang@intel.com, edumazet@google.com, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-rearrange-struct-page_counter-fields.patch added to mm-unstable branch
Message-Id: <20220825003400.7F7A4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: rearrange struct page_counter fields
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counter-rearrange-struct-page_counter-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counter-rearrange-struct-page_counter-fields.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: page_counter: rearrange struct page_counter fields
Date: Thu, 25 Aug 2022 00:05:05 +0000

With memcg v2 enabled, memcg->memory.usage is a very hot member for the
workloads doing memcg charging on multiple CPUs concurrently. 
Particularly the network intensive workloads.  In addition, there is a
false cache sharing between memory.usage and memory.high on the charge
path.  This patch moves the usage into a separate cacheline and move all
the read most fields into separate cacheline.

To evaluate the impact of this optimization, on a 72 CPUs machine, we ran
the following workload in a three level of cgroup hierarchy.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)	10482.7 Mbps
With patch		12413.7 Mbps (18.4% improvement)

With the patch, the throughput improved by 18.4%.

One side-effect of this patch is the increase in the size of struct
mem_cgroup.  For example with this patch on 64 bit build, the size of
struct mem_cgroup increased from 4032 bytes to 4416 bytes.  However for
the performance improvement, this additional size is worth it.  In
addition there are opportunities to reduce the size of struct mem_cgroup
like deprecation of kmem and tcpmem page counters and better packing.

Link: https://lkml.kernel.org/r/20220825000506.239406-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |   35 +++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/include/linux/page_counter.h~mm-page_counter-rearrange-struct-page_counter-fields
+++ a/include/linux/page_counter.h
@@ -3,15 +3,26 @@
 #define _LINUX_PAGE_COUNTER_H
 
 #include <linux/atomic.h>
+#include <linux/cache.h>
 #include <linux/kernel.h>
 #include <asm/page.h>
 
+#if defined(CONFIG_SMP)
+struct pc_padding {
+	char x[0];
+} ____cacheline_internodealigned_in_smp;
+#define PC_PADDING(name)	struct pc_padding name
+#else
+#define PC_PADDING(name)
+#endif
+
 struct page_counter {
+	/*
+	 * Make sure 'usage' does not share cacheline with any other field. The
+	 * memcg->memory.usage is a hot member of struct mem_cgroup.
+	 */
 	atomic_long_t usage;
-	unsigned long min;
-	unsigned long low;
-	unsigned long high;
-	unsigned long max;
+	PC_PADDING(_pad1_);
 
 	/* effective memory.min and memory.min usage tracking */
 	unsigned long emin;
@@ -23,18 +34,18 @@ struct page_counter {
 	atomic_long_t low_usage;
 	atomic_long_t children_low_usage;
 
-	/* legacy */
 	unsigned long watermark;
 	unsigned long failcnt;
 
-	/*
-	 * 'parent' is placed here to be far from 'usage' to reduce
-	 * cache false sharing, as 'usage' is written mostly while
-	 * parent is frequently read for cgroup's hierarchical
-	 * counting nature.
-	 */
+	/* Keep all the read most fields in a separete cacheline. */
+	PC_PADDING(_pad2_);
+
+	unsigned long min;
+	unsigned long low;
+	unsigned long high;
+	unsigned long max;
 	struct page_counter *parent;
-};
+} ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
 #define PAGE_COUNTER_MAX LONG_MAX
_

Patches currently in -mm which might be from shakeelb@google.com are

revert-memcg-cleanup-racy-sum-avoidance-code.patch
mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch

