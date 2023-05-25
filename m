Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBE2C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 20:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbjEYUtF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241695AbjEYUtE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 16:49:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B52135
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 13:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A0B619B0
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 20:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25777C433EF;
        Thu, 25 May 2023 20:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685047742;
        bh=8A82l1m8Ac9qJD5U0eXX81E4ntLlN877Buhsbp9DFaM=;
        h=Date:To:From:Subject:From;
        b=GZ9SS7oxz9qJ7uXqEprPSFwZw8JLq56DZGUTj62pfU7upOTaDrGqKdXEgQarySTg6
         euuVFgzn5DzG5Fln2ydgVh2YI8d8eSGSSG/FI0scl0uymGlK7CsjntDoTmy4EqZqRS
         HBC3Sk+HpLRDhnSWMExWENAd7MqtdXO2GvDx99vI=
Date:   Thu, 25 May 2023 13:49:01 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-avoid-garbage-in-page-array.patch added to mm-hotfixes-unstable branch
Message-Id: <20230525204902.25777C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: avoid garbage in page array
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-test_vmallocc-avoid-garbage-in-page-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-avoid-garbage-in-page-array.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: lib/test_vmalloc.c: avoid garbage in page array
Date: Wed, 24 May 2023 09:24:24 +0100

It turns out that alloc_pages_bulk_array() does not treat the page_array
parameter as an output parameter, but rather reads the array and skips any
entries that have already been allocated.

This is somewhat unexpected and breaks this test, as we allocate the pages
array uninitialised on the assumption it will be overwritten.

As a result, the test was referencing uninitialised data and causing the
PFN to not be valid and thus a WARN_ON() followed by a null pointer deref
and panic.

In addition, this is an array of pointers not of struct page objects, so we
need only allocate an array with elements of pointer size.

We solve both problems by simply using kcalloc() and referencing
sizeof(struct page *) rather than sizeof(struct page).

Link: https://lkml.kernel.org/r/20230524082424.10022-1-lstoakes@gmail.com
Fixes: 869cb29a61a1 ("lib/test_vmalloc.c: add vm_map_ram()/vm_unmap_ram() test case")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-avoid-garbage-in-page-array
+++ a/lib/test_vmalloc.c
@@ -369,7 +369,7 @@ vm_map_ram_test(void)
 	int i;
 
 	map_nr_pages = nr_pages > 0 ? nr_pages:1;
-	pages = kmalloc(map_nr_pages * sizeof(struct page), GFP_KERNEL);
+	pages = kcalloc(map_nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return -1;
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

lib-test_vmallocc-avoid-garbage-in-page-array.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch
mm-mmap-refactor-mlock_future_check.patch

