Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C20C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbjFGCST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbjFGCSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B03E1712
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBEE363971
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4933FC433D2;
        Wed,  7 Jun 2023 02:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686104296;
        bh=XXkUmgSVI1SQP4w/AYKwWxEVeUZbcLDyN6OhIJUAUCw=;
        h=Date:To:From:Subject:From;
        b=zuQYZnuKVHgrfkN8SIrsvJBGc2u5BnT88mfTKK0qaBgM0PtIQBAp/r+ttFe5S0QyU
         lJBEqqPYe+70up1iNjZ84c07ynIvReXe584EKWSzorqM8nZppdxSvgLu2XWHUMq+ZX
         pZCN7GugulKzvOWRwyTbIAtupwYdH4QnZUZmuRG4=
Date:   Tue, 06 Jun 2023 19:18:15 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch added to mm-unstable branch
Message-Id: <20230607021816.4933FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tier: remove unneeded disable_all_demotion_targets() when !CONFIG_MIGRATION
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch

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

mm-remove-obsolete-alloc_migrate_target.patch
mm-page_alloc-remove-unneeded-header-files.patch
memcg-use-helper-macro-flush_time.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch
memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch

