Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA65C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiENTzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbiENTzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87145377EA
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0FB61138
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71444C340EE;
        Sat, 14 May 2022 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558115;
        bh=YnZJWak8oL/fun9ZO02CmrDSCdBTzyJkRA+Sl7Rkwak=;
        h=Date:To:From:Subject:From;
        b=Vj+q2vqUHcn7VMBLE47NP+0rRVZhzsrrL455g4hAA5B5ZQxXkgEXFEeF19e3UsAc3
         wnuEbrDXaZXqWrsbfDpOoGiwGwvVdcXlTGjvkKfYom9ENcPlgu+mz05w56gz+qever
         HALuc0O+V5Zn97x28yDswu0idYkWSROcfr5HV+Cw=
Date:   Sat, 14 May 2022 12:55:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        peterz@infradead.org, pcc@google.com, ira.weiny@intel.com,
        corbet@lwn.net, catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-vm-move-using-kmap-atomic-to-highmemh.patch removed from -mm tree
Message-Id: <20220514195515.71444C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/vm: move "Using kmap-atomic" to highmem.h
has been removed from the -mm tree.  Its filename was
     documentation-vm-move-using-kmap-atomic-to-highmemh.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/vm: move "Using kmap-atomic" to highmem.h

The use of kmap_atomic() is new code is being deprecated in favor of
kmap_local_page().  For this reason the "Using kmap_atomic" section in
highmem.rst is obsolete and unnecessary, but it can still help developers
if it were moved to kdocs in highmem.h.

Therefore, move the relevant parts of this section from highmem.rst and
merge them with the kdocs in highmem.h.

Link: https://lkml.kernel.org/r/20220428212455.892-4-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/highmem.rst |   35 ---------------------------------
 include/linux/highmem.h      |   31 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 35 deletions(-)

--- a/Documentation/vm/highmem.rst~documentation-vm-move-using-kmap-atomic-to-highmemh
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
 
--- a/include/linux/highmem.h~documentation-vm-move-using-kmap-atomic-to-highmemh
+++ a/include/linux/highmem.h
@@ -145,6 +145,37 @@ static inline void *kmap_local_folio(str
  * Mappings should always be released by kunmap_atomic().
  *
  * Do not use in new code. Use kmap_local_page() instead.
+ *
+ * It is used in atomic context when code wants to access the contents of a
+ * page that might be allocated from high memory (see __GFP_HIGHMEM), for
+ * example a page in the pagecache.  The API has two functions, and they
+ * can be used in a manner similar to the following:
+ *
+ * -- Find the page of interest. --
+ * struct page *page = find_get_page(mapping, offset);
+ *
+ * -- Gain access to the contents of that page. --
+ * void *vaddr = kmap_atomic(page);
+ *
+ * -- Do something to the contents of that page. --
+ * memset(vaddr, 0, PAGE_SIZE);
+ *
+ * -- Unmap that page. --
+ * kunmap_atomic(vaddr);
+ *
+ * Note that the kunmap_atomic() call takes the result of the kmap_atomic()
+ * call, not the argument.
+ *
+ * If you need to map two pages because you want to copy from one page to
+ * another you need to keep the kmap_atomic calls strictly nested, like:
+ *
+ * vaddr1 = kmap_atomic(page1);
+ * vaddr2 = kmap_atomic(page2);
+ *
+ * memcpy(vaddr1, vaddr2, PAGE_SIZE);
+ *
+ * kunmap_atomic(vaddr2);
+ * kunmap_atomic(vaddr1);
  */
 static inline void *kmap_atomic(struct page *page);
 
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


