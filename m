Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF0DC001DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjGXQnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjGXQnl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:43:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA7E4F
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 347C96126E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B6FC433C8;
        Mon, 24 Jul 2023 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690217019;
        bh=+2doIWf8+GQ52QfU6UzeeLX3AT9SGxOXwnAfQLLObIg=;
        h=Date:To:From:Subject:From;
        b=i4Pwr4Z18kwNc5PN1q6rMda3qIk1EpuQAW/NdbdUasRHH2f+fATOhhlQADJUG9z9p
         b7PEfjAeM7hqxjuiF2ij4RjydSyifwCNNVGnnJmNIIUS9DyOZIO+Zjx4ljBD+zDgzB
         ho4NNfq9xC4v5SW9Gk5Z/sxZB3jKfXm5k9FvRTs0=
Date:   Mon, 24 Jul 2023 09:43:23 -0700
To:     mm-commits@vger.kernel.org, dhowells@redhat.com, david@redhat.com,
        axboe@kernel.dk, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-minor-fixes-to-splice-read-implementation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230724164339.87B6FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: minor fixes to splice-read implementation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     shmem-minor-fixes-to-splice-read-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-minor-fixes-to-splice-read-implementation.patch

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

tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch
shmem-minor-fixes-to-splice-read-implementation.patch
mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

