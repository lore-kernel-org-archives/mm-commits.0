Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA6DC433E9
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB04264F5E
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhCOWKl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 18:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhCOWKR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 18:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E0664F4D;
        Mon, 15 Mar 2021 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615846217;
        bh=gfDfUQwqxuvOtjHRxlgcwVQGqb8z53HQ5Lfg/yyghTw=;
        h=Date:From:To:Subject:From;
        b=sqQXrz/g6qwk8yp5g7gJiT5ZoxznmLfoOau+N+qr300rwNvyPO/xk2NPfn4nT1L8I
         YPOL9aPdU6q2xdrhH5pB36IA279P54/K/cz1Jk6PYVd2K0HrhXt6sRvRLdF8DD5tCl
         ogN4aDG/AFRB+Nwdz/rN3MLnvpN5JVajjO30FFhE=
Date:   Mon, 15 Mar 2021 15:10:16 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  + mm-remove-default-discontigmem_manual.patch added to
 -mm tree
Message-ID: <20210315221016.j3wZtl0k3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: remove default DISCONTIGMEM_MANUAL
has been added to the -mm tree.  Its filename is
     mm-remove-default-discontigmem_manual.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-default-discontigmem_manual.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-default-discontigmem_manual.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/Kconfig: remove default DISCONTIGMEM_MANUAL

Commit 214496cb18700fd7 ("ia64: make SPARSEMEM default and disable
DISCONTIGMEM") removed the last enabler of ARCH_DISCONTIGMEM_DEFAULT,
hence the memory model can no longer default to DISCONTIGMEM_MANUAL.

Link: https://lkml.kernel.org/r/20210312141208.3465520-1-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-remove-default-discontigmem_manual
+++ a/mm/Kconfig
@@ -9,7 +9,6 @@ config SELECT_MEMORY_MODEL
 choice
 	prompt "Memory model"
 	depends on SELECT_MEMORY_MODEL
-	default DISCONTIGMEM_MANUAL if ARCH_DISCONTIGMEM_DEFAULT
 	default SPARSEMEM_MANUAL if ARCH_SPARSEMEM_DEFAULT
 	default FLATMEM_MANUAL
 	help
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-remove-default-discontigmem_manual.patch

