Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526B5C61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 18:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345782AbjKXSxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 13:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345717AbjKXSxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 13:53:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5401FD7
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 10:53:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D3C433CA;
        Fri, 24 Nov 2023 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700852006;
        bh=dN9EuxLLWLdovt20JfL1UXoUMuM3Lyfm94gyIUdwJ3c=;
        h=Date:To:From:Subject:From;
        b=0itDGJomuPNRJgZXo/ZxnQqluh3NddXYK6DXtVZwwXaJnPtTV6/fVjXZwsGcRggmQ
         CtHGTpjsxzBVZzc4gXgK805lgodZOfKmGt3tr4P2MVL7EdFfcme9QOWShLe7CQrnsS
         skLKfzS89U8MLvkb6XkNnPgCRxF3EzTQzB5jY9TA=
Date:   Fri, 24 Nov 2023 10:53:25 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-make-userfaultfd-a-menuconfig.patch added to mm-hotfixes-unstable branch
Message-Id: <20231124185326.029D3C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: make userfaultfd a menuconfig
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kconfig-make-userfaultfd-a-menuconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-make-userfaultfd-a-menuconfig.patch

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
Subject: mm/Kconfig: make userfaultfd a menuconfig
Date: Thu, 23 Nov 2023 17:42:04 -0500

PTE_MARKER_UFFD_WP is a subconfig for userfaultfd.  To make it clear,
switch to use menuconfig for userfaultfd.

Link: https://lkml.kernel.org/r/20231123224204.1060152-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/Kconfig~mm-kconfig-make-userfaultfd-a-menuconfig
+++ a/mm/Kconfig
@@ -1201,13 +1201,6 @@ config ANON_VMA_NAME
 	  area from being merged with adjacent virtual memory areas due to the
 	  difference in their name.
 
-config USERFAULTFD
-	bool "Enable userfaultfd() system call"
-	depends on MMU
-	help
-	  Enable the userfaultfd() system call that allows to intercept and
-	  handle page faults in userland.
-
 config HAVE_ARCH_USERFAULTFD_WP
 	bool
 	help
@@ -1218,6 +1211,14 @@ config HAVE_ARCH_USERFAULTFD_MINOR
 	help
 	  Arch has userfaultfd minor fault support
 
+menuconfig USERFAULTFD
+	bool "Enable userfaultfd() system call"
+	depends on MMU
+	help
+	  Enable the userfaultfd() system call that allows to intercept and
+	  handle page faults in userland.
+
+if USERFAULTFD
 config PTE_MARKER_UFFD_WP
 	bool "Userfaultfd write protection support for shmem/hugetlbfs"
 	default y
@@ -1227,6 +1228,7 @@ config PTE_MARKER_UFFD_WP
 	  Allows to create marker PTEs for userfaultfd write protection
 	  purposes.  It is required to enable userfaultfd write protection on
 	  file-backed memory types like shmem and hugetlbfs.
+endif # USERFAULTFD
 
 # multi-gen LRU {
 config LRU_GEN
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch
mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch
mm-selftests-fix-pagemap_ioctl-memory-map-test.patch
mm-kconfig-make-userfaultfd-a-menuconfig.patch
fs-kconfig-make-hugetlbfs-a-menuconfig.patch

