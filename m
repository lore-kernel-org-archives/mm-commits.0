Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E84C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 18:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391465AbiDUSpq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391514AbiDUSpp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 14:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481A4BFFB
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 11:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 602FCB828C3
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 18:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3039C385A7;
        Thu, 21 Apr 2022 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650566572;
        bh=An+sqNgxyh39H7leyc1snl1dcT4gj8UCAHS7iZvAi4k=;
        h=Date:To:From:Subject:From;
        b=XKg957ocSErLITeWC4+VWsVldDc1hw99dLXiYFIUZ8612F9I8I+QZ3w/jNEY4qwbD
         tR/8jn+3gloM0AbIg51Kl8tr68uoMLGzYtIc4c/vxzbqb002BZXek/bc0pzIL7GDH0
         D0FS03QCN/jxBbYPvqrkqgHaQG5xouEhKw2cr6jc=
Date:   Thu, 21 Apr 2022 11:42:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, rppt@linux.ibm.com, peterz@infradead.org,
        ira.weiny@intel.com, corbet@lwn.net, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch added to -mm tree
Message-Id: <20220421184251.F3039C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: remove "Using kmap-atomic" from highmem.rst.
has been added to the -mm tree.  Its filename is
     documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/vm: remove "Using kmap-atomic" from highmem.rst.

The use of kmap_atomic() is deprecated in favor of kmap_local_page().  For
this reason the "Using kmap_atomic" section in highmem.rst is obsolete and
unnecessary.

Therefore, just remove it.

Link: https://lkml.kernel.org/r/20220421180200.16901-4-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/highmem.rst |   35 ---------------------------------
 1 file changed, 35 deletions(-)

--- a/Documentation/vm/highmem.rst~documentation-vm-remove-using-kmap-atomic-from-highmemrst
+++ a/Documentation/vm/highmem.rst
@@ -72,41 +72,6 @@ The kernel contains several ways of crea
   It may be assumed that k[un]map_atomic() won't fail.
 
 
-Using kmap_atomic
-=================
-
-When and where to use kmap_atomic() is straightforward.  It is used when code
-wants to access the contents of a page that might be allocated from high memory
-(see __GFP_HIGHMEM), for example a page in the pagecache.  The API has two
-functions, and they can be used in a manner similar to the following::
-
-	/* Find the page of interest. */
-	struct page *page = find_get_page(mapping, offset);
-
-	/* Gain access to the contents of that page. */
-	void *vaddr = kmap_atomic(page);
-
-	/* Do something to the contents of that page. */
-	memset(vaddr, 0, PAGE_SIZE);
-
-	/* Unmap that page. */
-	kunmap_atomic(vaddr);
-
-Note that the kunmap_atomic() call takes the result of the kmap_atomic() call
-not the argument.
-
-If you need to map two pages because you want to copy from one page to
-another you need to keep the kmap_atomic calls strictly nested, like::
-
-	vaddr1 = kmap_atomic(page1);
-	vaddr2 = kmap_atomic(page2);
-
-	memcpy(vaddr1, vaddr2, PAGE_SIZE);
-
-	kunmap_atomic(vaddr2);
-	kunmap_atomic(vaddr1);
-
-
 Cost of Temporary Mappings
 ==========================
 
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch
documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch
documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch
documentation-vm-rework-temporary-virtual-mappings.patch

