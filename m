Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1795CC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbiDXUdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiDXUdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:33:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2B635264
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 972B8B80E45
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6A5C385A9;
        Sun, 24 Apr 2022 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650832213;
        bh=KhGanGLnbFr670Al1Koe/0c2FcB2SKr1Um/NNdLjICM=;
        h=Date:To:From:Subject:From;
        b=ivaA8ofQw9qzhB3HAsf6zVJ8sKTnBb4VpKKtZ9JkklrSbrhP/HkTLR/VdNxxQe2s+
         bPVwNn0Jlhhzpj8E4/2lOJA5JtrpRhWgMt3tPLlvsfhKu7HNfG5g5bvpbMXJo+RoUz
         nBNiEX9L/rzQ7q10cQi+de9ygYhnPn1NPpTXzAUY=
Date:   Sun, 24 Apr 2022 13:30:12 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-teach-core-mm-about-pte-markers-fix.patch added to -mm tree
Message-Id: <20220424203013.4B6A5C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm: Teach core mm about pte markers
has been added to the -mm tree.  Its filename is
     mm-teach-core-mm-about-pte-markers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-teach-core-mm-about-pte-markers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-teach-core-mm-about-pte-markers-fix.patch

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
Subject: fixup! mm: Teach core mm about pte markers

userfaultfd.c needs swapops.h

Link: https://lkml.kernel.org/r/YmRlVj3cdizYJsr0@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/userfaultfd.c~mm-teach-core-mm-about-pte-markers-fix
+++ a/fs/userfaultfd.c
@@ -29,6 +29,7 @@
 #include <linux/ioctl.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
+#include <linux/swapops.h>
 
 int sysctl_unprivileged_userfaultfd __read_mostly;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-remove-stub-for-non_swap_entry.patch
mm-introduce-pte_marker-swap-entry.patch
mm-introduce-pte_marker-swap-entry-fix.patch
mm-teach-core-mm-about-pte-markers.patch
mm-teach-core-mm-about-pte-markers-fix.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-check-against-orig_pte-for-finish_fault-fix.patch
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
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
mm-enable-pte-markers-by-default-fix.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch
mm-uffd-move-userfaultfd-configs-into-mm.patch

