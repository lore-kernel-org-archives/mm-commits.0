Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE99C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722B363422
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbhKOS0V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241341AbhKOSTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD8A963405;
        Mon, 15 Nov 2021 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998703;
        bh=kFLAq1aLOSoCTw0D65EXNkbLctaCpJUMiUwE3i/3Cc4=;
        h=Date:From:To:Subject:From;
        b=KDBoi3TvYsn4Yck4orPnD92H2QwF8iY0JpHaFiAFwAY6N8tQ4PBW8abgwg+2G0AHD
         5iCkdFWrernxGhtH/lJYFLdiCMoqnFO/xBMf2AsT6MkvmnpDaDOBJiXW9bIAikp6h2
         HiwgWAHMhZulKwJ3+mrKADmTh/AgisBeeFtpFXqc=
Date:   Mon, 15 Nov 2021 09:51:43 -0800
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com
Subject:  + hexagon-ignore-vmlinuxlds.patch added to -mm tree
Message-ID: <20211115175143.jtJE6y66o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: ignore vmlinux.lds
has been added to the -mm tree.  Its filename is
     hexagon-ignore-vmlinuxlds.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hexagon-ignore-vmlinuxlds.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hexagon-ignore-vmlinuxlds.patch

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

Patches currently in -mm which might be from nathan@kernel.org are

hexagon-export-raw-i-o-routines-for-modules.patch
hexagon-clean-up-timer-regsh.patch
hexagon-ignore-vmlinuxlds.patch

