Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B74C3DA79
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 22:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiLUWcb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbiLUWcb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 17:32:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F19DAC;
        Wed, 21 Dec 2022 14:32:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4341461976;
        Wed, 21 Dec 2022 22:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A53CC433F2;
        Wed, 21 Dec 2022 22:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661949;
        bh=2yLkDteIj1OeDcKn3MhRw5Sf3kPdg9r0G/YVg2KLLQw=;
        h=Date:To:From:Subject:From;
        b=MKhQL2aPBLQ0GkxCMWZEV+QXNVR9UUkURpNPo9pvM0LBRLpHfn0RzbfwlE3RXGha2
         6qcSrYF8IP2wa5JRayoNGhfYG9yJbVaXmvE0QANX17o6/SrQuZ/IIg/2BSKYY0lvfJ
         zNjKCiknKNxIiMQNQsXe7yGKOyPCmEkLJcLHNPLo=
Date:   Wed, 21 Dec 2022 14:32:28 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-include-linux-vmalloch.patch removed from -mm tree
Message-Id: <20221221223229.9A53CC433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: include linux/vmalloc.h
has been removed from the -mm tree.  Its filename was
     kmsan-include-linux-vmalloch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: include linux/vmalloc.h
Date: Thu, 15 Dec 2022 17:30:17 +0100

This is needed for the vmap/vunmap declarations:

mm/kmsan/kmsan_test.c:316:9: error: implicit declaration of function 'vmap' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
        vbuf = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
               ^
mm/kmsan/kmsan_test.c:316:29: error: use of undeclared identifier 'VM_MAP'
        vbuf = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
                                   ^
mm/kmsan/kmsan_test.c:322:3: error: implicit declaration of function 'vunmap' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                vunmap(vbuf);
                ^

Link: https://lkml.kernel.org/r/20221215163046.4079767-1-arnd@kernel.org
Fixes: 8ed691b02ade ("kmsan: add tests for KMSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-include-linux-vmalloch
+++ a/mm/kmsan/kmsan_test.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/tracepoint.h>
+#include <linux/vmalloc.h>
 #include <trace/events/printk.h>
 
 static DEFINE_PER_CPU(int, per_cpu_var);
_

Patches currently in -mm which might be from arnd@arndb.de are


