Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DB7C6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 18:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCMSH2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjCMSH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 14:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270C94C6EF
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 11:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B64BE61454
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 18:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BCFC433D2;
        Mon, 13 Mar 2023 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678730845;
        bh=TLLpJFa4SmJPwcoPlRkksxhxMmYcaJoD83veLXk+j74=;
        h=Date:To:From:Subject:From;
        b=A44NHSTJo62Mx6EH9+JEm15ScQLnyfpLtEJVYYPEBhmrlpH0afQoMVKx56nv2yBJq
         rHHrZYk/CdM+gi//l/09pSz4BVKn6BUphBK+G8+BmXDS7FLeRzKdFfs6AGs8k9M0aC
         3mMlDWDW+h56IJfoKJmoHxjWaz7HUoR6b+uXJ+Ao=
Date:   Mon, 13 Mar 2023 11:07:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mhocko@suse.com, lstoakes@gmail.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, hca@linux.ibm.com,
        frederic@kernel.org, dan.j.williams@intel.com, cl@linux.com,
        christian.koenig@amd.com, chenhuacai@kernel.org,
        atomlin@atomlin.com, mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch added to mm-unstable branch
Message-Id: <20230313180725.10BCFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: this_cpu_cmpxchg: ARM64: switch this_cpu_cmpxchg to locked, add _local function
has been added to the -mm mm-unstable branch.  Its filename is
     this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: this_cpu_cmpxchg: ARM64: switch this_cpu_cmpxchg to locked, add _local function
Date: Mon, 13 Mar 2023 13:25:08 -0300

Patch series "fold per-CPU vmstats remotely", v5.

This patch series addresses the following two problems:

    1. A customer provided some evidence which indicates that
       the idle tick was stopped; albeit, CPU-specific vmstat
       counters still remained populated.

       Thus one can only assume quiet_vmstat() was not
       invoked on return to the idle loop. If I understand
       correctly, I suspect this divergence might erroneously
       prevent a reclaim attempt by kswapd. If the number of
       zone specific free pages are below their per-cpu drift
       value then zone_page_state_snapshot() is used to
       compute a more accurate view of the aforementioned
       statistic.  Thus any task blocked on the NUMA node
       specific pfmemalloc_wait queue will be unable to make
       significant progress via direct reclaim unless it is
       killed after being woken up by kswapd
       (see throttle_direct_reclaim())

    2. With a SCHED_FIFO task that busy loops on a given CPU,
       and kworker for that CPU at SCHED_OTHER priority,
       queuing work to sync per-vmstats will either cause that
       work to never execute, or stalld (i.e. stall daemon)
       boosts kworker priority which causes a latency
       violation

By having vmstat_shepherd flush the per-CPU counters to the global
counters from remote CPUs.

This is done using cmpxchg to manipulate the counters, both CPU locally
(via the account functions), and remotely (via cpu_vm_stats_fold).

Thanks to Aaron Tomlin for diagnosing issue 1 and writing the initial
patch series.


This patch (of 5):

Goal is to have vmstat_shepherd to transfer from per-CPU counters to
global counters remotely.  For this, an atomic this_cpu_cmpxchg is
necessary.

Following the kernel convention for cmpxchg/cmpxchg_local, change ARM's
this_cpu_cmpxchg_ helpers to be atomic, and add this_cpu_cmpxchg_local_
helpers which are not atomic.

Link: https://lkml.kernel.org/r/20230313162507.032200398@redhat.com
Link: https://lkml.kernel.org/r/20230313162634.283504192@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm64/include/asm/percpu.h~this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function
+++ a/arch/arm64/include/asm/percpu.h
@@ -232,13 +232,23 @@ PERCPU_RET_OP(add, add, ldadd)
 	_pcp_protect_return(xchg_relaxed, pcp, val)
 
 #define this_cpu_cmpxchg_1(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+	_pcp_protect_return(cmpxchg, pcp, o, n)
 #define this_cpu_cmpxchg_2(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+	_pcp_protect_return(cmpxchg, pcp, o, n)
 #define this_cpu_cmpxchg_4(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+	_pcp_protect_return(cmpxchg, pcp, o, n)
 #define this_cpu_cmpxchg_8(pcp, o, n)	\
+	_pcp_protect_return(cmpxchg, pcp, o, n)
+
+#define this_cpu_cmpxchg_local_1(pcp, o, n)	\
 	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_local_2(pcp, o, n)	\
+	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_local_4(pcp, o, n)	\
+	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_local_8(pcp, o, n)	\
+	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
_

Patches currently in -mm which might be from mtosatti@redhat.com are

this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch

