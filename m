Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BD9EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjFSXU1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjFSXUY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6498CE55
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFFCB60F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231BC433C0;
        Mon, 19 Jun 2023 23:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216822;
        bh=0NB/gCbkZDg5AZ5aF3gO2+OgwGnzw2982g3PVr/aQi0=;
        h=Date:To:From:Subject:From;
        b=kOD0Cs3GfHJX9Ng12SoMxNvpN4mbMPUOOzyFdXY+aSOXRZS5xZNOhnQcTjb3tw8nm
         SW4r56iP6ssBocDyNIUTZwuCwVl9PucY51xkGMpMJxXOPHBQXmS2GYoIsNPu+mDgyi
         j3QVzww34IBO9EqVcnrNxY1zsFg4JqWziT6AZ2AA=
Date:   Mon, 19 Jun 2023 16:20:21 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch removed from -mm tree
Message-Id: <20230619232022.5231BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory tier: remove unneeded disable_all_demotion_targets() when !CONFIG_MIGRATION
has been removed from the -mm tree.  Its filename was
     memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: remove unneeded disable_all_demotion_targets() when !CONFIG_MIGRATION
Date: Tue, 6 Jun 2023 20:07:24 +0800

There's no caller of disable_all_demotion_targets() when CONFIG_MIGRATION
is disabled.  Remove it.

Link: https://lkml.kernel.org/r/20230606120724.208552-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory-tiers.c~memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration
+++ a/mm/memory-tiers.c
@@ -451,7 +451,6 @@ static void establish_demotion_targets(v
 }
 
 #else
-static inline void disable_all_demotion_targets(void) {}
 static inline void establish_demotion_targets(void) {}
 #endif /* CONFIG_MIGRATION */
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


