Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB9AC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 01:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiKJBLS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiKJBLS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 20:11:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED2720BFD
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 17:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A386B81F37
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 01:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FF1C433D6;
        Thu, 10 Nov 2022 01:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668042674;
        bh=0SRKR5X29VxBfqIj9WCaSM6Ln+tHaE6udlKfuPIYg80=;
        h=Date:To:From:Subject:From;
        b=HfNPPwDu4yGPqnBRrAYkq0MMyxUcXpW4QhzZc/30olRlKkAl8RqodLxiN/G34Ado2
         XXXI7xXwAaEuG8uwS1J1rQ8ObH+U8UIVLo+g/3mZNOcfxy94ZXxKgw8PrPAdKX67Qo
         5aP7HCuWwgq8WG5tBbu1EOGpj+F25qlosi414QgU=
Date:   Wed, 09 Nov 2022 17:11:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mhocko@suse.com,
        manfred@colorfullife.com, linmiaohe@huawei.com,
        ebiederm@xmission.com, doug.nelson@intel.com,
        alexander.mikhalitsyn@virtuozzo.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-call-underlying-open-close-vm_ops.patch added to mm-hotfixes-unstable branch
Message-Id: <20221110011114.28FF1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: call underlying open/close vm_ops
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ipc-shm-call-underlying-open-close-vm_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-call-underlying-open-close-vm_ops.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: ipc/shm: call underlying open/close vm_ops
Date: Wed, 9 Nov 2022 16:21:50 -0800

Shared memory segments can be created that are backed by hugetlb pages.
When this happens, the vmas associated with any mappings (shmat) are
marked VM_HUGETLB, yet the vm_ops for such mappings are provided by
ipc/shm (shm_vm_ops).  There is a mechanism to call the underlying
hugetlb vm_ops, and this is done for most operations.  However, it is
not done for open and close.

This was not an issue until the introduction of the hugetlb vma_lock.
This lock structure is pointed to by vm_private_data and the open/close
vm_ops help maintain this structure.  The special hugetlb routine
called at fork took care of structure updates at fork time.  However,
vma_splitting is not properly handled for ipc shared memory mappings
backed by hugetlb pages.  This can result in a "kernel NULL pointer
dereference" BUG or use after free as two vmas point to the same lock
structure.

Update the shm open and close routines to always call the underlying
open and close routines.

Link: https://lkml.kernel.org/r/20221110002150.440055-1-mike.kravetz@oracle.com
Fixes: 8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Doug Nelson <doug.nelson@intel.com>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/ipc/shm.c~ipc-shm-call-underlying-open-close-vm_ops
+++ a/ipc/shm.c
@@ -302,7 +302,15 @@ static int __shm_open(struct vm_area_str
 /* This is called by fork, once for every shm attach. */
 static void shm_open(struct vm_area_struct *vma)
 {
-	int err = __shm_open(vma);
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+	int err;
+
+	/* Always call underlying open if present */
+	if (sfd->vm_ops->open)
+		sfd->vm_ops->open(vma);
+
+	err = __shm_open(vma);
 	/*
 	 * We raced in the idr lookup or with shm_destroy().
 	 * Either way, the ID is busted.
@@ -366,6 +374,10 @@ static void shm_close(struct vm_area_str
 	struct shmid_kernel *shp;
 	struct ipc_namespace *ns = sfd->ns;
 
+	/* Always call underlying close if present */
+	if (sfd->vm_ops->close)
+		sfd->vm_ops->close(vma);
+
 	down_write(&shm_ids(ns).rwsem);
 	/* remove from the list of attaches of the shm segment */
 	shp = shm_lock(ns, sfd->id);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

ipc-shm-call-underlying-open-close-vm_ops.patch
hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
selftests-vm-update-hugetlb-madvise.patch

