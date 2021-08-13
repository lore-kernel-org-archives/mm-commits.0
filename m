Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14271C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0379610FD
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbhHMXzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235397AbhHMXzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 19:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2659F610F7;
        Fri, 13 Aug 2021 23:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628898879;
        bh=NjQZrs+ymn1N+nS8UGQy8zm+/Gtdn8lVDmyEIRG5YNs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lUZv7W92e8FVCNZwU5YOyBZGutPKNEn5EwA1HP2L9VhFSn8JMx9+XU6SQ0I/mq+u2
         /bsSZ+Tny8jULBQwpiQTblcMwQS6F0VT8jQZh550BUwjbL+kHRDQgdAdYEb0Yk6duc
         kwDdp+bh/BtUGj44JKyVn4RqitSkvc/T5bQ75f9Q=
Date:   Fri, 13 Aug 2021 16:54:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        chris@zankel.net, dave.hansen@intel.com, david@redhat.com,
        deller@gmx.de, eike-kernel@sf-tec.de, hughd@google.com,
        ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com,
        jannh@google.com, jcmvbkbc@gmail.com, jgg@ziepe.ca,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 5/7] mm/madvise: report SIGBUS as -EFAULT for
 MADV_POPULATE_(READ|WRITE)
Message-ID: <20210813235437.jpdoEJdjF%akpm@linux-foundation.org>
In-Reply-To: <20210813165350.dc9afa56d27eadbd8ce629c0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/madvise: report SIGBUS as -EFAULT for MADV_POPULATE_(READ|WRITE)

Doing some extended tests and polishing the man page update for
MADV_POPULATE_(READ|WRITE), I realized that we end up converting also
SIGBUS (via -EFAULT) to -EINVAL, making it look like yet another madvise()
user error.

We want to report only problematic mappings and permission problems that
the user could have know as -EINVAL.

Let's not convert -EFAULT arising due to SIGBUS (or SIGSEGV) to -EINVAL,
but instead indicate -EFAULT to user space.  While we could also convert
it to -ENOMEM, using -EFAULT looks more helpful when user space might want
to troubleshoot what's going wrong: MADV_POPULATE_(READ|WRITE) is not part
of an final Linux release and we can still adjust the behavio= r.

Link: https://lkml.kernel.org/r/20210726154932.102880-1-david@redhat.com
Fixes: 4ca9b3859dac ("mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |    7 +++++--
 mm/madvise.c |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite
+++ a/mm/gup.c
@@ -1558,9 +1558,12 @@ long faultin_vma_page_range(struct vm_ar
 		gup_flags |= FOLL_WRITE;
 
 	/*
-	 * See check_vma_flags(): Will return -EFAULT on incompatible mappings
-	 * or with insufficient permissions.
+	 * We want to report -EINVAL instead of -EFAULT for any permission
+	 * problems or incompatible mappings.
 	 */
+	if (check_vma_flags(vma, gup_flags))
+		return -EINVAL;
+
 	return __get_user_pages(mm, start, nr_pages, gup_flags,
 				NULL, NULL, locked);
 }
--- a/mm/madvise.c~mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite
+++ a/mm/madvise.c
@@ -862,10 +862,12 @@ static long madvise_populate(struct vm_a
 			switch (pages) {
 			case -EINTR:
 				return -EINTR;
-			case -EFAULT: /* Incompatible mappings / permissions. */
+			case -EINVAL: /* Incompatible mappings / permissions. */
 				return -EINVAL;
 			case -EHWPOISON:
 				return -EHWPOISON;
+			case -EFAULT: /* VM_FAULT_SIGBUS or VM_FAULT_SIGSEGV */
+				return -EFAULT;
 			default:
 				pr_warn_once("%s: unhandled return value: %ld\n",
 					     __func__, pages);
_
