Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17A3C001B0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Aug 2023 21:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbjHOV2m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Aug 2023 17:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240251AbjHOV2d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2023 17:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0D283
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 14:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D5263A6F
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 21:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ED4C433C8;
        Tue, 15 Aug 2023 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692134910;
        bh=86qPEBVrtfrtw0jcjOmzA3/Y1ZD+tqKha5rC3OI0FF4=;
        h=Date:To:From:Subject:From;
        b=SMJylzJr3lSIRKwmnhyxfUDgDm19fDVhkgV3vsDUFyrrYo36NBDK4bzAPOICpCmLu
         LG5FfS8itnWnMO88EjtMOhbqAz6/yk3cyfLMbqF/qokjVi1eYj2Ig5OzftLAsXrWJY
         ehAUc+LoEGNiIRF30CTxTzVkUlwY474gY8TkzRCY=
Date:   Tue, 15 Aug 2023 14:28:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pagemap-remove-wait_on_page_locked_killable.patch added to mm-unstable branch
Message-Id: <20230815212830.81ED4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: remove wait_on_page_locked_killable()
has been added to the -mm mm-unstable branch.  Its filename is
     pagemap-remove-wait_on_page_locked_killable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pagemap-remove-wait_on_page_locked_killable.patch

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
Subject: pagemap: remove wait_on_page_locked_killable()
Date: Tue, 15 Aug 2023 11:06:09 +0800

There is no users of wait_on_page_locked_killable(), remove it.

Link: https://lkml.kernel.org/r/20230815030609.39313-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~pagemap-remove-wait_on_page_locked_killable
+++ a/include/linux/pagemap.h
@@ -1069,11 +1069,6 @@ static inline void wait_on_page_locked(s
 	folio_wait_locked(page_folio(page));
 }
 
-static inline int wait_on_page_locked_killable(struct page *page)
-{
-	return folio_wait_locked_killable(page_folio(page));
-}
-
 void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch
arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch
mm-memtest-convert-to-memtest_report_meminfo.patch
pagemap-remove-wait_on_page_locked_killable.patch

