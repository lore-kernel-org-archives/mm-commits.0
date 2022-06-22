Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCB5C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 18:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiFVSdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jun 2022 14:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiFVSdz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2022 14:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC5319F9E
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 11:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8186183D
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 18:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C88C341C5;
        Wed, 22 Jun 2022 18:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655922833;
        bh=jcY9v/9XuyfzBitWHXm+5LUZRS0wwJSg1M8V0MENCrE=;
        h=Date:To:From:Subject:From;
        b=Y/Nb2BR2QDnbNHrJPwiRd33liAocSj4JbO5icbH/RomKvJ5ZyqnnskkaoCn/5CK/b
         o9Xwst+g/YCtAmWaSh1uk/atQhDCwetzdl+12FFdwF7CYmB0PWS0vIXBYy99wKl7if
         Eha4dg1sKqqJZJoK1YE9aRybqBERHkRcpO93s0J4=
Date:   Wed, 22 Jun 2022 11:33:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        bigeasy@linutronix.de, bagasdotme@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment.patch added to mm-hotfixes-unstable branch
Message-Id: <20220622183351.89C88C341C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: highmem: use literal block for code example in highmem.h comment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

documentation-highmem-use-literal-block-for-code-example-in-highmemh-comment.patch

