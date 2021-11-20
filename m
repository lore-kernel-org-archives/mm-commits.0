Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD53C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 20 Nov 2021 00:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhKTAqh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 19:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234793AbhKTAqh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A424A61AF0;
        Sat, 20 Nov 2021 00:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369014;
        bh=tMNLFfV/KMZC4YmuPsP3uEz2qUZXkYL23K7bwo/3G0Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WNwyDBwJd58E50Q4APb63ez/U1aVAoOtY7luPrMOTcrUxyAD4FTdg9BGNEDmvCg9D
         7/oFX/TVs1fsh+mLpGq4aG4R3pTKaIXpK3KipPoWJf77fQuin/tfkz+0PeRM81vSGN
         1bCZBx+MQywc+qF4MNij4qQDdRAmzmiQ2obGb6IU=
Date:   Fri, 19 Nov 2021 16:43:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bcain@codeaurora.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 07/15] hexagon: ignore vmlinux.lds
Message-ID: <20211120004334.-vNbCj_MF%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: ignore vmlinux.lds

After building allmodconfig, there is an untracked vmlinux.lds file in
arch/hexagon/kernel:

$ git ls-files . --exclude-standard --others
arch/hexagon/kernel/vmlinux.lds

Ignore it as all other architectures have.

Link: https://lkml.kernel.org/r/20211115174250.1994179-4-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- /dev/null
+++ a/arch/hexagon/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
_
