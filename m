Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D34DC7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbjFGCnG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbjFGCnD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:43:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5F510D2
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42FDC62FB7
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE37C433D2;
        Wed,  7 Jun 2023 02:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105780;
        bh=v17GEAZxx3A5Tg13OUvtqyZ3f9IEkcqmUmkXj2CKLhU=;
        h=Date:To:From:Subject:From;
        b=XSTvcEd7VzR5mpvOejubBVybhAxtsMWRKZsm9IUnZ30eQFCZvsMyl3Ry8X+kqvMVL
         0EJVC+lTyd0jJ3OYLKVE5ZOsuCctj28rFtRPI/uD1SCJFfN7rs1/+sgnnNgyHQ6UOC
         2L9+XnROcMrfxEWHGCc6B6la97KSXYc8Gcm9DqP8=
Date:   Tue, 06 Jun 2023 19:42:59 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        lstoakes@gmail.com, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, david@redhat.com, axboe@kernel.dk,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch added to mm-unstable branch
Message-Id: <20230607024300.9AE37C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix
Date: Tue Jun  6 07:41:28 PM PDT 2023

update .gitignore for gup_longterm, per Peter

Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -39,3 +39,4 @@ local_config.h
 local_config.mk
 ksm_functional_tests
 mdwe_test
+gup_longterm
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-mm_initc-remove-reset_node_present_pages-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

