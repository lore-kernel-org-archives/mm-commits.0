Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85602C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BFD6145A
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3FyV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhD3FyU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20322613F8;
        Fri, 30 Apr 2021 05:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762011;
        bh=4zKrcsSPYbuHXW9fRwOEUHGhnZBQG8ZkHakoMl7hvhE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qLQpQzgwoht1hCqHhPgBQwC/4DjAm4qV8y5GG0C7323y+pG0VNTvb3G0GhHcVtSTp
         m0hAyL7UPeBwLwgT4PvOBzo9sh4nbNIQLmzmn3T2KChJHJ8nUbUzzAwY6kPpqIX7NL
         zRfoeeiFFdc1JxBzVngOZWIdFQ/ttsVNYjkZqo2U=
Date:   Thu, 29 Apr 2021 22:53:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org
Subject:  [patch 005/178] ia64: drop unused IA64_FW_EMU ifdef
Message-ID: <20210430055330.I0vS1L-la%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
