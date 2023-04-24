Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB470C77B61
	for <mm-commits@archiver.kernel.org>; Mon, 24 Apr 2023 22:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjDXWJI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbjDXWJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Apr 2023 18:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9397EA5CB
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 15:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F6666297D
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 22:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F9BC4339B;
        Mon, 24 Apr 2023 22:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682374049;
        bh=nU0ARNo8m1HXV1waUzTdYbdsA4oIazOkYnbpawH6nUc=;
        h=Date:To:From:Subject:From;
        b=rr8cYyd3znuK4+0PkTEDOfC2OW/9ZhYFQVFHX3U7GMKfLklbJrIQlMWbQAAe/C0/N
         ogIuWOnjLIruss9IeqQdoW425Mst1UqEHb1twHgOJpM3ofHRbvHxkJNHGa+6G3cRec
         sH4pceOK989IsormhkJ84FNWO9OtgF24MHFxnvlQ=
Date:   Mon, 24 Apr 2023 15:07:28 -0700
To:     mm-commits@vger.kernel.org, stevensd@chromium.org,
        jiaqiyan@google.com, ivan.orlov0322@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-conflicting-mods-to-collapse_file.patch added to mm-unstable branch
Message-Id: <20230424220729.62F9BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix conflicting mods to collapse_file()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-fix-conflicting-mods-to-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-conflicting-mods-to-collapse_file.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/khugepaged: fix conflicting mods to collapse_file()
Date: Sat, 22 Apr 2023 21:47:20 -0700 (PDT)

Inserting Ivan Orlov's syzbot fix commit 2ce0bdfebc74
("mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()")
ahead of Jiaqi Yan's and David Stevens's commits
12904d953364 ("mm/khugepaged: recover from poisoned file-backed memory")
cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
ac492b9c70ca ("mm/khugepaged: skip shmem with userfaultfd")
(all of which restructure collapse_file()) did not work out well.

xfstests generic/086 on huge tmpfs (with accelerated khugepaged) freezes
(if not on the first attempt, then the 2nd or 3rd) in find_lock_entries()
while doing drop_caches: the file's xarray seems to have been corrupted,
with find_get_entry() returning nonsense which makes no progress.

Bisection led to ac492b9c70ca; and diff against earlier working linux-next
suggested that it's probably down to an errant xas_store(), which does not
belong with the later changes (and nor does the positioning of warnings). 
The later changes look as if they fix the syzbot issue independently.

Remove most of what's left of 2ce0bdfebc74: just leave one WARN_ON_ONCE
(xas_error) after the final xas_store() of the multi-index entry.

Link: https://lkml.kernel.org/r/b6c881-c352-bb91-85a8-febeb09dfd71@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-conflicting-mods-to-collapse_file
+++ a/mm/khugepaged.c
@@ -1941,16 +1941,6 @@ static int collapse_file(struct mm_struc
 					result = SCAN_FAIL;
 					goto xa_locked;
 				}
-				xas_store(&xas, hpage);
-				if (xas_error(&xas)) {
-					/* revert shmem_charge performed
-					 * in the previous condition
-					 */
-					mapping->nrpages--;
-					shmem_uncharge(mapping->host, 1);
-					result = SCAN_STORE_FAILED;
-					goto xa_locked;
-				}
 				nr_none++;
 				continue;
 			}
@@ -2105,13 +2095,6 @@ static int collapse_file(struct mm_struc
 		 * Accumulate the pages that are being collapsed.
 		 */
 		list_add_tail(&page->lru, &pagelist);
-
-		/*
-		 * We can't get an ENOMEM here (because the allocation happened
-		 * before) but let's check for errors (XArray implementation
-		 * can be changed in the future)
-		 */
-		WARN_ON_ONCE(xas_error(&xas));
 		continue;
 out_unlock:
 		unlock_page(page);
@@ -2134,11 +2117,6 @@ out_unlock:
 		}
 	}
 
-	/* Here we can't get an ENOMEM (because entries were
-	 * previously allocated) But let's check for errors
-	 * (XArray implementation can be changed in the future)
-	 */
-	WARN_ON_ONCE(xas_error(&xas));
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2259,6 +2237,7 @@ immap_locked:
 	/* Join all the small entries into a single multi-index entry. */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	xas_store(&xas, hpage);
+	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
 
 	/*
_

Patches currently in -mm which might be from hughd@google.com are

mm-khugepaged-fix-conflicting-mods-to-collapse_file.patch

