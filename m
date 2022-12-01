Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C7EC4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiLAAIN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiLAAGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F93195813
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D115B81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EA2C433B5;
        Thu,  1 Dec 2022 00:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852943;
        bh=Q/vlSXGKG7lMUf5WbU6H51wK1MCUWLUKZ/z0FAL6F6g=;
        h=Date:To:From:Subject:From;
        b=pL1FMWtAZ3ZjDpZjIZ0ZbszrPe77CZRBRZfb2ZkXOw2tEYwKkKiisfE7Jua0fY/IY
         L6Hg6enyjro9eRuG19sj0J2uX8D8oSPeI699DrpqURVto5I2s3kOid6+K/mTVfDe3u
         7pxoRaOIC08desLaXVIIcz+2ei58jIlSVWTXsk8g=
Date:   Wed, 30 Nov 2022 16:02:23 -0800
To:     mm-commits@vger.kernel.org, leon@kernel.org, jgg@ziepe.ca,
        dennis.dalessandro@cornelisnetworks.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000223.A3EA2C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: RDMA/hw/qib/qib_user_pages: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: RDMA/hw/qib/qib_user_pages: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:57 +0100

FOLL_FORCE is really only for ptrace access. As we unpin the pinned pages
using unpin_user_pages_dirty_lock(true), the assumption is that all these
pages are writable.

FOLL_FORCE in this case seems to be a legacy leftover. Let's just remove
it.

Link: https://lkml.kernel.org/r/20221116102659.70287-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib_user_pages.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_user_pages.c~rdma-hw-qib-qib_user_pages-remove-foll_force-usage
+++ a/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -110,7 +110,7 @@ int qib_get_user_pages(unsigned long sta
 	for (got = 0; got < num_pages; got += ret) {
 		ret = pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
-				     FOLL_LONGTERM | FOLL_WRITE | FOLL_FORCE,
+				     FOLL_LONGTERM | FOLL_WRITE,
 				     p + got, NULL);
 		if (ret < 0) {
 			mmap_read_unlock(current->mm);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

