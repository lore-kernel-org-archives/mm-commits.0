Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72C1C64EC7
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 21:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjBOVDX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 16:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjBOVDF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 16:03:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225FA4344F
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 13:01:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A127B823B0
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 21:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF911C4339B;
        Wed, 15 Feb 2023 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676494878;
        bh=om0pEF47+tHx6gx//7Ymn/aSr/JXqU14QdRuT46oosY=;
        h=Date:To:From:Subject:From;
        b=tvpwdrUHQuLRb64u2Ekdz5OsYU3S2HaYAgA6LmZzSC+3wsA3F2HhwS3aWHzNDTl2i
         vElZOI/fS9cH1e3piliIDoEkCRVO9tqfXqNvgf0ySnzMcKCd57AusHvTEe4rS5kHZw
         Bd7LaDlQmE0k1YJaFlBWwX+c7nJ77FhrY30bzM3U=
Date:   Wed, 15 Feb 2023 13:01:18 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-fix-comment-in-handling-pte-markers.patch added to mm-unstable branch
Message-Id: <20230215210118.BF911C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: fix comment in handling pte markers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-uffd-fix-comment-in-handling-pte-markers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-fix-comment-in-handling-pte-markers.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: fix comment in handling pte markers
Date: Wed, 15 Feb 2023 15:58:00 -0500

The comment is obsolete after f369b07c8614 ("mm/uffd: reset write
protection when unregister with wp-mode", 2022-08-20).  Remove it.

Link: https://lkml.kernel.org/r/20230215205800.223549-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-uffd-fix-comment-in-handling-pte-markers
+++ a/mm/memory.c
@@ -3627,9 +3627,7 @@ static vm_fault_t pte_marker_handle_uffd
 {
 	/*
 	 * Just in case there're leftover special ptes even after the region
-	 * got unregistered - we can simply clear them.  We can also do that
-	 * proactively when e.g. when we do UFFDIO_UNREGISTER upon some uffd-wp
-	 * ranges, but it should be more efficient to be done lazily here.
+	 * got unregistered - we can simply clear them.
 	 */
 	if (unlikely(!userfaultfd_wp(vmf->vma) || vma_is_anonymous(vmf->vma)))
 		return pte_marker_clear(vmf);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-comment-in-handling-pte-markers.patch

