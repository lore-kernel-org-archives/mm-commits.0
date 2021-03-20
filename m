Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF66C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 00:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C436E61981
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 00:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhCTAWr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 20:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhCTAWl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 20:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6088261981;
        Sat, 20 Mar 2021 00:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616199760;
        bh=K7THCkCgMa4W8Hh+6UnJbg0Fe3xmogUnuJY+tg9/pdE=;
        h=Date:From:To:Subject:From;
        b=ckpywjj/I9n3992Sj9FYUbB008OEVyzOosTz7Lp0N+s/iGzFnj27c1s9N8ZZChQ3b
         9BMzyilRa1bzY+6jVs/jMmozI0CUuJMwklNCzOnoJnoCRR/1Gd4b3Z5d2p+6bWHmoN
         IZh8zwdlaspeJpN43eHruWMA+elcvigcY1gBWNM8=
Date:   Fri, 19 Mar 2021 17:22:39 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, willy@infradead.org, yaoaili@kingsoft.com
Subject:  + mm-gup-check-page-posion-status-for-coredump.patch
 added to -mm tree
Message-ID: <20210320002239.C51n9i7t1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: check page posion status for coredump.
has been added to the -mm tree.  Its filename is
     mm-gup-check-page-posion-status-for-coredump.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-check-page-posion-status-for-coredump.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-check-page-posion-status-for-coredump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aili Yao <yaoaili@kingsoft.com>
Subject: mm/gup: check page posion status for coredump.

When we do coredump for user process signal, this may be an SIGBUS signal
with BUS_MCEERR_AR or BUS_MCEERR_AO code, which means this signal is
resulted from ECC memory fail like SRAR or SRAO, we expect the memory
recovery work is finished correctly, then the get_dump_page() will not
return the error page as its process pte is set invalid by
memory_failure().

But memory_failure() may fail, and the process's related pte may not be
correctly set invalid, for current code, we will return the poison page,
get it dumped, and then lead to system panic as its in kernel code.

So check the poison status in get_dump_page(), and if TRUE, return NULL.

There maybe other scenario that is also better to check the posion status
and not to panic, so make a wrapper for this check, Thanks to David's
suggestion(<david@redhat.com>).

Link: https://lkml.kernel.org/r/20210319104437.6f30e80d@alex-virtual-machine
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c      |    4 ++++
 mm/internal.h |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/mm/gup.c~mm-gup-check-page-posion-status-for-coredump
+++ a/mm/gup.c
@@ -1616,6 +1616,10 @@ struct page *get_dump_page(unsigned long
 				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
 	if (locked)
 		mmap_read_unlock(mm);
+
+	if (ret == 1 && is_page_poisoned(page))
+		return NULL;
+
 	return (ret == 1) ? page : NULL;
 }
 #endif /* CONFIG_ELF_CORE */
--- a/mm/internal.h~mm-gup-check-page-posion-status-for-coredump
+++ a/mm/internal.h
@@ -97,6 +97,27 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
+/*
+ * When kernel touch the user page, the user page may be have been marked
+ * poison but still mapped in user space, if without this page, the kernel
+ * can guarantee the data integrity and operation success, the kernel is
+ * better to check the posion status and avoid touching it, be good not to
+ * panic, coredump for process fatal signal is a sample case matching this
+ * scenario. Or if kernel can't guarantee the data integrity, it's better
+ * not to call this function, let kernel touch the poison page and get to
+ * panic.
+ */
+static inline bool is_page_poisoned(struct page *page)
+{
+	if (page != NULL) {
+		if (PageHWPoison(page))
+			return true;
+		else if (PageHuge(page) && PageHWPoison(compound_head(page)))
+			return true;
+	}
+	return 0;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
_

Patches currently in -mm which might be from yaoaili@kingsoft.com are

mm-gup-check-page-posion-status-for-coredump.patch

