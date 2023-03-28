Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A7BC77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 22:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjC1WZN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 18:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjC1WZM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 18:25:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03EEE6
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 15:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB1161994
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 22:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FBAC433EF;
        Tue, 28 Mar 2023 22:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042310;
        bh=jKShqJ4pEQUB4/imkQUQcS/YG5Qz6k6cgSqfneLGJWQ=;
        h=Date:To:From:Subject:From;
        b=olVNcA5epou/akCWoTm26VvMU3ypagzaWL6omaRVbCKCGazuvdFbgZlF0QmnzSrgh
         CbUH8N1wuLzRrdQe1dm0KGOVrt9H1TE6NMdrp4pOj2K+8ikhn1E1C11IT1dk4r2k4N
         lw4qLV2dAlBht1X29qc6ZaFWg446ipC1aVHGdOrg=
Date:   Tue, 28 Mar 2023 15:25:10 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        dvyukov@google.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch removed from -mm tree
Message-Id: <20230328222510.A3FBAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/Kconfig.debug: correct help info of LOCKDEP_STACK_TRACE_HASH_BITS
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


