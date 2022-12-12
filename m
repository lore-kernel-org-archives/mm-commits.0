Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8F2C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 20:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiLLUny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 15:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiLLUnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 15:43:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965F91836E
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 12:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55E0CB80E0E
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 20:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D28C433D2;
        Mon, 12 Dec 2022 20:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670877829;
        bh=x6GDNOL/NsCGq749ijXZRxDVKvvCv2HWOpa87zybhog=;
        h=Date:To:From:Subject:From;
        b=UjdHIg/6pAoqaRh+oYnoSoREnw4obMrTFBJIn4oxyJ8sX7sOO18xwQ73B5tA4qnzl
         da+EtL8h5oAc4o6myXSTFPRM97eAOnTHUrMx6Enni4pEE+VVdOrlKs3VHVN+Gk0HSu
         pObgbPuSOUe5r+gNDfOMjHbDOYAYwLeDcjs+vJLg=
Date:   Mon, 12 Dec 2022 12:43:48 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, julia.lawall@lip6.fr,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree.patch added to mm-unstable branch
Message-Id: <20221212204348.E6D28C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test: free memory allocated via kvcalloc() using kvfree()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup_test: free memory allocated via kvcalloc() using kvfree()
Date: Mon, 12 Dec 2022 19:20:18 +0100

We have to free via kvfree(), not via kfree().

Link: https://lkml.kernel.org/r/20221212182018.264900-1-david@redhat.com
Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree
+++ a/mm/gup_test.c
@@ -214,7 +214,7 @@ static inline void pin_longterm_test_sto
 		if (pin_longterm_test_nr_pages)
 			unpin_user_pages(pin_longterm_test_pages,
 					 pin_longterm_test_nr_pages);
-		kfree(pin_longterm_test_pages);
+		kvfree(pin_longterm_test_pages);
 		pin_longterm_test_pages = NULL;
 		pin_longterm_test_nr_pages = 0;
 	}
@@ -255,7 +255,7 @@ static inline int pin_longterm_test_star
 	fast = !!(args.flags & PIN_LONGTERM_TEST_FLAG_USE_FAST);
 
 	if (!fast && mmap_read_lock_killable(current->mm)) {
-		kfree(pages);
+		kvfree(pages);
 		return -EINTR;
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup_test-free-memory-allocated-via-kvcalloc-using-kvfree.patch

