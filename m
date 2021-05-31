Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B99C47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C66061287
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhEaV4n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhEaV4m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C2361002;
        Mon, 31 May 2021 21:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622498101;
        bh=9j+hwN4Jijk8hVMUR/kGD1TDEjqZiMpsKuaTf0Xb1/8=;
        h=Date:From:To:Subject:From;
        b=FOHMA3RK8fQarGJFpojSIyt1DMjN0kHQ+doFhk2IhvPXo0cFzZVXGmmIh0/NVxeXz
         kOxD1XV0asiN7fTKYAXmGIcxEafNU76+qYwLzVrCvOMwaYfTSf9ve/NrpHnxaXyq6R
         RaeoJQLPCgApnMshsI8w6qXr19hBbsqhGyOESMY0=
Date:   Mon, 31 May 2021 14:55:01 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, david@redhat.com, mm-commits@vger.kernel.org
Subject:  + mm-page_alloc-improve-memmap_pages-dbg-msg.patch added
 to -mm tree
Message-ID: <20210531215501.8Ey2wRdEB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: improve memmap_pages dbg msg
has been added to the -mm tree.  Its filename is
     mm-page_alloc-improve-memmap_pages-dbg-msg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-improve-memmap_pages-dbg-msg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-improve-memmap_pages-dbg-msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: mm/page_alloc: improve memmap_pages dbg msg

Make debug message more accurate.

Link: https://lkml.kernel.org/r/20210531091908.1738465-6-aisheng.dong@nxp.com
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-improve-memmap_pages-dbg-msg
+++ a/mm/page_alloc.c
@@ -7358,7 +7358,7 @@ static void __init free_area_init_core(s
 					pr_debug("  %s zone: %lu pages used for memmap\n",
 						 zone_names[j], memmap_pages);
 			} else
-				pr_warn("  %s zone: %lu pages exceeds freesize %lu\n",
+				pr_warn("  %s zone: %lu memmap pages exceeds freesize %lu\n",
 					zone_names[j], memmap_pages, freesize);
 		}
 
_

Patches currently in -mm which might be from aisheng.dong@nxp.com are

mm-rename-the-global-section-array-to-mem_sections.patch
mm-drop-section_shift-in-code-comments.patch
mm-page_alloc-improve-memmap_pages-dbg-msg.patch

