Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F932C432BE
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 21:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C4F6023E
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 21:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhHSVwM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 17:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHSVwL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 17:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D466103A;
        Thu, 19 Aug 2021 21:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629409894;
        bh=dYOwN+415iYyHGoauiuvAKGN/rxjmEZxlh6q+kyYND8=;
        h=Date:From:To:Subject:From;
        b=IYiKbkd+ZZfF4HepSnGIB7bGvavhZ9OEPKJhyet+btAy17+iZvonOkwCtpG96Priv
         yMpEGtd+LUGZRQ/r7HJzqhdwu6IDUn88P7dGyLVGHWwDkxrWeDwkXUtv8/iVPm6Kye
         01lMOQHZPD0ENRNUuxhAjuwFVLVWYRotBsrFOiAY=
Date:   Thu, 19 Aug 2021 14:51:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tdmackey@twitter.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        david@redhat.com, corbet@lwn.net, shy828301@gmail.com
Subject:  + doc-hwpoison-correct-the-support-for-hugepage.patch added
 to -mm tree
Message-ID: <20210819215134.uYBsp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: hwpoison: correct the support for hugepage
has been added to the -mm tree.  Its filename is
     doc-hwpoison-correct-the-support-for-hugepage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/doc-hwpoison-correct-the-support-for-hugepage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/doc-hwpoison-correct-the-support-for-hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: doc: hwpoison: correct the support for hugepage

The hwpoison support for huge page, both hugetlb and THP, has been in
kernel for a while, the statement in document is obsolete, correct it.

Link: https://lkml.kernel.org/r/20210819054116.266126-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Mackey <tdmackey@twitter.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hwpoison.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/hwpoison.rst~doc-hwpoison-correct-the-support-for-hugepage
+++ a/Documentation/vm/hwpoison.rst
@@ -180,7 +180,6 @@ Limitations
 ===========
 - Not all page types are supported and never will. Most kernel internal
   objects cannot be recovered, only LRU pages for now.
-- Right now hugepage support is missing.
 
 ---
 Andi Kleen, Oct 2009
_

Patches currently in -mm which might be from shy828301@gmail.com are

revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch
mm-hwpoison-dont-drop-slab-caches-for-offlining-non-lru-page.patch
doc-hwpoison-correct-the-support-for-hugepage.patch
mm-hwpoison-dump-page-for-unhandlable-page.patch

