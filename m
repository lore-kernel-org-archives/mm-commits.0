Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD939C43334
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiFFTqD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFFTqB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:46:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3572262B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F73B8198B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57733C385A9;
        Mon,  6 Jun 2022 19:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654544757;
        bh=D7Ojb52XW6XELAEQRM0DyubOCVz0UloN7smgvXi208Q=;
        h=Date:To:From:Subject:From;
        b=uaikQkQ9M6n32bJa7YgnfoBIxkjiwnotG8H2vaOcBXcvaLU695uG0KYhA+Pj+8Aj3
         S6C6csR66GXmjl3ROY3JGn5ssz1u1H4K61N6m/9jVMR/xEoOQ/w5vQ7AWH5mXGJkGY
         9WIrboLaYT9kjruYBsnBaavMC6mPiTE/b7zNxV2o=
Date:   Mon, 06 Jun 2022 12:45:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, bigeasy@linutronix.de, bhe@redhat.com,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-delete-memmove_page.patch added to mm-unstable branch
Message-Id: <20220606194557.57733C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: delete memmove_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-delete-memmove_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-delete-memmove_page.patch

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
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: delete memmove_page()
Date: Mon, 6 Jun 2022 16:15:33 +0200

Matthew Wilcox reported that, while he was looking at memmove_page(), he
realized that it can't actually work.

The reasons are hidden in its implementation, which makes use of memmove()
on logical addresses provided by kmap_local_page().  memmove() does the
wrong thing when it tests "if (dest <= src)".

Therefore, delete memmove_page().

No need to change any other code because we have no call sites of
memmove_page() across the whole kernel.

Link: https://lkml.kernel.org/r/20220606141533.555-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-delete-memmove_page
+++ a/include/linux/highmem.h
@@ -347,19 +347,6 @@ static inline void memcpy_page(struct pa
 	kunmap_local(dst);
 }
 
-static inline void memmove_page(struct page *dst_page, size_t dst_off,
-			       struct page *src_page, size_t src_off,
-			       size_t len)
-{
-	char *dst = kmap_local_page(dst_page);
-	char *src = kmap_local_page(src_page);
-
-	VM_BUG_ON(dst_off + len > PAGE_SIZE || src_off + len > PAGE_SIZE);
-	memmove(dst + dst_off, src + src_off, len);
-	kunmap_local(src);
-	kunmap_local(dst);
-}
-
 static inline void memset_page(struct page *page, size_t offset, int val,
 			       size_t len)
 {
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-delete-memmove_page.patch

