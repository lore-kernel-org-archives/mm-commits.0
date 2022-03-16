Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D328FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 00:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbiCPAHg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Mar 2022 20:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244582AbiCPAHf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2022 20:07:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E635DE4B
        for <mm-commits@vger.kernel.org>; Tue, 15 Mar 2022 17:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 883A9B819AA
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 00:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B89C340E8;
        Wed, 16 Mar 2022 00:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647389180;
        bh=gxEAcH2MJzUl/TFSpbMbDg0fY2m+wETaLCFRUioH5SE=;
        h=Date:To:From:Subject:From;
        b=HyrdpoGFH7T6UFBADPFOanGPUe6VPo9Nzkkb+h+yKtRfEpyH7Yok8v2AuNrDEk2wr
         YGfmg2+Ck1PA2FpJulJLTj40UzDnesA9dhsZGmh0K/IZD0Wik/DgEim0IZhZs3+I3F
         /rA1lAKNZekOBHQaFAUteQGmuiHk+yuQqqhrP0Po=
Date:   Tue, 15 Mar 2022 17:06:19 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix.patch added to -mm tree
Message-Id: <20220316000620.21B89C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix
has been added to the -mm tree.  Its filename is
     mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix

remove CPUHP_MM_DEMOTION_DEAD and CPUHP_AP_MM_DEMOTION_ONLINE definitions, per Huang Ying

Link: https://lkml.kernel.org/r/YjBPKmIpPNoJU/67@localhost.localdomain
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuhotplug.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/cpuhotplug.h~mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix
+++ a/include/linux/cpuhotplug.h
@@ -72,8 +72,6 @@ enum cpuhp_state {
 	CPUHP_SLUB_DEAD,
 	CPUHP_DEBUG_OBJ_DEAD,
 	CPUHP_MM_WRITEBACK_DEAD,
-	/* Must be after CPUHP_MM_VMSTAT_DEAD */
-	CPUHP_MM_DEMOTION_DEAD,
 	CPUHP_MM_VMSTAT_DEAD,
 	CPUHP_SOFTIRQ_DEAD,
 	CPUHP_NET_MVNETA_DEAD,
@@ -244,8 +242,6 @@ enum cpuhp_state {
 	CPUHP_AP_BASE_CACHEINFO_ONLINE,
 	CPUHP_AP_ONLINE_DYN,
 	CPUHP_AP_ONLINE_DYN_END		= CPUHP_AP_ONLINE_DYN + 30,
-	/* Must be after CPUHP_AP_ONLINE_DYN for node_states[N_CPU] update */
-	CPUHP_AP_MM_DEMOTION_ONLINE,
 	CPUHP_AP_X86_HPET_ONLINE,
 	CPUHP_AP_X86_KVM_CLK_ONLINE,
 	CPUHP_AP_ACTIVE,
_

Patches currently in -mm which might be from osalvador@suse.de are

arch-x86-mm-numa-do-not-initialize-nodes-twice.patch
arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-fix.patch

