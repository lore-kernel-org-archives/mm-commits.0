Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E05FC636D6
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBGB3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjBGB3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598542C640
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10C57B8167B
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A050DC4339E;
        Tue,  7 Feb 2023 01:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733378;
        bh=Ufg3qo58FdUFhzLRNyxTUwHEmWfrLT/1HD82w57Atg4=;
        h=Date:To:From:Subject:From;
        b=2WCyOMbLNnGL7YLFSn4zEBCzVeb+pSR9WmAYvtKHiXZtJr+gqNq6CB31fxLD8KMkV
         0iuqIxz7qV+wQcIEwaN8pzZPYWT68R5g0J/Dwy/XpVICN+1t+Qi9RvlPMvhZHbgiN5
         +3chk/ufwJ3ktm3gM34kZ8o1gIK7eyRkECZcim0M=
Date:   Mon, 06 Feb 2023 17:29:38 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch added to mm-unstable branch
Message-Id: <20230207012938.A050DC4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add an assertion that the mmap lock is locked
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch

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
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: add an assertion that the mmap lock is locked
Date: Tue, 24 Jan 2023 16:34:27 -0400

Since commit 5b78ed24e8ec ("mm/pagemap: add mmap_assert_locked()
annotations to find_vma*()") we already have this assertion, it is just
buried in find_vma():

 __get_user_pages_locked()
  __get_user_pages()
  find_extend_vma()
   find_vma()

Also check it at the top of __get_user_pages_locked() as a form of
documentation.

Link: https://lkml.kernel.org/r/6-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gup-add-an-assertion-that-the-mmap-lock-is-locked
+++ a/mm/gup.c
@@ -1360,6 +1360,8 @@ static __always_inline long __get_user_p
 		must_unlock = true;
 		*locked = 1;
 	}
+	else
+		mmap_assert_locked(mm);
 
 	if (flags & FOLL_PIN)
 		mm_set_has_pinned_flag(&mm->flags);
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-have-internal-functions-get-the-mmap_read_lock.patch
mm-gup-remove-obsolete-foll_longterm-comment.patch
mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch
mm-gup-move-try_grab_page-to-mm-internalh.patch
mm-gup-simplify-the-external-interface-functions-and-consolidate-invariants.patch
mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch
mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch
mm-gup-add-foll_unlockable.patch
mm-gup-make-locked-never-null-in-the-internal-gup-functions.patch
mm-gup-remove-pin_user_pages_fast_only.patch
mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch
mm-gup-move-gup_must_unshare-to-mm-internalh.patch
mm-gup-move-private-gup-foll_-flags-to-internalh.patch

