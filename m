Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25C5C41513
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjG0UHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjG0UHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D916E211F
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 13:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 599D761F2C
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 20:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE89CC433C8;
        Thu, 27 Jul 2023 20:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488462;
        bh=tpalYUZwdSuh4ahXMs7HbzEQ3+5W377NWYqfjaEBYWo=;
        h=Date:To:From:Subject:From;
        b=JO90TBtATiOs4XjnIxcj+J0PxPJMUvgNJ32nfJkHNL1VD40QcxRceQZ+IbFDQupsi
         /szRLlugh78xlX4e2sqecJ6R4WJ3CQ7sOrrAUxhWn7Nd5uk9SCa1mkd/R9eXD5TyHY
         d89qTqm9G8j03asmDwyT3s7rDf94cDDnykveyjtQ=
Date:   Thu, 27 Jul 2023 13:07:42 -0700
To:     mm-commits@vger.kernel.org, dhowells@redhat.com, david@redhat.com,
        axboe@kernel.dk, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] shmem-minor-fixes-to-splice-read-implementation.patch removed from -mm tree
Message-Id: <20230727200742.AE89CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: minor fixes to splice-read implementation
has been removed from the -mm tree.  Its filename was
     shmem-minor-fixes-to-splice-read-implementation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: minor fixes to splice-read implementation
Date: Sun, 23 Jul 2023 14:05:54 -0700 (PDT)

HWPoison: my reading of folio_test_hwpoison() is that it only tests the
head page of a large folio, whereas splice_folio_into_pipe() will splice
as much of the folio as it can: so for safety we should also check the
has_hwpoisoned flag, set if any of the folio's pages are hwpoisoned. 
(Perhaps that ugliness can be improved at the mm end later.)

The call to splice_zeropage_into_pipe() risked overrunning past EOF: ask
it for "part" not "len".

Link: https://lkml.kernel.org/r/32c72c9c-72a8-115f-407d-f0148f368@google.com
Fixes: bd194b187115 ("shmem: Implement splice-read")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~shmem-minor-fixes-to-splice-read-implementation
+++ a/mm/shmem.c
@@ -2796,7 +2796,8 @@ static ssize_t shmem_file_splice_read(st
 		if (*ppos >= i_size_read(inode))
 			break;
 
-		error = shmem_get_folio(inode, *ppos / PAGE_SIZE, &folio, SGP_READ);
+		error = shmem_get_folio(inode, *ppos / PAGE_SIZE, &folio,
+					SGP_READ);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
@@ -2805,7 +2806,9 @@ static ssize_t shmem_file_splice_read(st
 		if (folio) {
 			folio_unlock(folio);
 
-			if (folio_test_hwpoison(folio)) {
+			if (folio_test_hwpoison(folio) ||
+			    (folio_test_large(folio) &&
+			     folio_test_has_hwpoisoned(folio))) {
 				error = -EIO;
 				break;
 			}
@@ -2841,7 +2844,7 @@ static ssize_t shmem_file_splice_read(st
 			folio_put(folio);
 			folio = NULL;
 		} else {
-			n = splice_zeropage_into_pipe(pipe, *ppos, len);
+			n = splice_zeropage_into_pipe(pipe, *ppos, part);
 		}
 
 		if (!n)
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock-fix.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
s390-add-pte_free_defer-for-pgtables-sharing-page-fix.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

