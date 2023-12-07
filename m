Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5081C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442082AbjLGANe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441939AbjLGAN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1F9AC
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C372C433C9;
        Thu,  7 Dec 2023 00:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908015;
        bh=MQyeeFXqwjSCAPyWLht7tZ/ymCHXbfxE9OqxIN/q7Vw=;
        h=Date:To:From:Subject:From;
        b=1HDolLS/klFeZATzIaFSbgKFEo4zNjPXrRwdvl+fO0UpKoP2MPYbJxTY6ADSBnEck
         i1etBOgnHlwywpZiKgT2xeMqp2T/t+h4vVDVFgt/2qrPVpAVFF/vzxSNf8/I8VUK3N
         FGUOa+lVCK1NG1epNyt6dax5NAHzA8o9bZH99LFc=
Date:   Wed, 06 Dec 2023 16:13:35 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kconfig-make-userfaultfd-a-menuconfig.patch removed from -mm tree
Message-Id: <20231207001335.9C372C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/Kconfig: make userfaultfd a menuconfig
has been removed from the -mm tree.  Its filename was
     mm-kconfig-make-userfaultfd-a-menuconfig.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fs-kconfig-make-hugetlbfs-a-menuconfig.patch
mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

