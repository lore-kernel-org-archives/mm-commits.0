Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE65C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiEYRRO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiEYRRO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:17:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB171AE271
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5144AB81D0D
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E3EC385B8;
        Wed, 25 May 2022 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653499029;
        bh=iWUvY7r3t0IVKJ3Pgl3g8w9BB0PYHEZr8MDS1VwinOA=;
        h=Date:To:From:Subject:From;
        b=jMV0VQmv7nQN0DexIgJvMfwUBIO8xa7YfRDAb/uxAxyZjORdhMcUKkL22J5DdnrdK
         d1TBF+GAkZtUG8h+b+VOLE9gcz+PaGhlcNlqKPsRftMKOj0LUjYI9D5ej+NnUoM1F2
         lsK7Fz2NxYUy8ctbS68f2CK5HKogmi8o6Q5A4hqA=
Date:   Wed, 25 May 2022 10:17:09 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-input-of-vmalloc_to_page.patch added to mm-unstable branch
Message-Id: <20220525171709.D3E3EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: fix input of vmalloc_to_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-fix-input-of-vmalloc_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-fix-input-of-vmalloc_to_page.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kasan: fix input of vmalloc_to_page()
Date: Wed, 25 May 2022 20:08:04 +0800

When print virtual mapping info for vmalloc address, it should pass
the addr not page, fix it.

Link: https://lkml.kernel.org/r/20220525120804.38155-1-wangkefeng.wang@huawei.com
Fixes: c056a364e954 ("kasan: print virtual mapping info in reports")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

mm-kfence-use-page_aligned-helper.patch
mm-kasan-fix-input-of-vmalloc_to_page.patch

