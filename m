Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D291FC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95492177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781390;
	bh=3kwIVbG0Je9mRVpk/AEhSvKQxgMLHoOizB7KRNYvYc8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rMZ8muCTbYzOJQ+OqcT1zC6mk+ggq05xlIkYZK8/NboCo71zK399qecIBz5zCm5ZI
	 6XmPdwC0Hnp5H1rBWd36KnIjN2eYpcL1w9/4s20eLqaPB867g3K/jMd84AAssfuKXo
	 +DZ+22cquZBJ/PUVF1xAoBdpWh+Cjye4PBGgMiAI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:23:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0835E22D3E;
        Fri,  7 Aug 2020 06:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781389;
        bh=3kwIVbG0Je9mRVpk/AEhSvKQxgMLHoOizB7KRNYvYc8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EBkUrnH0xaDhmBrYTv427ZCXqFuwvCRw7allzjt9rlkaHUlI3IdcorLEWYrib5egy
         SmlIeTXF7n4CY88RlCr3EzkW9etnnxnhTlb5VaytdvBD612OM5JazEE2NHEs2cbQA4
         QyalS5NKKWhjPrSTeQfM6utAOVSgf6UhjH7Lk28A=
Date:   Thu, 06 Aug 2020 23:23:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andi.kleen@intel.com, cai@lca.pw,
        cl@linux.com, dave.hansen@intel.com, dennis@kernel.org,
        feng.tang@intel.com, haiyangz@microsoft.com, hannes@cmpxchg.org,
        keescook@chromium.org, kys@microsoft.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com, tim.c.chen@intel.com, tj@kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 106/163] mm/util.c: make vm_memory_committed()
 more accurate
Message-ID: <20200807062307.YSHh3UQuU%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>
Subject: mm/util.c: make vm_memory_committed() more accurate

percpu_counter_sum_positive() will provide more accurate info.

As with percpu_counter_read_positive(), in worst case the deviation could
be 'batch * nr_cpus', which is totalram_pages/256 for now, and will be
more when the batch gets enlarged.

Its time cost is about 800 nanoseconds on a 2C/4T platform and 2~3
microseconds on a 2S/36C/72T Skylake server in normal case, and in worst
case where vm_committed_as's spinlock is under severe contention, it costs
30~40 microseconds for the 2S/36C/72T Skylake sever, which should be fine
for its only two users: /proc/meminfo and HyperV balloon driver's status
trace per second.

Link: http://lkml.kernel.org/r/1592725000-73486-3-git-send-email-feng.tang@intel.com
Link: http://lkml.kernel.org/r/1594389708-60781-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com> # for /proc/meminfo
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel test robot <rong.a.chen@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-utilc-make-vm_memory_committed-more-accurate
+++ a/mm/util.c
@@ -787,10 +787,15 @@ struct percpu_counter vm_committed_as __
  * balancing memory across competing virtual machines that are hosted.
  * Several metrics drive this policy engine including the guest reported
  * memory commitment.
+ *
+ * The time cost of this is very low for small platforms, and for big
+ * platform like a 2S/36C/72T Skylake server, in worst case where
+ * vm_committed_as's spinlock is under severe contention, the time cost
+ * could be about 30~40 microseconds.
  */
 unsigned long vm_memory_committed(void)
 {
-	return percpu_counter_read_positive(&vm_committed_as);
+	return percpu_counter_sum_positive(&vm_committed_as);
 }
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
_
