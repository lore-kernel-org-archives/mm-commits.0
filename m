Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F27C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiLAAIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiLAAGJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141A395811
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E2D761E6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFE7C43470;
        Thu,  1 Dec 2022 00:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852944;
        bh=Y3QD5x8LV++Ly0A6blGTU7Rog70AVQvfwNWzIb0f6NI=;
        h=Date:To:From:Subject:From;
        b=ROZyCeFm+8ojeV1eD7RlZW3fl0GFvQmT6vZoqfzZP3IBfXW2FKHWiDfsgdVNiGoUL
         627yiTlGzgidwh+1/ravS0KWx6rep+a49bkbznpcihuRhLQHn/vBW7/DEA2JJ0EnIL
         MQaUb87ohAX5dUupdbxvzt+32QEfg9CZ6XzeNEK0=
Date:   Wed, 30 Nov 2022 16:02:24 -0800
To:     mm-commits@vger.kernel.org, ogabbay@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] habanalabs-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000224.CAFE7C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: habanalabs: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     habanalabs-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: habanalabs: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:58 +0100

FOLL_FORCE is really only for ptrace access. As we unpin the pinned pages
using unpin_user_pages_dirty_lock(true), the assumption is that all these
pages are writable.

FOLL_FORCE in this case seems to be due to copy-and-past from other
drivers. Let's just remove it.

Link: https://lkml.kernel.org/r/20221116102659.70287-20-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Oded Gabbay <ogabbay@kernel.org>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/habanalabs/common/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/misc/habanalabs/common/memory.c~habanalabs-remove-foll_force-usage
+++ a/drivers/misc/habanalabs/common/memory.c
@@ -2312,8 +2312,7 @@ static int get_user_memory(struct hl_dev
 	if (!userptr->pages)
 		return -ENOMEM;
 
-	rc = pin_user_pages_fast(start, npages,
-				 FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
+	rc = pin_user_pages_fast(start, npages, FOLL_WRITE | FOLL_LONGTERM,
 				 userptr->pages);
 
 	if (rc != npages) {
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

