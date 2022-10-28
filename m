Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993B7FA3748
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJ1VHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJ1VH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5728249D3E
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7090662A79
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44B2C433D7;
        Fri, 28 Oct 2022 21:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991242;
        bh=9KPcYTtW3xjZzkFpx9y2G9zmXue9PGf7ew1uUqmfFYM=;
        h=Date:To:From:Subject:From;
        b=yfO9S6QpTRDULB62bDXmTEJJ4y87SXDn9anYh7TYMFcAWtMkJ23+ydHXpUZCXnYJA
         1uLo5+UqH2b1xxemMXCVrvtVIB5iHThYocp6s87M7vmh0xVYAt/eA9Q3x+SROKLf6A
         G4Ifi5bkpL/dtvNdhs+EDiRGL0/wld6DPPJFVJoI=
Date:   Fri, 28 Oct 2022 14:07:21 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-purgatory-disable-kmsan-instrumentation.patch removed from -mm tree
Message-Id: <20221028210722.B44B2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/purgatory: disable KMSAN instrumentation
has been removed from the -mm tree.  Its filename was
     x86-purgatory-disable-kmsan-instrumentation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86/purgatory: disable KMSAN instrumentation
Date: Mon, 24 Oct 2022 23:21:41 +0200

The stand-alone purgatory.ro does not contain the KMSAN runtime, therefore
it can't be built with KMSAN compiler instrumentation.

Link: https://lkml.kernel.org/r/20221024212144.2852069-2-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/purgatory/Makefile~x86-purgatory-disable-kmsan-instrumentation
+++ a/arch/x86/purgatory/Makefile
@@ -26,6 +26,7 @@ GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
 UBSAN_SANITIZE	:= n
 KCSAN_SANITIZE	:= n
+KMSAN_SANITIZE	:= n
 KCOV_INSTRUMENT := n
 
 # These are adjustments to the compiler flags used for objects that
_

Patches currently in -mm which might be from glider@google.com are


