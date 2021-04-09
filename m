Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183CAC43462
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA30261181
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhDIU1e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CED161007;
        Fri,  9 Apr 2021 20:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000040;
        bh=SakCH8C8OtsgETv5kZZnG3bXMi7xsKfTvcCZqYP0FHM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vkYkBYll71ckwxgrQnMrqZxPkwqiidOhWNO6wK51c1bY3HNNKYdJqAHL+EHOHWPQr
         wMTYgM0I4d4JNLVlRZMJxymajkkIxFaO9yVRl/ihq6oYIuP2PBlrCaiUnmI6bH0foA
         KTOJF8TqfJbgjRMN+nGh8VcrSl3nhLswr1m5o1Ck=
Date:   Fri, 09 Apr 2021 13:27:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        yaoaili@kingsoft.com
Subject:  [patch 07/16] mm/gup: check page posion status for
 coredump.
Message-ID: <20210409202719.tI0cmqT6l%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[akpm@linux-foundation.org: s/0/false/]
[yaoaili@kingsoft.com: is_page_poisoned() arg cannot be null, per Matthew]
  Link: https://lkml.kernel.org/r/20210319104437.6f30e80d@alex-virtual-machine
  Link: https://lkml.kernel.org/r/20210322115233.05e4e82a@alex-virtual-machine
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
 mm/internal.h |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/mm/gup.c~mm-gup-check-page-posion-status-for-coredump
+++ a/mm/gup.c
@@ -1535,6 +1535,10 @@ struct page *get_dump_page(unsigned long
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
@@ -97,6 +97,26 @@ static inline void set_page_refcounted(s
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
+	if (PageHWPoison(page))
+		return true;
+	else if (PageHuge(page) && PageHWPoison(compound_head(page)))
+		return true;
+
+	return false;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
_
