Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95706C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C71A613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWkF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A8DA61402;
        Sat,  8 May 2021 22:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513543;
        bh=glwATauRkDowMkeQNgygI+owgK0AXAkff/ONhVRL2sQ=;
        h=Date:From:To:Subject:From;
        b=txssyu0rKMb5NyoRSaAKYNcNxMBY9YmKRyYcdbNwlOasvWMiuXmNhGvJjrrARSJ9e
         53LxpMoziB9HWyAgbQwm+Rsh114qtsqpcvWCUgVoNqQ5Y2zq0lDz4e/kOCA6CpO7BW
         IdWdau9wQHsTrjRft7WiOjmvylrH/aJ2YaCSDZAc=
Date:   Sat, 08 May 2021 15:39:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org
Subject:  [merged] ia64-drop-unused-ia64_fw_emu-ifdef.patch removed
 from -mm tree
Message-ID: <20210508223903.B4hpd46j9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: drop unused IA64_FW_EMU ifdef
has been removed from the -mm tree.  Its filename was
     ia64-drop-unused-ia64_fw_emu-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


