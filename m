Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626DFC7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjFJAgN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFJAgM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:36:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A15430D2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1674060C24
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B428C433D2;
        Sat, 10 Jun 2023 00:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357370;
        bh=gA1y6rd5w13D/+EU884Eg/fCjzE/gEMPt486vnptwnI=;
        h=Date:To:From:Subject:From;
        b=xUcA5MYvjjqRr5s7A2vrDVUKAFXc71olHXMBJ6TA/1Yde84Ee0gtDzDAOklSZPXX+
         zCHD7ffpCilr1zWo12lGeKkSBfO2r3MDakr1fGmT3ES9C/GCvcQw8AYFJf0UZY+bH2
         IkkrA7FcmJdFCumPvGjhlBAwkgpIOR3T5hyIQ2Ok=
Date:   Fri, 09 Jun 2023 17:36:09 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        lkp@intel.com, holzheu@linux.vnet.ibm.com, ebiederm@xmission.com,
        bhe@redhat.com, amwang@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec-add-helper-__crash_shrink_memory-fix.patch removed from -mm tree
Message-Id: <20230610003610.6B428C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec-add-helper-__crash_shrink_memory-fix
has been removed from the -mm tree.  Its filename was
     kexec-add-helper-__crash_shrink_memory-fix.patch

This patch was dropped because it was folded into kexec-add-helper-__crash_shrink_memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-add-helper-__crash_shrink_memory-fix
Date: Tue May 30 03:04:55 PM PDT 2023

make  __crash_shrink_memory() static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305280717.Pw06aLkz-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kexec-add-helper-__crash_shrink_memory-fix
+++ a/kernel/kexec_core.c
@@ -1105,7 +1105,8 @@ ssize_t crash_get_memory_size(void)
 	return size;
 }
 
-int __crash_shrink_memory(struct resource *old_res, unsigned long new_size)
+static int __crash_shrink_memory(struct resource *old_res,
+				 unsigned long new_size)
 {
 	struct resource *ram_res;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
kexec-add-helper-__crash_shrink_memory.patch

