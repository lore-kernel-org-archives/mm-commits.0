Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CCAC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FA161A18
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhCXWLw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238740AbhCXWLg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A88A61A18;
        Wed, 24 Mar 2021 22:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616623896;
        bh=9HetomUfjN4C0VRfB7Q3HykcrZo6Duf/9BlmAPRQo2s=;
        h=Date:From:To:Subject:From;
        b=PwH6g5A0/7IPMGpnFKY2VQEFGaIggtDcBEWk/rcfY3zT2k0zfs+8oicTkLdSrRBLq
         1nn6wn4Z/vRYwNJq2cjQ/txRjeMZgupKRuLEU1buOtLaLN6uUiL1JWlvWSsfNTe88I
         a8iG1RITTO7MSrRBazIFKLks5FUG9uakqu/hcevg=
Date:   Wed, 24 Mar 2021 15:11:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org
Subject:  + ia64-drop-unused-ia64_fw_emu-ifdef.patch added to -mm
 tree
Message-ID: <20210324221136.l-ORT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: drop unused IA64_FW_EMU ifdef
has been added to the -mm tree.  Its filename is
     ia64-drop-unused-ia64_fw_emu-ifdef.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-drop-unused-ia64_fw_emu-ifdef.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-drop-unused-ia64_fw_emu-ifdef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: drop unused IA64_FW_EMU ifdef

It's a remnant of deleted hpsim emulation target removed in fc5bad037
("ia64: remove the hpsim platform").

Link: https://lkml.kernel.org/r/20210323224009.240625-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/head.S |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/ia64/kernel/head.S~ia64-drop-unused-ia64_fw_emu-ifdef
+++ a/arch/ia64/kernel/head.S
@@ -404,11 +404,6 @@ start_ap:
 
 	// This is executed by the bootstrap processor (bsp) only:
 
-#ifdef CONFIG_IA64_FW_EMU
-	// initialize PAL & SAL emulator:
-	br.call.sptk.many rp=sys_fw_init
-.ret1:
-#endif
 	br.call.sptk.many rp=start_kernel
 .ret2:	addl r3=@ltoff(halt_msg),gp
 	;;
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-mca-allocate-early-mca-with-gfp_atomic.patch
ia64-fix-format-strings-for-err_inject.patch
ia64-drop-unused-ia64_fw_emu-ifdef.patch

