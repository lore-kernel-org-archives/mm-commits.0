Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBCAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2829E20829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193767;
	bh=7D69G1QZToBLkVNWjwDwa0DeNRud46knnJWJLMEBgzM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gK7yNhsgFQ5nfmweMtStJEpVK5xCbwZHmzDXz+fVZjgpEra38Oa9j/i+AyM8PMupr
	 Jkma6rr3LHkU3BkvsBzIC+cqpzcQOaRuInFeMZ68Z4PYgJFTuxAby/PH/rpf2Wbxfv
	 Gz4RoXQrwIwL78isQJW0ynbeo+231J9JaiE3VO+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLA4G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLA4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:56:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5407E207DA;
        Wed, 12 Aug 2020 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193766;
        bh=7D69G1QZToBLkVNWjwDwa0DeNRud46knnJWJLMEBgzM=;
        h=Date:From:To:Subject:From;
        b=cckatEsBnNpr4/d1/sGoNtxVxyCrCFQcyvKBf4ze9nyHGMZGc1O1uLQCAbYh4bU0L
         IAVYEjVbZJ3f5h/nt5t+nuBGMzrqoxD4GFJoUCAhhfuckogzgVqdMURPtO1ZWZelOl
         4OEFkLKpVojAU8+U5IumSLB8BE0BgLMEUeRyB+58=
Date:   Tue, 11 Aug 2020 17:56:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cl@linux.com, cuibixuan@huawei.com,
        dennis@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
 removed from -mm tree
Message-ID: <20200812005604.ftnK7ssdb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch

This patch was dropped because it was folded into mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix

move unreachable code, per Roman

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix
+++ a/mm/percpu.c
@@ -1440,8 +1440,8 @@ static struct pcpu_chunk *pcpu_alloc_chu
 
 #ifdef CONFIG_MEMCG_KMEM
 objcg_fail:
-#endif
 	pcpu_mem_free(chunk->md_blocks);
+#endif
 md_blocks_fail:
 	pcpu_mem_free(chunk->bound_map);
 bound_map_fail:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

