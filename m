Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBA5C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9392065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027093;
	bh=l4JBD7G/xwYsqFYngRUWxg8/s8J0j24zeDckmYp0gbQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XmXMURjo13U1HKOaaAZ3+BjeIWdnJPzHo+jQ4nb7ga7pxu+Z3I14hzPypKlXPjRan
	 PXN1qUvw9dBOKC7+NtGRHnpIlqtL0BKrCe9kQbt6auKHjjb/y/9uLMo+6ON5zCv2wN
	 Mql7ZYOTVDbC5bjeGmY2mSc4fYp5OmbJ6gTvfr7c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHJCiN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCiN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B18FE206C3;
        Mon, 10 Aug 2020 02:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027092;
        bh=l4JBD7G/xwYsqFYngRUWxg8/s8J0j24zeDckmYp0gbQ=;
        h=Date:From:To:Subject:From;
        b=tpNuEf+QCNtq1xlYGmGovPCrFHZN1VVjA1ipzWjC1L7gvLJemMub/oPUgiMKi62+A
         ME51wDQRhpWKXYpZ+Sx0aWJIKsEgh2OHVo/u7+rdO2g0EsMk5nmL3/oBhBPRHyB0PW
         MC/GzPbDXKzMlGk6pdVMnUXJZI4nURDJJ0nVPdw4=
Date:   Sun, 09 Aug 2020 19:38:11 -0700
From:   akpm@linux-foundation.org
To:     andi.kleen@intel.com, cai@lca.pw, cl@linux.com,
        dave.hansen@intel.com, dennis@kernel.org, feng.tang@intel.com,
        haiyangz@microsoft.com, hannes@cmpxchg.org, keescook@chromium.org,
        kys@microsoft.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        tim.c.chen@intel.com, tj@kernel.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged] percpu_counter-add-percpu_counter_sync.patch
 removed from -mm tree
Message-ID: <20200810023811.8aTYS6zUl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_counter: add percpu_counter_sync()
has been removed from the -mm tree.  Its filename was
     percpu_counter-add-percpu_counter_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: percpu_counter: add percpu_counter_sync()

percpu_counter's accuracy is related to its batch size.  For a
percpu_counter with a big batch, its deviation could be big, so when the
counter's batch is runtime changed to a smaller value for better accuracy,
there could also be requirment to reduce the big deviation.

So add a percpu-counter sync function to be run on each CPU.

Link: http://lkml.kernel.org/r/1594389708-60781-4-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    4 ++++
 lib/percpu_counter.c           |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/percpu_counter.h~percpu_counter-add-percpu_counter_sync
+++ a/include/linux/percpu_counter.h
@@ -44,6 +44,7 @@ void percpu_counter_add_batch(struct per
 			      s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
+void percpu_counter_sync(struct percpu_counter *fbc);
 
 static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 {
@@ -172,6 +173,9 @@ static inline bool percpu_counter_initia
 	return true;
 }
 
+static inline void percpu_counter_sync(struct percpu_counter *fbc)
+{
+}
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
--- a/lib/percpu_counter.c~percpu_counter-add-percpu_counter_sync
+++ a/lib/percpu_counter.c
@@ -99,6 +99,25 @@ void percpu_counter_add_batch(struct per
 EXPORT_SYMBOL(percpu_counter_add_batch);
 
 /*
+ * For percpu_counter with a big batch, the devication of its count could
+ * be big, and there is requirement to reduce the deviation, like when the
+ * counter's batch could be runtime decreased to get a better accuracy,
+ * which can be achieved by running this sync function on each CPU.
+ */
+void percpu_counter_sync(struct percpu_counter *fbc)
+{
+	unsigned long flags;
+	s64 count;
+
+	raw_spin_lock_irqsave(&fbc->lock, flags);
+	count = __this_cpu_read(*fbc->counters);
+	fbc->count += count;
+	__this_cpu_sub(*fbc->counters, count);
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+}
+EXPORT_SYMBOL(percpu_counter_sync);
+
+/*
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
_

Patches currently in -mm which might be from feng.tang@intel.com are

makefile-add-debug-option-to-enable-function-aligned-on-32-bytes.patch

