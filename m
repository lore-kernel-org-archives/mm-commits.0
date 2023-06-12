Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B259C7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbjFLVdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbjFLVdu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4535B3
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE2362D5F
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B030C4339B;
        Mon, 12 Jun 2023 21:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605627;
        bh=7MR9vxvl6xrRbSoRIQzobEzg2aEIlxRNQgDeW9embfs=;
        h=Date:To:From:Subject:From;
        b=Q2Cnnuj6+c7XBpqAEfaQJoRZgcyF3JG6cEMzordGKjxVCc3IdpSt4v3bGseInkfPm
         9gad2vuU0Erc4EY8xYPPEvp5JKsuuoeEynExqi+q9kz6G9aKocxg+hptMASyL95iB1
         huexZiNUzexXkvSu1+dgTTOWjBtIu1iGSg257mMo=
Date:   Mon, 12 Jun 2023 14:33:47 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch added to mm-unstable branch
Message-Id: <20230612213347.8B030C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tier: remove unneeded !IS_ENABLED(CONFIG_MIGRATION) check
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: remove unneeded !IS_ENABLED(CONFIG_MIGRATION) check
Date: Sat, 10 Jun 2023 11:41:14 +0800

establish_demotion_targets() is defined while CONFIG_MIGRATION is
enabled. There's no need to check it again.

Link: https://lkml.kernel.org/r/20230610034114.981861-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~memory-tier-remove-unneeded-is_enabledconfig_migration-check
+++ a/mm/memory-tiers.c
@@ -366,7 +366,7 @@ static void establish_demotion_targets(v
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	if (!node_demotion || !IS_ENABLED(CONFIG_MIGRATION))
+	if (!node_demotion)
 		return;
 
 	disable_all_demotion_targets();
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch
memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch
mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch
memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch

