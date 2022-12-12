Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1704C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiLLCOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiLLCOI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE74C65C5
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCDB60EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2455C433F0;
        Mon, 12 Dec 2022 02:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811240;
        bh=eZquPp2NletpmOWUzmNDWidFZ8xxRz+7WeV1TtdIY2g=;
        h=Date:To:From:Subject:From;
        b=gDMP5XnaibhOSyAmABWEbHYPqH/UgZYFdnYClxWeJpIDqab63KGq8VJo6/FQ80SDC
         NdSczBIrTs0IXZmuV9r57scecPl5oKuZ1Ryjmk/IUgHHWTqTwz+PztCUX9SyOL+lxB
         ODO5Dk8MuG+AqJaWAUqij1z6ZBRfClLclJvaKv0A=
Date:   Sun, 11 Dec 2022 18:14:00 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        mingo@redhat.com, elver@google.com, ebiggers@kernel.org,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lockdep-allow-instrumenting-lockdepc-with-kmsan.patch removed from -mm tree
Message-Id: <20221212021400.B2455C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lockdep: allow instrumenting lockdep.c with KMSAN
has been removed from the -mm tree.  Its filename was
     lockdep-allow-instrumenting-lockdepc-with-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lockdep: allow instrumenting lockdep.c with KMSAN
Date: Mon, 28 Nov 2022 10:45:40 +0100

Lockdep and KMSAN used to play badly together, causing deadlocks when
KMSAN instrumentation of lockdep.c called lockdep functions recursively.

Looks like this is no more the case, and a kernel can run (yet slower)
with both KMSAN and lockdep enabled.  This patch should fix false
positives on wq_head->lock->dep_map, which KMSAN used to consider
uninitialized because of lockdep.c not being instrumented.

Link: https://lore.kernel.org/lkml/Y3b9AAEKp2Vr3e6O@sol.localdomain/
Link: https://lkml.kernel.org/r/20221128094541.2645890-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/locking/Makefile~lockdep-allow-instrumenting-lockdepc-with-kmsan
+++ a/kernel/locking/Makefile
@@ -7,7 +7,6 @@ obj-y += mutex.o semaphore.o rwsem.o per
 
 # Avoid recursion lockdep -> sanitizer -> ... -> lockdep.
 KCSAN_SANITIZE_lockdep.o := n
-KMSAN_SANITIZE_lockdep.o := n
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = $(CC_FLAGS_FTRACE)
_

Patches currently in -mm which might be from glider@google.com are


