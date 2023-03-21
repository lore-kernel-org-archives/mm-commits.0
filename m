Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E15C6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 20:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCUUFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 16:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCUUFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 16:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D727252BD
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 13:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02DFA61DEE
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 20:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CCBC433D2;
        Tue, 21 Mar 2023 20:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679429122;
        bh=pg+hC0MFHsQTDH3iH5BSHC+xxmvo0hTUlzw1OOMw+XQ=;
        h=Date:To:From:Subject:From;
        b=bBkGBkP6Z0aI9gluKg7x5Ou95KxeM/pJNhHtdDOIDeKa8G8wuUqLF/3JbEZ+V7Qns
         VxAWxSe/Dv0MWiLMgVIOc5uU1vqAvAKYThKPFrSW0qcJPeNp1cinpeJKCEHpj77PD6
         DGomgZV9V/7EFdPGq8ylFxMqK8BdXAP8Acr1SD4I=
Date:   Tue, 21 Mar 2023 13:05:21 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        dvyukov@google.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch added to mm-hotfixes-unstable branch
Message-Id: <20230321200522.56CCBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: correct help info of LOCKDEP_STACK_TRACE_HASH_BITS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib/Kconfig.debug: correct help info of LOCKDEP_STACK_TRACE_HASH_BITS
Date: Tue, 21 Mar 2023 14:35:08 +0800

We can see the following definition in kernel/locking/lockdep_internals.h:

  #define STACK_TRACE_HASH_SIZE	(1 << CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS)

CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS is related with STACK_TRACE_HASH_SIZE
instead of MAX_STACK_TRACE_ENTRIES, fix it.

Link: https://lkml.kernel.org/r/1679380508-20830-1-git-send-email-yangtiezhu@loongson.cn
Fixes: 5dc33592e955 ("lockdep: Allow tuning tracing capacity constants.")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits
+++ a/lib/Kconfig.debug
@@ -1392,7 +1392,7 @@ config LOCKDEP_STACK_TRACE_HASH_BITS
 	range 10 30
 	default 14
 	help
-	  Try increasing this value if you need large MAX_STACK_TRACE_ENTRIES.
+	  Try increasing this value if you need large STACK_TRACE_HASH_SIZE.
 
 config LOCKDEP_CIRCULAR_QUEUE_BITS
 	int "Bitsize for elements in circular_queue struct"
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch
lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch

