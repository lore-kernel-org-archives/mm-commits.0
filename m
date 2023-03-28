Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF0AC761A6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjC1XVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjC1XVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A182D54
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2224F619F1
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78805C4339C;
        Tue, 28 Mar 2023 23:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045679;
        bh=8QQtl/qjQCe3jhIhRxrCpXof0mJZAnV5BEm6O6i1bOY=;
        h=Date:To:From:Subject:From;
        b=oOwgsnVxJelH+p3r2SHszsWkuYlrIUM7V+Pxnd8COolrcf26OkXoPqfT9J9Ztq3WV
         zbe/V+IBE/Xl3xSWX0WhZuiDqe5Hpkf9kv4af48BHNcDEVsYBpptzny0TQ5esOGJXu
         6Y+XlpJ8qog7QBgq63gw99tnFoR3hQrLJ3Uhotro=
Date:   Tue, 28 Mar 2023 16:21:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        eugenis@google.com, catalin.marinas@arm.com, andreyknvl@gmail.com,
        pcc@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch removed from -mm tree
Message-Id: <20230328232119.78805C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: call clear_page with a match-all tag instead of changing page tag
has been removed from the -mm tree.  Its filename was
     kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/highmem.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

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


