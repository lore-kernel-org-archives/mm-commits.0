Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04679C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3CE061381
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhKICh7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKICh7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DCC61360;
        Tue,  9 Nov 2021 02:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425313;
        bh=40OcirszzTw6jhM0UPdOCCH6X1dh6Qf0iJ/avfnlAZI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DmDxe4xKt4totDIFNocNdpi5zCmK9wGnmcbpx83pWA2M4NQ1y/Wu89CHvsk9d/+Vh
         5+aDgGbn+6c3BzdFlFXfXFhfpioDH66wywQxLFBQMyF/mlwW46g4swaiCHUy2Pmm7j
         1Oi1UP5N1pNrU32pd0LrMEmVwTvGuX5cQepoOg5w=
Date:   Mon, 08 Nov 2021 18:35:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  [patch 71/87] signal: remove duplicate include in
 signal.h
Message-ID: <20211109023513.ZxJRTTvR_%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>
Subject: signal: remove duplicate include in signal.h

'linux/string.h' included in 'signal.h' is duplicated.
it's also included at line 7.

Link: https://lkml.kernel.org/r/20211019024934.973008-1-ye.guojin@zte.com.cn
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/signal.h~signal-remove-duplicate-include-in-signalh
+++ a/include/linux/signal.h
@@ -126,7 +126,6 @@ static inline int sigequalsets(const sig
 #define sigmask(sig)	(1UL << ((sig) - 1))
 
 #ifndef __HAVE_ARCH_SIG_SETOPS
-#include <linux/string.h>
 
 #define _SIG_SET_BINOP(name, op)					\
 static inline void name(sigset_t *r, const sigset_t *a, const sigset_t *b) \
_
