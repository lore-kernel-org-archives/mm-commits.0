Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE49AC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjBJA5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBJAz5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15687431F
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90197B82397
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E060C4339B;
        Fri, 10 Feb 2023 00:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990471;
        bh=QVzPzt+Kavo0fSRvkG8Vd7WKHIPVAQM/79XFe4Az1ak=;
        h=Date:To:From:Subject:From;
        b=vy0a66BTJOLpjW+S9y4LYK6Gw1gj1de57COct9spZjABg9vxeLIEvNvx3rqBv4cWM
         aJmBExa3sZ7znhHvpo0oxjpmc7r+936q2ZK+mCGNpqA3JnQb6k4rGdjyqVX7QLuudb
         aK0vEzznWrH9YAPoVP5GC2bqkheYIa7HD7NNFumc=
Date:   Thu, 09 Feb 2023 16:54:30 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch removed from -mm tree
Message-Id: <20230210005431.2E060C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: don't call __gup_longterm_locked() if FOLL_LONGTERM cannot be set
has been removed from the -mm tree.  Its filename was
     mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: don't call __gup_longterm_locked() if FOLL_LONGTERM cannot be set
Date: Tue, 24 Jan 2023 16:34:24 -0400

get_user_pages_remote(), get_user_pages_unlocked() and get_user_pages()
are never called with FOLL_LONGTERM, so directly call
__get_user_pages_locked()

The next patch will add an assertion for this.

Link: https://lkml.kernel.org/r/3-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set
+++ a/mm/gup.c
@@ -2200,8 +2200,8 @@ long get_user_pages_remote(struct mm_str
 	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
 
-	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas, locked,
-				     gup_flags | FOLL_TOUCH | FOLL_REMOTE);
+	return __get_user_pages_locked(mm, start, nr_pages, pages, vmas, locked,
+				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
 
@@ -2238,8 +2238,8 @@ long get_user_pages(unsigned long start,
 	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
 
-	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, NULL, gup_flags | FOLL_TOUCH);
+	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
+				       vmas, NULL, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages);
 
@@ -2263,8 +2263,8 @@ long get_user_pages_unlocked(unsigned lo
 {
 	int locked = 0;
 
-	return __gup_longterm_locked(current->mm, start, nr_pages, pages, NULL,
-				     &locked, gup_flags | FOLL_TOUCH);
+	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
+				       NULL, &locked, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
_

Patches currently in -mm which might be from jgg@nvidia.com are


