Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1640DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357129AbiDTVpR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347565AbiDTVpO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5833DDC6
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A38561972
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919F2C385A1;
        Wed, 20 Apr 2022 21:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650490946;
        bh=x2zDscKFmU07wu/zycRQfl+P7A0Zi9rprIULev6PTGc=;
        h=Date:To:From:Subject:From;
        b=iYcT/8MfwrkhxxbDh1svDtK5nqSxQeJEOlYii+6YiPMw8kKbhuBDFh/jBsa8iB3Qx
         qtdgcr/SsXcYZUnqMVcHhFYWfumUVJYPEF8wH9n+eXOHs63Ma1V9Ql8GGu1C1vscN1
         ABuUw7x6/0mwQDYXzzVNirScobHJA7Lh7i6WNVNA=
Date:   Wed, 20 Apr 2022 14:42:25 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-move-userfaultfd-configs-into-mm.patch added to -mm tree
Message-Id: <20220420214226.919F2C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: move USERFAULTFD configs into mm/
has been added to the -mm tree.  Its filename is
     mm-uffd-move-userfaultfd-configs-into-mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-uffd-move-userfaultfd-configs-into-mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-uffd-move-userfaultfd-configs-into-mm.patch

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
Subject: mm/uffd: move USERFAULTFD configs into mm/

We used to have USERFAULTFD configs stored in init/.  It makes sense as a
start because that's the default place for storing syscall related
configs.

However userfaultfd evolved a bit in the past few years and some more
config options were added.  They're no longer related to syscalls and
start to be not suitable to be kept in the init/ directory anymore,
because they're pure mm concepts.

But it's not ideal either to keep the userfaultfd configs separate from
each other.  Hence this patch moves the userfaultfd configs under init/ to
be under mm/ so that we'll start to group all userfaultfd configs
together.

We do have quite a few examples of syscall related configs that are not
put under init/Kconfig: FTRACE_SYSCALLS, SWAP, FILE_LOCKING,
MEMFD_CREATE..  They all reside in the dir where they're more suitable for
the concept.  So it seems there's no restriction to keep the role of
having syscall related CONFIG_* under init/ only.

Link: https://lkml.kernel.org/r/20220420144823.35277-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   17 -----------------
 mm/Kconfig   |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/init/Kconfig~mm-uffd-move-userfaultfd-configs-into-mm
+++ a/init/Kconfig
@@ -1667,16 +1667,6 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
-config HAVE_ARCH_USERFAULTFD_WP
-	bool
-	help
-	  Arch has userfaultfd write protection support
-
-config HAVE_ARCH_USERFAULTFD_MINOR
-	bool
-	help
-	  Arch has userfaultfd minor fault support
-
 config MEMBARRIER
 	bool "Enable membarrier() system call" if EXPERT
 	default y
@@ -1741,13 +1731,6 @@ config KALLSYMS_BASE_RELATIVE
 
 # syscall, maps, verifier
 
-config USERFAULTFD
-	bool "Enable userfaultfd() system call"
-	depends on MMU
-	help
-	  Enable the userfaultfd() system call that allows to intercept and
-	  handle page faults in userland.
-
 config ARCH_HAS_MEMBARRIER_CALLBACKS
 	bool
 
--- a/mm/Kconfig~mm-uffd-move-userfaultfd-configs-into-mm
+++ a/mm/Kconfig
@@ -909,6 +909,23 @@ config ANON_VMA_NAME
 	  area from being merged with adjacent virtual memory areas due to the
 	  difference in their name.
 
+config USERFAULTFD
+	bool "Enable userfaultfd() system call"
+	depends on MMU
+	help
+	  Enable the userfaultfd() system call that allows to intercept and
+	  handle page faults in userland.
+
+config HAVE_ARCH_USERFAULTFD_WP
+	bool
+	help
+	  Arch has userfaultfd write protection support
+
+config HAVE_ARCH_USERFAULTFD_MINOR
+	bool
+	help
+	  Arch has userfaultfd minor fault support
+
 config PTE_MARKER
 	bool
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-remove-stub-for-non_swap_entry.patch
mm-introduce-pte_marker-swap-entry.patch
mm-introduce-pte_marker-swap-entry-fix.patch
mm-teach-core-mm-about-pte-markers.patch
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

