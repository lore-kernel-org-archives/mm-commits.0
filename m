Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5518FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC6E2075D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417344;
	bh=6l1qGJ3556rzy0I9196ZjYS4yxG1q1o7/99Ndut+k+0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KiDcKdh138t+vNCQ7dP3TRKnzjv+paJstw1YGgllx6OKh0wx8kNZx7jpk7KP8n7O0
	 aNLPLGUeRsZTvTpmTUYwhD/SKxTYc6IkoxT6dfzKg9/1uzD4p+swAdHlOW97NdESd4
	 D0OsWxxBz1EJ6LPHOfQnLMyTL6ZdRQ7Ccv+9jHAI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgGJVmY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgGJVmX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:42:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A08206E2;
        Fri, 10 Jul 2020 21:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417342;
        bh=6l1qGJ3556rzy0I9196ZjYS4yxG1q1o7/99Ndut+k+0=;
        h=Date:From:To:Subject:From;
        b=dyST1AwtL1mS86BSCPtf9SqGtCQ62R8ltcdJJE6Ge9hRs0vpb7UnpP3x6A+SDrErK
         rKf4yw+nNPb/xMJ7xDlnHO4v+ZUbTL0LilioYwn5XVP2BrkS1qQAvI3LwxSrigAhVy
         XATY8Og3fo69idRGbUG41C35mMDfibeCWGSL1naY=
Date:   Fri, 10 Jul 2020 14:42:21 -0700
From:   akpm@linux-foundation.org
To:     andi.kleen@intel.com, cai@lca.pw, cl@linux.com,
        dave.hansen@intel.com, dennis@kernel.org, feng.tang@intel.com,
        haiyangz@microsoft.com, hannes@cmpxchg.org, keescook@chromium.org,
        kys@microsoft.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        tim.c.chen@intel.com, tj@kernel.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  +
 proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch added to -mm
 tree
Message-ID: <20200710214221.I-c_DsSa2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/meminfo: avoid open coded reading of vm_committed_as
has been added to the -mm tree.  Its filename is
     proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: proc/meminfo: avoid open coded reading of vm_committed_as

Patch series "make vm_committed_as_batch aware of vm overcommit policy", v6.

When checking a performance change for will-it-scale scalability mmap test
[1], we found very high lock contention for spinlock of percpu counter
'vm_committed_as':

    94.14%     0.35%  [kernel.kallsyms]         [k] _raw_spin_lock_irqsave
    48.21% _raw_spin_lock_irqsave;percpu_counter_add_batch;__vm_enough_memory;mmap_region;do_mmap;
    45.91% _raw_spin_lock_irqsave;percpu_counter_add_batch;__do_munmap;

Actually this heavy lock contention is not always necessary.  The
'vm_committed_as' needs to be very precise when the strict
OVERCOMMIT_NEVER policy is set, which requires a rather small batch number
for the percpu counter.

So keep 'batch' number unchanged for strict OVERCOMMIT_NEVER policy, and
enlarge it for not-so-strict OVERCOMMIT_ALWAYS and OVERCOMMIT_GUESS
policies.

Benchmark with the same testcase in [1] shows 53% improvement on a 8C/16T
desktop, and 2097%(20X) on a 4S/72C/144T server.  And for that case,
whether it shows improvements depends on if the test mmap size is bigger
than the batch number computed.

We tested 10+ platforms in 0day (server, desktop and laptop).  If we lift
it to 64X, 80%+ platforms show improvements, and for 16X lift, 1/3 of the
platforms will show improvements.

And generally it should help the mmap/unmap usage,as Michal Hocko
mentioned:

: I believe that there are non-synthetic worklaods which would benefit
: from a larger batch. E.g. large in memory databases which do large
: mmaps during startups from multiple threads.

Note: There are some style complain from checkpatch for patch 4, as sysctl
handler declaration follows the similar format of sibling functions

[1] https://lore.kernel.org/lkml/20200305062138.GI5972@shao2-debian/


This patch (of 4):

Use the existing vm_memory_committed() instead, which is also convenient
for future change.

Link: http://lkml.kernel.org/r/1594389708-60781-1-git-send-email-feng.tang@intel.com
Link: http://lkml.kernel.org/r/1594389708-60781-2-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: kernel test robot <rong.a.chen@intel.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/meminfo.c~proc-meminfo-avoid-open-coded-reading-of-vm_committed_as
+++ a/fs/proc/meminfo.c
@@ -41,7 +41,7 @@ static int meminfo_proc_show(struct seq_
 
 	si_meminfo(&i);
 	si_swapinfo(&i);
-	committed = percpu_counter_read_positive(&vm_committed_as);
+	committed = vm_memory_committed();
 
 	cached = global_node_page_state(NR_FILE_PAGES) -
 			total_swapcache_pages() - i.bufferram;
_

Patches currently in -mm which might be from feng.tang@intel.com are

proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch
mm-utilc-make-vm_memory_committed-more-accurate.patch
percpu_counter-add-percpu_counter_sync.patch
mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch

