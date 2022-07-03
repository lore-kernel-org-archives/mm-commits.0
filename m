Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C07C43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiGCWoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiGCWnw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:43:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9078D0
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 15:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5710EB80CE7
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 22:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E21C341C6;
        Sun,  3 Jul 2022 22:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888229;
        bh=x5NxpZlk3wRkaIM/kOYm3m/VZV54eyLItfIU/vSCypc=;
        h=Date:To:From:Subject:From;
        b=N5+U2YOUNbxm/ipY9R5IzbsuQ4Cbk1CbKMobaaklkd8JA7Z9O2bpZsrSCNQJK/FB6
         O4Ge3BQDkzUX6LuF5ObQMcewv6HaUXGgyFmb+iqandlcIgZ8K7pO5au017bttHqoTl
         6XSdcSWfuvDyq+dWekHrX4zkO07sqQqqIy6fyC3A=
Date:   Sun, 03 Jul 2022 15:43:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        bigeasy@linutronix.de, bagasdotme@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment.patch removed from -mm tree
Message-Id: <20220703224348.F2E21C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: highmem: use literal block for code example in highmem.h comment
has been removed from the -mm tree.  Its filename was
     documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Documentation: highmem: use literal block for code example in highmem.h comment
Date: Wed, 22 Jun 2022 15:45:46 +0700

When building htmldocs on Linus's tree, there are inline emphasis warnings
on include/linux/highmem.h:

Documentation/vm/highmem:166: ./include/linux/highmem.h:154: WARNING: Inline emphasis start-string without end-string.
Documentation/vm/highmem:166: ./include/linux/highmem.h:157: WARNING: Inline emphasis start-string without end-string.

These warnings above are due to comments in code example at the mentioned
lines above are enclosed by double dash (--), which confuses Sphinx as
inline markup delimiters instead.

Fix these warnings by indenting the code example with literal block
indentation and making the comments C comments.

Link: https://lkml.kernel.org/r/20220622084546.17745-1-bagasdotme@gmail.com
Fixes: 85a85e7601263f ("Documentation/vm: move "Using kmap-atomic" to highmem.h")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/highmem.h~documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment
+++ a/include/linux/highmem.h
@@ -149,19 +149,19 @@ static inline void *kmap_local_folio(str
  * It is used in atomic context when code wants to access the contents of a
  * page that might be allocated from high memory (see __GFP_HIGHMEM), for
  * example a page in the pagecache.  The API has two functions, and they
- * can be used in a manner similar to the following:
+ * can be used in a manner similar to the following::
  *
- * -- Find the page of interest. --
- * struct page *page = find_get_page(mapping, offset);
+ *   // Find the page of interest.
+ *   struct page *page = find_get_page(mapping, offset);
  *
- * -- Gain access to the contents of that page. --
- * void *vaddr = kmap_atomic(page);
+ *   // Gain access to the contents of that page.
+ *   void *vaddr = kmap_atomic(page);
  *
- * -- Do something to the contents of that page. --
- * memset(vaddr, 0, PAGE_SIZE);
+ *   // Do something to the contents of that page.
+ *   memset(vaddr, 0, PAGE_SIZE);
  *
- * -- Unmap that page. --
- * kunmap_atomic(vaddr);
+ *   // Unmap that page.
+ *   kunmap_atomic(vaddr);
  *
  * Note that the kunmap_atomic() call takes the result of the kmap_atomic()
  * call, not the argument.
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


