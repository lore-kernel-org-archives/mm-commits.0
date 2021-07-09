Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711A4C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 589D3613C8
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhGIVfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhGIVfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92586613BD;
        Fri,  9 Jul 2021 21:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866342;
        bh=kziAxpPAKBNOIUiKsm2rH6QdDiuIoGzKzPVXQp032Qk=;
        h=Date:From:To:Subject:From;
        b=StsowDFgh9qKHxupC5TLvN1RxYA4bXE+eRkEhccE0JvbAcb6vedsTMIzGlL02CMch
         OFVp5lLN/5wfyT0FfYRHnJAGjvcYtTziYrYDxuKG60WXsxjBEu0DPY8rUGpZYqT/w0
         cCQQG/GirgC+clAMQJPadA9owFYD/UgVMAXvORVc=
Date:   Fri, 09 Jul 2021 14:32:22 -0700
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, glittao@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rientjes@google.com, vbabka@suse.cz
Subject:  [merged] hexagon-select-arch_want_ld_orphan_warn.patch
 removed from -mm tree
Message-ID: <20210709213222.XmQfrZB6O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: select ARCH_WANT_LD_ORPHAN_WARN
has been removed from the -mm tree.  Its filename was
     hexagon-select-arch_want_ld_orphan_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: select ARCH_WANT_LD_ORPHAN_WARN

Now that we handle all of the sections in a Hexagon defconfig, select
ARCH_WANT_LD_ORPHAN_WARN so that unhandled sections are warned about by
default.

Link: https://lkml.kernel.org/r/20210521011239.1332345-4-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/Kconfig~hexagon-select-arch_want_ld_orphan_warn
+++ a/arch/hexagon/Kconfig
@@ -30,6 +30,7 @@ config HEXAGON
 	select MODULES_USE_ELF_RELA
 	select GENERIC_CPU_DEVICES
 	select SET_FS
+	select ARCH_WANT_LD_ORPHAN_WARN
 	help
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
_

Patches currently in -mm which might be from nathan@kernel.org are


