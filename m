Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1610EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0212761108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhKKC4h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234599AbhKKC4g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ABF960F46;
        Thu, 11 Nov 2021 02:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599228;
        bh=q+M7wgqpd5OrhRLFaFLH3enbYp/pvOTukRaWUNTlTAA=;
        h=Date:From:To:Subject:From;
        b=DbH9cZoxLaKNIBw4ZSXx91xV6nscR3aS603ltOm0pDU6A3fxNfxDbIWqm6uf4l6el
         2j6HutmdQfzcCMG8sBgHpiWT5IT4XP515zIqu0TshTq+25UcqD/ISVzhfcJL4GRbfn
         s4UqelAab0I/9FoFQ0+JzGWbAhS4T8gToIFhkm1M=
Date:   Wed, 10 Nov 2021 18:53:48 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  [merged] signal-remove-duplicate-include-in-signalh.patch
 removed from -mm tree
Message-ID: <20211111025348.Lp3qjHA-c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal: remove duplicate include in signal.h
has been removed from the -mm tree.  Its filename was
     signal-remove-duplicate-include-in-signalh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ye.guojin@zte.com.cn are


