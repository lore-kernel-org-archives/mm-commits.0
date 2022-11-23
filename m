Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A115C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiKWCxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKWCxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D99CF4D
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61CB6B81E55
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC01C433C1;
        Wed, 23 Nov 2022 02:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172004;
        bh=VVNJzbC1tS94NHIp4k/xcpBplhwUHw72AvTfjjwMiQM=;
        h=Date:To:From:Subject:From;
        b=v/7BgLnhL/q2BGsVT9ucwnGRYy5GC2mcHcAhkZiedPN9aqVv1QIopGAKZk1fuOF3K
         bG4m0eUPxyQGvHoel9yPwB2Hqo35T1AanbE59f8XMzEmd2bPrETbpUYwscq89Fw/IM
         5gmZOe5mqYc9C4MjdFJbSaGm8FCvlRMuSLTcDx4c=
Date:   Tue, 22 Nov 2022 18:53:23 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com, seanjc@google.com,
        maz@kernel.org, hannes@cmpxchg.org, david@redhat.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-meminfo-fix-spacing-in-secpagetables.patch removed from -mm tree
Message-Id: <20221123025324.1EC01C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/meminfo: fix spacing in SecPageTables
has been removed from the -mm tree.  Its filename was
     proc-meminfo-fix-spacing-in-secpagetables.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: proc/meminfo: fix spacing in SecPageTables
Date: Thu, 17 Nov 2022 04:32:47 +0000

SecPageTables has a tab after it instead of a space, this can break
fragile parsers that depend on spaces after the stat names.

Link: https://lkml.kernel.org/r/20221117043247.133294-1-yosryahmed@google.com
Fixes: ebc97a52b5d6cd5f ("mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/meminfo.c~proc-meminfo-fix-spacing-in-secpagetables
+++ a/fs/proc/meminfo.c
@@ -115,7 +115,7 @@ static int meminfo_proc_show(struct seq_
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_node_page_state(NR_PAGETABLE));
-	show_val_kb(m, "SecPageTables:	",
+	show_val_kb(m, "SecPageTables:  ",
 		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
_

Patches currently in -mm which might be from yosryahmed@google.com are


