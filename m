Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F4AC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 18:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiD0S7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiD0S6v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 14:58:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5751C89CCC
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 11:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B3F9B8267E
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 18:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA33C385A7;
        Wed, 27 Apr 2022 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651085068;
        bh=qEdrIc/DA9dfjq2klPhSnRUP81H6mMq6FKFKUNh2H14=;
        h=Date:To:From:Subject:From;
        b=Eqfjlq2gzvorvmqpw3gn03l4fqdQVQvc56UHQ4qd/qDDuctjg8Kgnrn2kHdq2H2tN
         e628nhcJPZ92h1+QV1eSxZl2vH9Py+qS9K0/DllT7Ayg9s/8aYubZcZNoCbjcr38Us
         yfKRpVbeX8YS2gueURGfuUVb1WHo0HEI3XPbhqPY=
Date:   Wed, 27 Apr 2022 11:44:28 -0700
To:     mm-commits@vger.kernel.org, wanjiabing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-duplicate-include-in-memoryc.patch added to -mm tree
Message-Id: <20220427184428.BBA33C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: remove duplicate include in memory.c
has been added to the -mm tree.  Its filename is
     mm-shmem-remove-duplicate-include-in-memoryc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-remove-duplicate-include-in-memoryc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-remove-duplicate-include-in-memoryc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: mm/shmem: remove duplicate include in memory.c

Fix following checkincludes.pl warning:
mm/memory.c: linux/mm_inline.h is included more than once.

The include is in line 44. Remove the duplicated here.

Link: https://lkml.kernel.org/r/20220427064717.803019-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-shmem-remove-duplicate-include-in-memoryc
+++ a/mm/memory.c
@@ -74,7 +74,6 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
-#include <linux/mm_inline.h>
 
 #include <trace/events/kmem.h>
 
_

Patches currently in -mm which might be from wanjiabing@vivo.com are

mm-shmem-remove-duplicate-include-in-memoryc.patch

