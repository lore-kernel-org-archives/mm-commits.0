Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1980DC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBJA5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBJAz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF326D8F6
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E447B822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F3C4339C;
        Fri, 10 Feb 2023 00:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990475;
        bh=/8+gXnO327Z7nwyRjPRA0m7+C+XUmGIEPRjLppjXF0M=;
        h=Date:To:From:Subject:From;
        b=tuAtO5TAgLnxAoKa219SPfZU1DCf8F5CJqZOTWlG5zxOdKEmo3M5KaskgZpIY6wN9
         ohYK96/kp06XKEJpDE/4NEuggM+vEs6g1hGwqQ2eTx/kNvgyqEjZXgvZxIk1HtiFkW
         1yk1oJA3Wm17nY4wott6EnnySu+tpu4QWH1pSvrQ=
Date:   Thu, 09 Feb 2023 16:54:35 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch removed from -mm tree
Message-Id: <20230210005435.CA7F3C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: add an assertion that the mmap lock is locked
has been removed from the -mm tree.  Its filename was
     mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

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


