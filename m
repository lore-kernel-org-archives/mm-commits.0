Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B596C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 21:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiBNVgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:36:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiBNVgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 16:36:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628F55F66
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 13:36:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E2FB816AF
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 21:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4A6C340E9;
        Mon, 14 Feb 2022 21:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644874592;
        bh=p8pErjzIaaVqlNqTgz3tJK6IrvFCOw7kQ3QLqLUpLLQ=;
        h=Date:To:From:Subject:From;
        b=19zou8EJDcOcHg9alaETrIHTntRsr+KEVyUdiMkClzgEv9OssdxbNdcEiiqtMJ8WS
         lwRmcReGztRwQtbPDGGX3lwmFyZPFkhmJcw1+O+peivbVWp12Fqrq8cDF7jJmgFO8J
         OqQ0LbIge/fJxWrNgtId7PhY8ntLRTlmyJ2w7gBU=
Date:   Mon, 14 Feb 2022 13:36:32 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, sfr@canb.auug.org.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch added to -mm tree
Message-Id: <20220214213632.8F4A6C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "mm: don't include <linux/memremap.h> in <linux/mm.h>"
has been added to the -mm tree.  Its filename is
     mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch

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
Subject: fix for "mm: don't include <linux/memremap.h> in <linux/mm.h>"

fix arch/powerpc/kvm/book3s_hv_uvmem.c

Link: https://lkml.kernel.org/r/20220214180040.44f8316a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-dont-include-linux-memremaph-in-linux-mmh-fix-2
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -91,6 +91,7 @@
 #include <linux/kvm_host.h>
 #include <linux/ksm.h>
 #include <linux/of.h>
+#include <linux/memremap.h>
 #include <asm/ultravisor.h>
 #include <asm/mman.h>
 #include <asm/kvm_ppc.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kasan-improve-vmalloc-tests-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch

