Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1595FEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjFSX0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjFSXYY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3303219B2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1053E60FC1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6906AC433C0;
        Mon, 19 Jun 2023 23:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216979;
        bh=HdzntTU2bn2eDZwXFHK+vrJRgeLl7I2KqGCdr8WmJ04=;
        h=Date:To:From:Subject:From;
        b=xiVHfKioY/2/IZHfZBB+TDCIrrOY7DSLH8D4BXJEaCv1DOVEbyDUFounSuq8l4Oqh
         YvrrBkeRLG3qnu7WU9vtw6K10x/GP09rxH+X9EbKreMirqZmh0zJijUaKbZ+UiTN1z
         9/+CicT44bBaQjdeD1JCcM9yhR/Ed7z58GAahxng=
Date:   Mon, 19 Jun 2023 16:22:58 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch removed from -mm tree
Message-Id: <20230619232259.6906AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory tier: remove unneeded !IS_ENABLED(CONFIG_MIGRATION) check
has been removed from the -mm tree.  Its filename was
     memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: remove unneeded !IS_ENABLED(CONFIG_MIGRATION) check
Date: Sat, 10 Jun 2023 11:41:14 +0800

establish_demotion_targets() is defined while CONFIG_MIGRATION is
enabled. There's no need to check it again.

Link: https://lkml.kernel.org/r/20230610034114.981861-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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


