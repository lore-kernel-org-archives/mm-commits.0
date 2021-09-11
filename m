Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1361CC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E112860F9C
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhIKWRc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Sep 2021 18:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhIKWRb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 11 Sep 2021 18:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F5C60F8F;
        Sat, 11 Sep 2021 22:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631398578;
        bh=XwASxj4klra3u45n20Qwtq4p0Ck+7THw5iwuv9xq9U8=;
        h=Date:From:To:Subject:From;
        b=Zxo715UREYc6KmajM1O173LCA5jaOGpcPf95TERfOLDKAKZZhYvlYn7Mi68Dj0Sm8
         htnQEl07Ygdq6CuPf3/qV8UqtYRCQneN7JFUzmlfFPAcqxiiZK4nQ9pXaCvPqUTzUh
         yj95Yh5S9NvNOse/5Zn//bpU2q2qPOxaKFfmzFrU=
Date:   Sat, 11 Sep 2021 15:16:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  + mm-nommu-kill-arch_get_unmapped_area.patch added to -mm
 tree
Message-ID: <20210911221618.sEFRO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nommu: kill arch_get_unmapped_area()
has been added to the -mm tree.  Its filename is
     mm-nommu-kill-arch_get_unmapped_area.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-nommu-kill-arch_get_unmapped_area.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-nommu-kill-arch_get_unmapped_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: nommu: kill arch_get_unmapped_area()

When nommu, the arch_get_unmapped_area() will not be called, just kill it.

Link: https://lkml.kernel.org/r/20210910061906.36299-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/nommu.c~mm-nommu-kill-arch_get_unmapped_area
+++ a/mm/nommu.c
@@ -1639,12 +1639,6 @@ int remap_vmalloc_range(struct vm_area_s
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
-unsigned long arch_get_unmapped_area(struct file *file, unsigned long addr,
-	unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	return -ENOMEM;
-}
-
 vm_fault_t filemap_fault(struct vm_fault *vmf)
 {
 	BUG();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-nommu-kill-arch_get_unmapped_area.patch

