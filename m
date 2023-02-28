Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295D1C64ED6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 02:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjB1CEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 21:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjB1CEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 21:04:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECC51CF5F
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 18:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E36BB80DDF
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 02:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2578C433D2;
        Tue, 28 Feb 2023 02:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677549888;
        bh=hqcKbASVMz2ze4psEkhJD+Yo5KMPKmFdk80h9rqh074=;
        h=Date:To:From:Subject:From;
        b=D85Xp/DGrlPf+LNuJeWMt2t6rFPdicSv74DpTJCyVjNo1IQXHv2sKiNh3CNJPFfjB
         tYNuVx9DwFUhg/G/Nu22/QV5Lh1J1JFrIAdwPFKg0StikFwJ0dLDloKldJ6kVJF2Zw
         orzdbpH6mRwmkK3HRs8Qqh/gtChaxATr12M6+TxE=
Date:   Mon, 27 Feb 2023 18:04:47 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        eugenis@google.com, catalin.marinas@arm.com, andreyknvl@gmail.com,
        pcc@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch added to mm-unstable branch
Message-Id: <20230228020447.F2578C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: call clear_page with a match-all tag instead of changing page tag
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch

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
From: Peter Collingbourne <pcc@google.com>
Subject: kasan: call clear_page with a match-all tag instead of changing page tag
Date: Thu, 16 Feb 2023 11:59:24 -0800

Instead of changing the page's tag solely in order to obtain a pointer
with a match-all tag and then changing it back again, just convert the
pointer that we get from kmap_atomic() into one with a match-all tag
before passing it to clear_page().

On a certain microarchitecture, this has been observed to cause a
measurable improvement in microbenchmark performance, presumably as a
result of being able to avoid the atomic operations on the page tag.

Link: https://lkml.kernel.org/r/20230216195924.3287772-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I0249822cc29097ca7a04ad48e8eb14871f80e711
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/highmem.h~kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag
+++ a/include/linux/highmem.h
@@ -243,12 +243,10 @@ static inline void clear_highpage(struct
 
 static inline void clear_highpage_kasan_tagged(struct page *page)
 {
-	u8 tag;
+	void *kaddr = kmap_local_page(page);
 
-	tag = page_kasan_tag(page);
-	page_kasan_tag_reset(page);
-	clear_highpage(page);
-	page_kasan_tag_set(page, tag);
+	clear_page(kasan_reset_tag(kaddr));
+	kunmap_local(kaddr);
 }
 
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
_

Patches currently in -mm which might be from pcc@google.com are

kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch

