Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3649C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 22:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01FD61156
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 22:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhJSW6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 18:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhJSW6A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 18:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7B9610E5;
        Tue, 19 Oct 2021 22:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634684146;
        bh=ii5VgynkLCID5Rr39AYLE20Z6jHbAUZONwz6xISgS80=;
        h=Date:From:To:Subject:From;
        b=pSom0wBpuqNjQPCjHvoo6wv9uUt1hnRm0WVXqaTHPVdAOjnCKNVnjTOjhxztx6gss
         GkWSuQbNGpGxKVx+gfmGkjWd1rHnm4XoY/lFQyxVzK0wKBkf7veIOoHjWkBRJNb7Lz
         8OdvfDLkARkuAxexiE5nqdBkpFMQ5O6f2GYitJQ8=
Date:   Tue, 19 Oct 2021 15:55:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  + signal-remove-duplicate-include-in-signalh.patch added
 to -mm tree
Message-ID: <20211019225546.ITVoiOVaV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal: remove duplicate include in signal.h
has been added to the -mm tree.  Its filename is
     signal-remove-duplicate-include-in-signalh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/signal-remove-duplicate-include-in-signalh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/signal-remove-duplicate-include-in-signalh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

signal-remove-duplicate-include-in-signalh.patch

