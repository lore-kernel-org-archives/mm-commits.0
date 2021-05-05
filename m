Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA0CC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 20:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76CB613C9
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 20:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhEEUWw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 May 2021 16:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234108AbhEEUWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 5 May 2021 16:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75385613D8;
        Wed,  5 May 2021 20:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620246115;
        bh=pjEpZEW5DDMX5lkEh9Zet9TP9HrzT2GOBtalyzgu+Zw=;
        h=Date:From:To:Subject:From;
        b=iKt5E0O2Qd6qCjTe8CrGLClP5ZVRfTPDu3889Z+1Ne47gqR14/ICA91CDzuY2B6w6
         0Iww4IwoYRGZOpN2E0c70NQe4OhGLXd0mQyDnkATet6vSqAjEchYZAUjFYp7fxH3i8
         tqtCUbOtjUDVAKElWdQPJlfaoNR5m1G7335XhILw=
Date:   Wed, 05 May 2021 13:21:54 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        yaoaili@kingsoft.com
Subject:  +
 revert-mm-gup-check-page-posion-status-for-coredump.patch added to -mm tree
Message-ID: <20210505202154.AR2MYEcS7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/gup: check page posion status for coredump."
has been added to the -mm tree.  Its filename is
     revert-mm-gup-check-page-posion-status-for-coredump.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-gup-check-page-posion-status-for-coredump.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-gup-check-page-posion-status-for-coredump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm/gup: check page posion status for coredump."

While reviewing
http://lkml.kernel.org/r/20210429122519.15183-4-david@redhat.com I have
crossed d3378e86d182 ("mm/gup: check page posion status for coredump.")
and noticed that this patch is broken in two ways.  First it doesn't
really prevent hwpoison pages from being dumped because hwpoison pages can
be marked asynchornously at any time after the check.  Secondly, and more
importantly, the patch introduces a ref count leak because get_dump_page
takes a reference on the page which is not released.

It also seems that the patch was merged incorrectly because there were
follow up changes not included as well as discussions on how to address
the underlying problem
http://lkml.kernel.org/r/57ac524c-b49a-99ec-c1e4-ef5027bfb61b@redhat.com

Therefore revert the original patch.

Link: https://lkml.kernel.org/r/20210505135407.31590-1-mhocko@kernel.org
Fixes: d3378e86d182 ("mm/gup: check page posion status for coredump.")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c      |    4 ----
 mm/internal.h |   20 --------------------
 2 files changed, 24 deletions(-)

--- a/mm/gup.c~revert-mm-gup-check-page-posion-status-for-coredump
+++ a/mm/gup.c
@@ -1593,10 +1593,6 @@ struct page *get_dump_page(unsigned long
 				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
 	if (locked)
 		mmap_read_unlock(mm);
-
-	if (ret == 1 && is_page_poisoned(page))
-		return NULL;
-
 	return (ret == 1) ? page : NULL;
 }
 #endif /* CONFIG_ELF_CORE */
--- a/mm/internal.h~revert-mm-gup-check-page-posion-status-for-coredump
+++ a/mm/internal.h
@@ -96,26 +96,6 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
-/*
- * When kernel touch the user page, the user page may be have been marked
- * poison but still mapped in user space, if without this page, the kernel
- * can guarantee the data integrity and operation success, the kernel is
- * better to check the posion status and avoid touching it, be good not to
- * panic, coredump for process fatal signal is a sample case matching this
- * scenario. Or if kernel can't guarantee the data integrity, it's better
- * not to call this function, let kernel touch the poison page and get to
- * panic.
- */
-static inline bool is_page_poisoned(struct page *page)
-{
-	if (PageHWPoison(page))
-		return true;
-	else if (PageHuge(page) && PageHWPoison(compound_head(page)))
-		return true;
-
-	return false;
-}
-
 extern unsigned long highest_memmap_pfn;
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.com are

revert-mm-gup-check-page-posion-status-for-coredump.patch

