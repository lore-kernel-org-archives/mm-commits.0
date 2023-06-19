Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86A0EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjFSX2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjFSX2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315361BEE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D5D61141
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69532C433C8;
        Mon, 19 Jun 2023 23:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217172;
        bh=2q5WI41vyQHYacghjQlDoq7BnGVJv87HPyRFXOIOGuo=;
        h=Date:To:From:Subject:From;
        b=aQFH6R3Y39Wv8taWTeWJKX5kYAsxi07/qSmSwDUhlHRzT5IXN6w293AiITxoyqTv8
         2jD6PZNETBKA24Sc+yw6TMz6rbNSPS6Ec9VWWkPnIBnplLfgZDcSTKg9cOKhmfK9Nd
         p1U89mevX3FVYrgis6sAU1eZ3m7YzSoDokRJew70=
Date:   Mon, 19 Jun 2023 16:26:11 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-remove-softlockup-comment-in-touch_nmi_watchdog.patch removed from -mm tree
Message-Id: <20230619232612.69532C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: remove softlockup comment in touch_nmi_watchdog()
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-remove-softlockup-comment-in-touch_nmi_watchdog.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: remove softlockup comment in touch_nmi_watchdog()
Date: Fri, 26 May 2023 18:41:35 -0700

In the patch ("watchdog/hardlockup: add comments to touch_nmi_watchdog()")
we adjusted some comments for touch_nmi_watchdog().  The comment about the
softlockup had a typo and were also felt to be too obvious.  Remove it.

Link: https://lkml.kernel.org/r/20230526184139.5.Ia593afc9eb12082d55ea6681dc2c5a89677f20a8@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-remove-softlockup-comment-in-touch_nmi_watchdog
+++ a/include/linux/nmi.h
@@ -140,10 +140,6 @@ static inline void touch_nmi_watchdog(vo
 	 */
 	arch_touch_nmi_watchdog();
 
-	/*
-	 * Touching the hardlock detector implicitly resets the
-	 * softlockup detector too
-	 */
 	touch_softlockup_watchdog();
 }
 
_

Patches currently in -mm which might be from dianders@chromium.org are


