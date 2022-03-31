Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D247C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiCaEVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiCaEV3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30D519A54A
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:09:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2354DB81ECA
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9100C340ED;
        Thu, 31 Mar 2022 04:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648699768;
        bh=+DoGzMNLraSpkJr+3ayYj0GJ0PVeb5A1uWbTJCEHq9c=;
        h=Date:To:From:Subject:From;
        b=sMw5gIgTBYu+MESBmeXyP9a4W7PzaKnJI+bQJE+xqdqUqXKosX1EpMSB0ROYo3VyW
         vDj39okMPWZzRkjXf3cZqGtmMUIoqokrf/N6ODa0Rf2f3axV1rQ5KTaUdsPQfv0iGn
         tVIVUMFR9eCf/GPd8gzg8mJiszqrYcpoGUBbb7QI=
Date:   Wed, 30 Mar 2022 21:09:27 -0700
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch added to -mm tree
Message-Id: <20220331040928.A9100C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "arm64, scs: save scs_sp values per-cpu when switching stacks"
has been added to the -mm tree.  Its filename is
     arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "arm64, scs: save scs_sp values per-cpu when switching stacks"

arch/arm64/kernel/irq.c needs asm/scs.h

Link: https://lkml.kernel.org/r/20220331141858.46b4df12@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/irq.c~arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix
+++ a/arch/arm64/kernel/irq.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <asm/daifflags.h>
 #include <asm/vmap_stack.h>
+#include <asm/scs.h>
 
 /* Only access this in an NMI enter/exit */
 DEFINE_PER_CPU(struct nmi_ctx, nmi_contexts);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch

