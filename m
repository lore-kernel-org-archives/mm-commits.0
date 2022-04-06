Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94C6C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 20:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiDFU6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 16:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiDFU5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 16:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0459812B5EA
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 12:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A114CB82544
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 19:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CC7C385A3;
        Wed,  6 Apr 2022 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649272962;
        bh=Tc172shPwQG0QUjtnSHceWrAGYluVqPzk9ySw3iYB5A=;
        h=Date:To:From:Subject:From;
        b=Li9eNhy4xrxeCQwHRNX94KUORLoZeFzuNsAkR+5bCPpzb4rl7zGUxFt/31NZG3VSw
         Ifqdn/kz3JF4waR+WkaAuwgudSygA9TKoRZY/cWBTUCBYMix5WjEsU6SkKDABWYkax
         lkMoxAeCvRKDvRTAVhAwJFNXbZgP9mB/EK8XoFPg=
Date:   Wed, 06 Apr 2022 12:22:41 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pte_marker-swap-entry-fix.patch added to -mm tree
Message-Id: <20220406192242.59CC7C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm: Introduce PTE_MARKER swap entry
has been added to the -mm tree.  Its filename is
     mm-introduce-pte_marker-swap-entry-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-pte_marker-swap-entry-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-pte_marker-swap-entry-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm: Introduce PTE_MARKER swap entry

Link: https://lkml.kernel.org/r/Yk2rdB7SXZf+2BDF@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/s390/include/asm/hugetlb.h~mm-introduce-pte_marker-swap-entry-fix
+++ a/arch/s390/include/asm/hugetlb.h
@@ -85,6 +85,11 @@ static inline int huge_pte_none(pte_t pt
 	return pte_none(pte);
 }
 
+static inline int huge_pte_none_mostly(pte_t pte)
+{
+	return huge_pte_none(pte);
+}
+
 static inline int huge_pte_write(pte_t pte)
 {
 	return pte_write(pte);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-introduce-pte_marker-swap-entry-fix.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-uffd-pte_marker_uffd_wp-fix.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

