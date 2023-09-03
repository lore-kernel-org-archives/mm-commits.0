Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985B9C71153
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 02:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjICCY3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 22:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjICCY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 22:24:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C4A1A7
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 19:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FE6B80A7C
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 02:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A84DC433C7;
        Sun,  3 Sep 2023 02:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693707863;
        bh=jCJfEavFlUi2jwoW2zws815lsdiaufPRVk0gW9tGL1k=;
        h=Date:To:From:Subject:From;
        b=VykbJvd8WcbewpRtOCB5CLMvxGdNUcGXAX1D4XbIRzO8eW3t7MoBPyHUdgBzSFd9I
         MJt/I+PEPYuzA5sp3GyZeI95qFrOjtDp/mJn4QbdlmVWLc/4dpRR6LkMLNlp5rJxQK
         Xu/6g4cMsA7DfsPtpwjKNCL/6ir3C+0s/4kXWuaI=
Date:   Sat, 02 Sep 2023 19:24:22 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        mgorman@techsingularity.net, cl@linux.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-draining-remote-pageset.patch added to mm-unstable branch
Message-Id: <20230903022423.3A84DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix draining remote pageset
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-draining-remote-pageset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-draining-remote-pageset.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: mm: fix draining remote pageset
Date: Fri, 11 Aug 2023 17:08:19 +0800

If there is no memory allocation/freeing in the remote pageset after
some time (3 seconds for now), the remote pageset will be drained to
avoid memory wastage.

But in the current implementation, vmstat updater worker may not be
re-queued when we are waiting for the timeout (pcp->expire != 0) if
there are no vmstat changes, for example, when CPU goes idle.

This is fixed via guaranteeing that the vmstat updater worker will
always be re-queued when we are waiting for the timeout.

We can reproduce the bug via allocating/freeing pages from remote
node, then go idle.  And the patch can fix it.

- Run some workloads, use `numactl` to bind CPU to node 0 and memory to
  node 1.  So the PCP of the CPU on node 0 for zone on node 1 will be
  filled.

- After workloads finish, idle for 60s

- Check /proc/zoneinfo

With the original kernel, the number of pages in the PCP of the CPU on
node 0 for zone on node 1 is non-zero after idle.  With the patched
kernel, that becomes 0 after idle.  We avoid to keep pages in the remote
PCP during idle.

Christoph added:

: Having some pages from a remote NUMA node stuck in a pcp somewhere is 
: making that memory unusable. It is usually rate that these remote pages 
: are needed again and so they may remain there for a long time if the 
: situation is right.

Link: https://lkml.kernel.org/r/20230811090819.60845-1-ying.huang@intel.com
Fixes: 7cc36bbddde5 ("vmstat: on-demand vmstat workers V8")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-fix-draining-remote-pageset
+++ a/mm/vmstat.c
@@ -855,8 +855,10 @@ static int refresh_cpu_vm_stats(bool do_
 				continue;
 			}
 
-			if (__this_cpu_dec_return(pcp->expire))
+			if (__this_cpu_dec_return(pcp->expire)) {
+				changes++;
 				continue;
+			}
 
 			if (__this_cpu_read(pcp->count)) {
 				drain_zone_pages(zone, this_cpu_ptr(pcp));
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch
mm-fix-draining-remote-pageset.patch

