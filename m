Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0ADC433EF
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiGCWns (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiGCWns (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:43:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081DED0;
        Sun,  3 Jul 2022 15:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB2F1B80CE6;
        Sun,  3 Jul 2022 22:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A582C341C6;
        Sun,  3 Jul 2022 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888224;
        bh=Hqm29/Kx3OmOFJ2j4cLrOBL1mTG//Hw0qPLVpXPmuzo=;
        h=Date:To:From:Subject:From;
        b=jT+URwEFWZqTrY79Vk7puv1Rdhn6ipyXZsSG+vmcX6BlVOKOOVgT/moX1UkHbzMI/
         wnnLZggwqOSuOnG5SyJVup36TNSkWhJuL+46xg3AVRPPm+dqXmmPO986GkCkP48zG1
         DOIzU+95fU7krcFOV8aeuge5CUvoudC8xL3K8fgg=
Date:   Sun, 03 Jul 2022 15:43:43 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, hughd@google.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages.patch removed from -mm tree
Message-Id: <20220703224344.5A582C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
Date: Fri, 10 Jun 2022 10:38:12 -0700

When fallocate() is used on a shmem file, the pages we allocate can end up
with !PageUptodate.

Since UFFDIO_CONTINUE tries to find the existing page the user wants to
map with SGP_READ, we would fail to find such a page, since
shmem_getpage_gfp returns with a "NULL" pagep for SGP_READ if it discovers
!PageUptodate.  As a result, UFFDIO_CONTINUE returns -EFAULT, as it would
do if the page wasn't found in the page cache at all.

This isn't the intended behavior.  UFFDIO_CONTINUE is just trying to find
if a page exists, and doesn't care whether it still needs to be cleared or
not.  So, instead of SGP_READ, pass in SGP_NOALLOC.  This is the same,
except for one critical difference: in the !PageUptodate case, SGP_NOALLOC
will clear the page and then return it.  With this change, UFFDIO_CONTINUE
works properly (succeeds) on a shmem file which has been fallocated, but
otherwise not modified.

Link: https://lkml.kernel.org/r/20220610173812.1768919-1-axelrasmussen@google.com
Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages
+++ a/mm/userfaultfd.c
@@ -246,7 +246,10 @@ static int mcontinue_atomic_pte(struct m
 	struct page *page;
 	int ret;
 
-	ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
+	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
+	/* Our caller expects us to return -EFAULT if we failed to find page. */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	if (ret)
 		goto out;
 	if (!page) {
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-selftests-make-dev-userfaultfd-testing-configurable.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

