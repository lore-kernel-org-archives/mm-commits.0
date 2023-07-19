Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06245C001B0
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjGSTgg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjGSTgX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:36:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2E030D7
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 002A9617F4
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52510C433BA;
        Wed, 19 Jul 2023 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689795315;
        bh=q7Cuo6i02+6yA4+v1Uac/XGqkiVEGdKJzvSm6p3oUZE=;
        h=Date:To:From:Subject:From;
        b=MkTRgdkh/GBXG6EI9kRHrOfKj3r1E7JwWvLzjc3LbaQO1auOB1ueqsTOdnEfslMzp
         xx0syVafRlTG21l2tjMktGvyKlZQhPP9QKc/R25wzCVyBY2k3nJe6H6mj4TLJln3xc
         4HR5toP5ru9VuX1mErKO6aGiEoRG1ZiiTj6efFm4=
Date:   Wed, 19 Jul 2023 12:35:12 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kill-frontswap-fix.patch added to mm-unstable branch
Message-Id: <20230719193515.52510C433BA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Wed, 19 Jul 2023 10:21:49 -0400
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kill-frontswap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kill-frontswap-fix.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 19 Jul 2023 10:21:49 -0400
Subject: mm: kill frontswap fix

remove obsolete comment, per Yosry

Link: https://lkml.kernel.org/r/20230719142832.GA932528@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-kill-frontswap-fix
+++ a/mm/zswap.c
@@ -1425,7 +1425,6 @@ bool zswap_load(struct page *page)
 	spin_lock(&tree->lock);
 	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
-		/* entry was written back */
 		spin_unlock(&tree->lock);
 		return false;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch

