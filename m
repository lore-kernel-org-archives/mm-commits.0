Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBE8C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbiDAAZc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243511AbiDAAZa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C041403F5
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB4FE6186B
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22955C340EE;
        Fri,  1 Apr 2022 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772613;
        bh=QbWeXZ/4h1rFzpZ48sx7Um31dLWg88Kx8i7JLLeWUGk=;
        h=Date:To:From:Subject:From;
        b=ohwvwGXXEik6Cedo/5fgmMNVRe/oTMDF7i4QnjpvBE4Xt4C84Ayrx+mz1JDqAkuUX
         JYxunHrHn+IUSdKlD/+J4es/+FbaIjzXeRUBgjZqMePngaMIEoxBD92AkIcRpU2VV5
         pB2Axocm9f8wm3zyWmtYnRNvO9kPZm2+yJw7AGeI=
Date:   Thu, 31 Mar 2022 17:23:32 -0700
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch removed from -mm tree
Message-Id: <20220401002333.22955C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "arm64, scs: save scs_sp values per-cpu when switching stacks"
has been removed from the -mm tree.  Its filename was
     arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks-fix.patch

This patch was dropped because it was folded into arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch

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

arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch

