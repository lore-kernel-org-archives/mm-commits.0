Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6B7C87FDD
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjFIX2I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjFIX1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAB83AAB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11CCA63E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6762FC433D2;
        Fri,  9 Jun 2023 23:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353246;
        bh=i7WWF+ggOMgbuBIiOdL/+06yUq+VgJy+ZyUhaD6clHg=;
        h=Date:To:From:Subject:From;
        b=PVFME+q5/3jP3CXhDIM8PTzmya0854QBdCsRe0dWnebKlNUSNY8avCpt5pJ5DpzcL
         hbAb/rGS2DjavgmAuyhyWv/HsEYLuVsdXJkc2SAzdkeh6xme9l2P+yumU2pzdJGEQ7
         atxCvP55bLEvlUPRn2pjKqQ2diH9Y0W4WESdTE64=
Date:   Fri, 09 Jun 2023 16:27:24 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom-do-not-check-0-mask-in-out_of_memory.patch removed from -mm tree
Message-Id: <20230609232726.6762FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, oom: do not check 0 mask in out_of_memory()
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-check-0-mask-in-out_of_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm, oom: do not check 0 mask in out_of_memory()
Date: Mon, 8 May 2023 07:35:38 +0000

Since commit 60e2793d440a ("mm, oom: do not trigger out_of_memory from the
#PF"), no user sets gfp_mask to 0.  Remove the 0 mask check and update the
comments.

Link: https://lkml.kernel.org/r/20230508073538.1168-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/oom_kill.c~mm-oom-do-not-check-0-mask-in-out_of_memory
+++ a/mm/oom_kill.c
@@ -1130,12 +1130,10 @@ bool out_of_memory(struct oom_control *o
 
 	/*
 	 * The OOM killer does not compensate for IO-less reclaim.
-	 * pagefault_out_of_memory lost its gfp context so we have to
-	 * make sure exclude 0 mask - all other users should have at least
-	 * ___GFP_DIRECT_RECLAIM to get here. But mem_cgroup_oom() has to
-	 * invoke the OOM killer even if it is a GFP_NOFS allocation.
+	 * But mem_cgroup_oom() has to invoke the OOM killer even
+	 * if it is a GFP_NOFS allocation.
 	 */
-	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
+	if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
 		return true;
 
 	/*
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

