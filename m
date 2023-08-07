Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F5EC04A94
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjHGQ2u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjHGQ22 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:28:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCBC1730
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F013161F1B
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E162C433CB;
        Mon,  7 Aug 2023 16:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691425691;
        bh=r3uSI1TiNep30ZchRxsvSRmdYwLcYo2TJ0r/6dCKJcw=;
        h=Date:To:From:Subject:From;
        b=AUmQvOtOzuyOzg4skFVH9oCViF7oEvFYyb2oVbO1ZPwVkv+f7RR1T2oUgy9GtsBV1
         gRTn9r0AvbuftXJHSvBXCicip+LTVHP46PNYONZVgxpJh2+aP/OFoGccfCrw5T4D6f
         LiZqXALa4mXZWu6OxYjhwhiQWhyjozcCEppr4cEk=
Date:   Mon, 07 Aug 2023 09:28:10 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2.patch added to mm-unstable branch
Message-Id: <20230807162811.4E162C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock(): fix2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2.patch

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
Subject: mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock(): fix2
Date: Sat, 5 Aug 2023 20:59:27 -0700 (PDT)

Use ptep_clear() instead of pte_clear(): when CONFIG_PAGE_TABLE_CHECK=y,
ptep_clear() adds some accounting, missing which would cause a BUG later.

Link: https://lkml.kernel.org/r/e0197433-8a47-6a65-534d-eda26eeb78b0@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Qi Zheng <zhengqi.arch@bytedance.com>
Closes: https://lore.kernel.org/linux-mm/0df84f9f-e9b0-80b1-4c9e-95abc1a73a96@bytedance.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2
+++ a/mm/khugepaged.c
@@ -1655,7 +1655,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		 * TLB flush can be left until pmdp_collapse_flush() does it.
 		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
-		pte_clear(mm, addr, pte);
+		ptep_clear(mm, addr, pte);
 		page_remove_rmap(page, vma, false);
 		nr_ptes++;
 	}
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
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

