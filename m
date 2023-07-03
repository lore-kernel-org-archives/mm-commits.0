Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC2CEB64D9
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 00:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjGCAR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 20:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGCAR4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 20:17:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464491B9
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C236260C83
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 00:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B3DC433C8;
        Mon,  3 Jul 2023 00:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688343474;
        bh=/iskmbvrLdLVfnZ8X66vVU7uvT2wy+2zKQ2Fij4/0us=;
        h=Date:To:From:Subject:From;
        b=oHOJvCOuSWD7TrpraLdEwJwqp6RSEXjNVHtLMgHufmnGlmFPoQGuayCfakynztigN
         ZuHvNboa6gBps4aPERKVhQs0EIp3a659INHUrcZwGjJ7sNlZXD95ie4wwwQUxgL4UF
         pkb9ao/7Nlx8CVyeExXX5dnr+SWBPRAp9aJqdjXs=
Date:   Sun, 02 Jul 2023 17:17:53 -0700
To:     mm-commits@vger.kernel.org, jglisse@redhat.com,
        ira.weiny@intel.com, fmdefrancesco@gmail.com, drv@mailo.com,
        sumitraartsy@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-replace-kmap-with-kmap_local_page.patch added to mm-nonmm-unstable branch
Message-Id: <20230703001754.10B3DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: replace kmap() with kmap_local_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-replace-kmap-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-replace-kmap-with-kmap_local_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

lib-replace-kmap-with-kmap_local_page.patch

