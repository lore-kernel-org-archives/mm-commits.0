Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FBDC54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjAPUfT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjAPUfQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:35:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E48E2B29B
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:35:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D171B81060
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA25C433EF;
        Mon, 16 Jan 2023 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673901311;
        bh=J2+FMCIjEWVOGN++htGgPAYXegJWfHMgI4sjFoBwa1I=;
        h=Date:To:From:Subject:From;
        b=1Nsb0GyTgK74/xGlvWXRLiArCEU6WC2Isnb+iUVG7TzphRx5Qmu/bq4wI/qh4xb7j
         AvwkU5xyjkjgp4dQHpObSCQOSAEe4ascVJ6WBZZ4UKk5V/D0TxRGUvW/LCIuHzQdfg
         ouMsLYrnZWbdZ+qogsnkUu2kOHcyzMJP87ZWBfzA=
Date:   Mon, 16 Jan 2023 12:35:11 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com, lkp@intel.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch added to mm-hotfixes-unstable branch
Message-Id: <20230116203511.AEA25C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: remove __USE_GNU in hugetlb-madvise.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/vm: remove __USE_GNU in hugetlb-madvise.c
Date: Mon, 16 Jan 2023 11:33:07 -0500

__USE_GNU should be an internal macro only used inside glibc.  Either
memfd_create() or fallocate() requires _GNU_SOURCE per man page, where
__USE_GNU will further be defined by glibc headers include/features.h:

  #ifdef _GNU_SOURCE
  # define __USE_GNU	1
  #endif

This fixes:

   >> hugetlb-madvise.c:20: warning: "__USE_GNU" redefined
      20 | #define __USE_GNU
         |
   In file included from /usr/include/x86_64-linux-gnu/bits/libc-header-start.h:33,
                    from /usr/include/stdlib.h:26,
                    from hugetlb-madvise.c:16:
   /usr/include/features.h:407: note: this is the location of the previous definition
     407 | # define __USE_GNU      1
         |

Link: https://lkml.kernel.org/r/Y8V9z+z6Tk7NetI3@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/hugetlb-madvise.c~selftests-vm-remove-__use_gnu-in-hugetlb-madvisec
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -17,7 +17,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
-#define __USE_GNU
 #include <fcntl.h>
 
 #define MIN_FREE_PAGES	20
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch
mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch
selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch
mm-uffd-always-wr-protect-pte-in-ptepmd_mkuffd_wp.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-mprotect-use-long-for-page-accountings-and-retval.patch
mm-uffd-detect-pgtable-allocation-failures.patch

