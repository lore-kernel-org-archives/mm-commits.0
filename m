Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C236C001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjHLWFP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjHLWFM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960349F
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AC66618F3
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80854C433C8;
        Sat, 12 Aug 2023 22:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877914;
        bh=m1VSuyVtiMe5riF6vidHIu55BnMroYhSfaJsPCeEmIg=;
        h=Date:To:From:Subject:From;
        b=RfWNHsZGiblWoE3wHrqGQiBN9UAAKSoifDZ858YqQJMHbfmZk3GLYUswKhnXR/jyY
         UjSBaHZEESQVAKkZXChUCvwyKqtYzi8nxJGUY+bXZ8qTMJImh5dfTf+ieeGLC4bbUE
         Qbs16YCHeQmg0nKUmWc5+B4vSuWGwuj7D72FGe6M=
Date:   Sat, 12 Aug 2023 15:05:13 -0700
To:     mm-commits@vger.kernel.org, jglisse@redhat.com,
        ira.weiny@intel.com, fmdefrancesco@gmail.com, drv@mailo.com,
        sumitraartsy@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-replace-kmap-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20230812220514.80854C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: replace kmap() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     lib-replace-kmap-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumitra Sharma <sumitraartsy@gmail.com>
Subject: lib: replace kmap() with kmap_local_page()
Date: Sat, 10 Jun 2023 10:57:12 -0700

kmap() has been deprecated in favor of the kmap_local_page() due to high
cost, restricted mapping space, the overhead of a global lock for
synchronization, and making the process sleep in the absence of free
slots.

kmap_local_page() is faster than kmap() and offers thread-local and
CPU-local mappings, take pagefaults in a local kmap region and preserves
preemption by saving the mappings of outgoing tasks and restoring those of
the incoming one during a context switch.

The mappings are kept thread local in the functions “dmirror_do_read”
and “dmirror_do_write” in test_hmm.c

Therefore, replace kmap() with kmap_local_page() and use
mempcy_from/to_page() to avoid open coding kmap_local_page() + memcpy() +
kunmap_local().

Remove the unused variable “tmp”.

Link: https://lkml.kernel.org/r/20230610175712.GA348514@sumitra.com
Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Deepak R Varma <drv@mailo.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/lib/test_hmm.c~lib-replace-kmap-with-kmap_local_page
+++ a/lib/test_hmm.c
@@ -368,16 +368,13 @@ static int dmirror_do_read(struct dmirro
 	for (pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++) {
 		void *entry;
 		struct page *page;
-		void *tmp;
 
 		entry = xa_load(&dmirror->pt, pfn);
 		page = xa_untag_pointer(entry);
 		if (!page)
 			return -ENOENT;
 
-		tmp = kmap(page);
-		memcpy(ptr, tmp, PAGE_SIZE);
-		kunmap(page);
+		memcpy_from_page(ptr, page, 0, PAGE_SIZE);
 
 		ptr += PAGE_SIZE;
 		bounce->cpages++;
@@ -437,16 +434,13 @@ static int dmirror_do_write(struct dmirr
 	for (pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++) {
 		void *entry;
 		struct page *page;
-		void *tmp;
 
 		entry = xa_load(&dmirror->pt, pfn);
 		page = xa_untag_pointer(entry);
 		if (!page || xa_pointer_tag(entry) != DPT_XA_TAG_WRITE)
 			return -ENOENT;
 
-		tmp = kmap(page);
-		memcpy(tmp, ptr, PAGE_SIZE);
-		kunmap(page);
+		memcpy_to_page(page, 0, ptr, PAGE_SIZE);
 
 		ptr += PAGE_SIZE;
 		bounce->cpages++;
_

Patches currently in -mm which might be from sumitraartsy@gmail.com are


