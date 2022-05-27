Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B4FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349713AbiE0Qf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349268AbiE0QfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5E752B0A
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B43561DE4
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CFFC385A9;
        Fri, 27 May 2022 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669315;
        bh=ZB29TzbjHikJY3+Qem+cvBgoNY1QWN9Nu4SwcFZAsGI=;
        h=Date:To:From:Subject:From;
        b=VHe6RYqNXrB8WJV/Lo73N2o+53LXytIQ2VLDeC2cyrBkIgt6joCWAVcujlbfWMw8F
         0kb9bSIVPXixBCLQYwzeNbgyf9npAbbFzD/oaGYEWU8U3912W5uiFB7HOkBePzCrlQ
         rc7U8X4aBCsqVglAfEMUbH+NnLwbib3uGUgxg9Oo=
Date:   Fri, 27 May 2022 09:35:14 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-fix-input-of-vmalloc_to_page.patch removed from -mm tree
Message-Id: <20220527163515.86CFFC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kasan: fix input of vmalloc_to_page()
has been removed from the -mm tree.  Its filename was
     mm-kasan-fix-input-of-vmalloc_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kasan: fix input of vmalloc_to_page()
Date: Wed, 25 May 2022 20:08:04 +0800

When print virtual mapping info for vmalloc address, it should pass
the addr not page, fix it.

Link: https://lkml.kernel.org/r/20220525120804.38155-1-wangkefeng.wang@huawei.com
Fixes: c056a364e954 ("kasan: print virtual mapping info in reports")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report.c~mm-kasan-fix-input-of-vmalloc_to_page
+++ a/mm/kasan/report.c
@@ -347,7 +347,7 @@ static void print_address_description(vo
 			       va->addr, va->addr + va->size, va->caller);
 			pr_err("\n");
 
-			page = vmalloc_to_page(page);
+			page = vmalloc_to_page(addr);
 		}
 	}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


