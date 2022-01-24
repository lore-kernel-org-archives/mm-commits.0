Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64105C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jan 2022 02:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbiAXCmZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 21:42:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47302 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiAXCmX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 21:42:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02D3561250
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 02:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473D0C340E3;
        Mon, 24 Jan 2022 02:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642992142;
        bh=x34EijJwMS1luUNxYCDrxX+BlCnfCWdQC7yjKAVnF9w=;
        h=Date:From:To:Subject:From;
        b=Cfq1mbw/RwL+eDD1HTeq18hRZdUhpdySK4cCPiL44XCRc3oS5pJOpDjNCwl/EJQTq
         nH/5L/6RVgwoHUUaE3HJyvgKyvenob2+u1C0vvFxQga2LIm0ZlkvYExaKa7/zWNRpL
         rTAP7HjDXLlfKX8GzR65snvba7iVLDOTqXVE7w4Y=
Date:   Sun, 23 Jan 2022 18:42:21 -0800
From:   akpm@linux-foundation.org
To:     ira.weiny@intel.com, mm-commits@vger.kernel.org
Subject:  + highmem-document-kunmap_local.patch added to -mm tree
Message-ID: <20220124024221.UzWCdkiOj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: document kunmap_local()
has been added to the -mm tree.  Its filename is
     highmem-document-kunmap_local.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/highmem-document-kunmap_local.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/highmem-document-kunmap_local.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: highmem: document kunmap_local()

Some users of kmap() add an offset to the kmap() address to be used during
the mapping.

When converting to kmap_local_page() the base address does not need to be
stored because any address within the page can be used in kunmap_local(). 
However, this was not clear from the documentation and caused some
questions.[1]

Document that any address in the page can be used in kunmap_local() to
clarify this for future users.

[1] https://lore.kernel.org/lkml/20211213154543.GM3538886@iweiny-DESK2.sc.intel.com/

Link: https://lkml.kernel.org/r/20220124013045.806718-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/highmem-internal.h~highmem-document-kunmap_local
+++ a/include/linux/highmem-internal.h
@@ -246,6 +246,17 @@ do {								\
 	__kunmap_atomic(__addr);				\
 } while (0)
 
+/**
+ * kunmap_local - Unmap a page mapped via kmap_local_page().
+ * @__addr: An address within the page mapped
+ *
+ * __addr is often an address returned from kmap_local_page().  However,
+ * this address can be any address within the mapped page.  It does not need to
+ * be the exact address returned from kmap_local_page()
+ *
+ * Unmapping should be done in the reverse order of the mapping.  See
+ * kmap_local_page() for details.
+ */
 #define kunmap_local(__addr)					\
 do {								\
 	BUILD_BUG_ON(__same_type((__addr), struct page *));	\
_

Patches currently in -mm which might be from ira.weiny@intel.com are

highmem-document-kunmap_local.patch

