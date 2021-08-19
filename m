Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55953C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 21:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF006023E
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 21:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhHSVwO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 17:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHSVwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 17:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D116109E;
        Thu, 19 Aug 2021 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629409896;
        bh=7idUfie+KxQQ7ECqSY4vLARGU8TigMlHID/EXnLnypI=;
        h=Date:From:To:Subject:From;
        b=in0bzkRZvFOYtrcbm+AD78t/i2ibx1k6uMoo9pBh43B+FvlJM+8s50JYEPg1iFVgB
         NPaRDuRET1I6mpF6mpawb1wE1gXfeXekZ7lutoscc+m+EGjGI9sLebqL/LmUDTtn/M
         kA3IjriAvPqLsdiqwIjbX8KrMYDIanNfhPDJE37o=
Date:   Thu, 19 Aug 2021 14:51:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tdmackey@twitter.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        david@redhat.com, corbet@lwn.net, shy828301@gmail.com
Subject:  + mm-hwpoison-dump-page-for-unhandlable-page.patch added to
 -mm tree
Message-ID: <20210819215136.LOSVx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: dump page for unhandlable page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-dump-page-for-unhandlable-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-dump-page-for-unhandlable-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-dump-page-for-unhandlable-page.patch

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
Subject: mm: hwpoison: dump page for unhandlable page

Currently just very simple message is shown for unhandlable page, e.g.
non-LRU page, like:
soft_offline: 0x1469f2: unknown non LRU page type 5ffff0000000000 ()

It is not very helpful for further debug, calling dump_page() could show
more useful information.

Calling dump_page() in get_any_page() in order to not duplicate the call
in a couple of different places.  It may be called with pcp disabled and
holding memory hotplug lock, it should be not a big deal since hwpoison
handler is not called very often.

Link: https://lkml.kernel.org/r/20210819054116.266126-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Mackey <tdmackey@twitter.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-dump-page-for-unhandlable-page
+++ a/mm/memory-failure.c
@@ -1228,6 +1228,9 @@ try_again:
 		ret = -EIO;
 	}
 out:
+	if (ret == -EIO)
+		dump_page(p, "hwpoison: unhandlable page");
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch
mm-hwpoison-dont-drop-slab-caches-for-offlining-non-lru-page.patch
doc-hwpoison-correct-the-support-for-hugepage.patch
mm-hwpoison-dump-page-for-unhandlable-page.patch

