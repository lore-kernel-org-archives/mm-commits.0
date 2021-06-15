Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4644C48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D4CB6128C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFOXID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhFOXIC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9926C61055;
        Tue, 15 Jun 2021 23:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623798357;
        bh=qSfdDDv/2NKhwbFqxhpQeDRPHh+sl+dsmdCLs7a4VUA=;
        h=Date:From:To:Subject:From;
        b=rO35xUJmjn6Ll9j6akG0lFzihWKh+9zu1AhEQ0AeZ59BdWF7CkaYdVNmJAuYTtE6J
         NtBaem3gI2SVgUfcyvjx0Z76uGUmOwh0iQPhcPE5DPL+NRq1g9aATCYhIOisdssjfz
         XECIVwRDwbsZjEBOtX6rklWjBs2rqy1iWr7sVBvg=
Date:   Tue, 15 Jun 2021 16:05:57 -0700
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, glittao@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rientjes@google.com, vbabka@suse.cz
Subject:  + hexagon-select-arch_want_ld_orphan_warn.patch added to
 -mm tree
Message-ID: <20210615230557.PcKDHcAkH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: select ARCH_WANT_LD_ORPHAN_WARN
has been added to the -mm tree.  Its filename is
     hexagon-select-arch_want_ld_orphan_warn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hexagon-select-arch_want_ld_orphan_warn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hexagon-select-arch_want_ld_orphan_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hexagon-handle-softirqentry_text-in-linker-script.patch
hexagon-use-common-discards-macro.patch
hexagon-select-arch_want_ld_orphan_warn.patch

