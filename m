Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657FAC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30DF3221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781194;
	bh=5rfT/i4s+593qml7Ut21PXhKcASWpR843y+S52K+/I8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cXrjvnOSOtyJkbH05QSykGhJhnA1unJxvzg5rjRb/lWLLu2fi3heN/UrvVAH6a3L0
	 TEAUM0/XhN4dkosu0/TpU49oGhuZN9ZlK4rCrIzEkEI8fbUWo3cyBV/SilDkp+ChpT
	 OoNXlW/7wPekfP/4HyFN1IgQwuKewei85BVGSPrY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHGGTx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D312177B;
        Fri,  7 Aug 2020 06:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781192;
        bh=5rfT/i4s+593qml7Ut21PXhKcASWpR843y+S52K+/I8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pVNbSfkP/mhAK07lrNMLSJy8xE86Zpy2cAWWscTHHAymt0BtbS+L0P8ZAlFQDsPn1
         XzJwBlNdVcC9jHPukZtHnUZSt6/i7a0KnnbZz9PoJQGCOCanfqzLrSFD+KF9h91U4r
         CMchpkui1VL9J/mSpwGL7owpZgZV7fXjbp0uKsCY=
Date:   Thu, 06 Aug 2020 23:19:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 050/163] mm, dump_page: do not crash with bad
 compound_mapcount()
Message-ID: <20200807061951.-wx0cOeLH%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm, dump_page: do not crash with bad compound_mapcount()

If a compound page is being split while dump_page() is being run on that
page, we can end up calling compound_mapcount() on a page that is no
longer compound.  This leads to a crash (already seen at least once in the
field), due to the VM_BUG_ON_PAGE() assertion inside compound_mapcount().

(The above is from Matthew Wilcox's analysis of Qian Cai's bug report.)

A similar problem is possible, via compound_pincount() instead of
compound_mapcount().

In order to avoid this kind of crash, make dump_page() slightly more
robust, by providing a pair of simpler routines that don't contain
assertions: head_mapcount() and head_pincount().

For debug tools, we don't want to go *too* far in this direction, but this
is a simple small fix, and the crash has already been seen, so it's a good
trade-off.

Link: http://lkml.kernel.org/r/20200804214807.169256-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: Qian Cai <cai@lca.pw>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++++++--
 mm/debug.c         |    6 +++---
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-dump_page-do-not-crash-with-bad-compound_mapcount
+++ a/include/linux/mm.h
@@ -779,6 +779,11 @@ static inline void *kvcalloc(size_t n, s
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
+static inline int head_mapcount(struct page *head)
+{
+	return atomic_read(compound_mapcount_ptr(head)) + 1;
+}
+
 /*
  * Mapcount of compound page as a whole, does not include mapped sub-pages.
  *
@@ -788,7 +793,7 @@ static inline int compound_mapcount(stru
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	page = compound_head(page);
-	return atomic_read(compound_mapcount_ptr(page)) + 1;
+	return head_mapcount(page);
 }
 
 /*
@@ -901,11 +906,16 @@ static inline bool hpage_pincount_availa
 	return PageCompound(page) && compound_order(page) > 1;
 }
 
+static inline int head_pincount(struct page *head)
+{
+	return atomic_read(compound_pincount_ptr(head));
+}
+
 static inline int compound_pincount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!hpage_pincount_available(page), page);
 	page = compound_head(page);
-	return atomic_read(compound_pincount_ptr(page));
+	return head_pincount(page);
 }
 
 static inline void set_compound_order(struct page *page, unsigned int order)
--- a/mm/debug.c~mm-dump_page-do-not-crash-with-bad-compound_mapcount
+++ a/mm/debug.c
@@ -102,12 +102,12 @@ void __dump_page(struct page *page, cons
 		if (hpage_pincount_available(page)) {
 			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
-					compound_mapcount(head),
-					compound_pincount(head));
+					head_mapcount(head),
+					head_pincount(head));
 		} else {
 			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
-					compound_mapcount(head));
+					head_mapcount(head));
 		}
 	}
 	if (PageKsm(page))
_
